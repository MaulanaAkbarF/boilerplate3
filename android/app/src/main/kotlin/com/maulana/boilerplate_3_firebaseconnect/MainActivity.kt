package com.maulana.boilerplate_3_firebaseconnect

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothProfile
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "bluetooth_system_operations"
    private lateinit var bluetoothAdapter: BluetoothAdapter

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Initialize Bluetooth Adapter
        try {
            bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        } catch (e: Exception) {
            // Handle case where Bluetooth is not available
            println("Bluetooth not available: ${e.message}")
        }

        // Set up Method Channel for Bluetooth System Operations
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "pairDevice" -> {
                    val address = call.argument<String>("address")
                    if (address != null) {
                        pairDevice(address, result)
                    } else {
                        result.error("INVALID_ARGUMENT", "Address is required", null)
                    }
                }
                "unpairDevice" -> {
                    val address = call.argument<String>("address")
                    if (address != null) {
                        unpairDevice(address, result)
                    } else {
                        result.error("INVALID_ARGUMENT", "Address is required", null)
                    }
                }
                "isBluetoothEnabled" -> {
                    try {
                        val isEnabled = ::bluetoothAdapter.isInitialized && bluetoothAdapter.isEnabled
                        result.success(isEnabled)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                "getConnectedDevices" -> {
                    getConnectedDevices(result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getConnectedDevices(result: MethodChannel.Result) {
        try {
            // Check if Bluetooth adapter is initialized and enabled
            if (!::bluetoothAdapter.isInitialized) {
                result.error("BLUETOOTH_NOT_AVAILABLE", "Bluetooth adapter not available", null)
                return
            }

            if (!bluetoothAdapter.isEnabled) {
                result.error("BLUETOOTH_DISABLED", "Bluetooth is not enabled", null)
                return
            }

            val connectedDevices = mutableListOf<Map<String, Any>>()

            try {
                // Get connected devices for different profiles
                val profileListener = object : BluetoothProfile.ServiceListener {
                    override fun onServiceConnected(profile: Int, proxy: BluetoothProfile?) {
                        proxy?.let { bluetoothProfile ->
                            val devices = bluetoothProfile.connectedDevices
                            for (device in devices) {
                                val deviceInfo = mapOf(
                                    "name" to (device.name ?: "Unknown Device"),
                                    "address" to device.address,
                                    "bondState" to device.bondState,
                                    "profile" to profile
                                )

                                // Avoid duplicates based on address
                                if (!connectedDevices.any { it["address"] == device.address }) {
                                    connectedDevices.add(deviceInfo)
                                }
                            }
                        }
                        bluetoothAdapter.closeProfileProxy(profile, proxy)
                    }

                    override fun onServiceDisconnected(profile: Int) {
                        // Not used in this implementation
                    }
                }

                // Check for A2DP profile (Audio)
                bluetoothAdapter.getProfileProxy(this, profileListener, BluetoothProfile.A2DP)

                // Check for Headset profile
                bluetoothAdapter.getProfileProxy(this, profileListener, BluetoothProfile.HEADSET)

                // Add delay to allow profile connections to complete
                Handler(Looper.getMainLooper()).postDelayed({
                    // Also check paired devices that might be connected but not through specific profiles
                    val pairedDevices = bluetoothAdapter.bondedDevices
                    for (device in pairedDevices) {
                        // You can add additional checks here to determine if device is actually connected
                        // This is a basic implementation - for more accuracy you might need to use reflection
                        // or check device connection state through other means

                        if (!connectedDevices.any { it["address"] == device.address }) {
                            // Only add if we can confirm it's connected (this is simplified)
                            val deviceInfo = mapOf(
                                "name" to (device.name ?: "Unknown Device"),
                                "address" to device.address,
                                "bondState" to device.bondState,
                                "profile" to -1 // Indicates unknown/general profile
                            )
                            // Note: This will add all paired devices.
                            // For more accurate detection, you might need additional checks
                        }
                    }

                    result.success(connectedDevices)
                }, 1000) // 1 second delay

            } catch (e: SecurityException) {
                result.error("PERMISSION_ERROR", "Missing Bluetooth permissions: ${e.message}", null)
            }

        } catch (e: Exception) {
            result.error("ERROR", "Error getting connected devices: ${e.message}", null)
        }
    }

    private fun pairDevice(address: String, result: MethodChannel.Result) {
        try {
            // Check if Bluetooth adapter is initialized and enabled
            if (!::bluetoothAdapter.isInitialized) {
                result.error("BLUETOOTH_NOT_AVAILABLE", "Bluetooth adapter not available", null)
                return
            }

            if (!bluetoothAdapter.isEnabled) {
                result.error("BLUETOOTH_DISABLED", "Bluetooth is not enabled", null)
                return
            }

            val device = bluetoothAdapter.getRemoteDevice(address)

            // Check if device address is valid
            if (!BluetoothAdapter.checkBluetoothAddress(address)) {
                result.error("INVALID_ADDRESS", "Invalid Bluetooth address", null)
                return
            }

            // Check if already paired
            if (device.bondState == BluetoothDevice.BOND_BONDED) {
                result.success(true)
                return
            }

            // Check if currently pairing
            if (device.bondState == BluetoothDevice.BOND_BONDING) {
                result.error("ALREADY_PAIRING", "Device is already in pairing process", null)
                return
            }

            // Start pairing process
            val pairingResult = device.createBond()

            if (pairingResult) {
                // Register receiver to listen for pairing result
                val pairingReceiver = object : BroadcastReceiver() {
                    override fun onReceive(context: Context?, intent: Intent?) {
                        val action = intent?.action
                        if (BluetoothDevice.ACTION_BOND_STATE_CHANGED == action) {
                            val deviceFromIntent = intent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE)
                            if (deviceFromIntent?.address == address) {
                                when (deviceFromIntent.bondState) {
                                    BluetoothDevice.BOND_BONDED -> {
                                        try {
                                            context?.unregisterReceiver(this)
                                        } catch (e: Exception) {
                                            // Receiver might already be unregistered
                                        }
                                        result.success(true)
                                    }
                                    BluetoothDevice.BOND_NONE -> {
                                        try {
                                            context?.unregisterReceiver(this)
                                        } catch (e: Exception) {
                                            // Receiver might already be unregistered
                                        }
                                        result.error("PAIRING_FAILED", "Pairing was rejected or failed", null)
                                    }
                                    // BOND_BONDING state - still in progress, do nothing
                                }
                            }
                        }
                    }
                }

                val filter = IntentFilter(BluetoothDevice.ACTION_BOND_STATE_CHANGED)
                registerReceiver(pairingReceiver, filter)

                // Set timeout for pairing (30 seconds)
                Handler(Looper.getMainLooper()).postDelayed({
                    try {
                        unregisterReceiver(pairingReceiver)
                        if (device.bondState != BluetoothDevice.BOND_BONDED) {
                            result.error("PAIRING_TIMEOUT", "Pairing timeout after 30 seconds", null)
                        }
                    } catch (e: Exception) {
                        // Receiver might already be unregistered
                        if (device.bondState != BluetoothDevice.BOND_BONDED) {
                            result.error("PAIRING_TIMEOUT", "Pairing timeout", null)
                        }
                    }
                }, 30000) // 30 seconds timeout

            } else {
                result.error("PAIRING_FAILED", "Failed to start pairing process", null)
            }

        } catch (e: SecurityException) {
            result.error("PERMISSION_ERROR", "Missing Bluetooth permissions: ${e.message}", null)
        } catch (e: Exception) {
            result.error("PAIRING_ERROR", "Error during pairing: ${e.message}", null)
        }
    }

    private fun unpairDevice(address: String, result: MethodChannel.Result) {
        try {
            // Check if Bluetooth adapter is initialized and enabled
            if (!::bluetoothAdapter.isInitialized) {
                result.error("BLUETOOTH_NOT_AVAILABLE", "Bluetooth adapter not available", null)
                return
            }

            if (!bluetoothAdapter.isEnabled) {
                result.error("BLUETOOTH_DISABLED", "Bluetooth is not enabled", null)
                return
            }

            val device = bluetoothAdapter.getRemoteDevice(address)

            // Check if device address is valid
            if (!BluetoothAdapter.checkBluetoothAddress(address)) {
                result.error("INVALID_ADDRESS", "Invalid Bluetooth address", null)
                return
            }

            if (device.bondState != BluetoothDevice.BOND_BONDED) {
                result.success(true) // Already unpaired
                return
            }

            // Use reflection to call removeBond (hidden method)
            try {
                val removeBondMethod = device.javaClass.getMethod("removeBond")
                val unpairResult = removeBondMethod.invoke(device) as Boolean
                result.success(unpairResult)
            } catch (e: NoSuchMethodException) {
                result.error("METHOD_NOT_FOUND", "removeBond method not available on this Android version", null)
            } catch (e: Exception) {
                result.error("REFLECTION_ERROR", "Error calling removeBond via reflection: ${e.message}", null)
            }

        } catch (e: SecurityException) {
            result.error("PERMISSION_ERROR", "Missing Bluetooth permissions: ${e.message}", null)
        } catch (e: Exception) {
            result.error("UNPAIR_ERROR", "Error during unpairing: ${e.message}", null)
        }
    }
}