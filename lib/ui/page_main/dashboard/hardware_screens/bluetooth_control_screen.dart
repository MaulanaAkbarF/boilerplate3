import 'package:bluetooth_classic/models/device.dart';
import 'package:boilerplate_3_firebaseconnect/core/utilities/functions/page_routes_func.dart';
import 'package:boilerplate_3_firebaseconnect/core/utilities/functions/system_func.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/divider/custom_divider.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/textfield/textfield_form/regular_form.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant_values/global_values.dart';
import '../../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../../core/state_management/providers/features/buetooth_control_provider.dart';
import '../../../../core/utilities/functions/media_query_func.dart';
import '../../../layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import '../../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../../layouts/styleconfig/textstyle.dart';
import '../../../layouts/styleconfig/themecolors.dart';

class BluetoothControlScreen extends StatelessWidget {
  const BluetoothControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => BluetoothControlProvider.read(context).initialize());

    return Consumer<AppearanceSettingProvider>(
      builder: (context, provider, child) {
        if (provider.isTabletMode.condition) {
          if (getMediaQueryWidth(context) > provider.tabletModePixel.value) return _setTabletLayout(context);
          if (getMediaQueryWidth(context) < provider.tabletModePixel.value) return _setPhoneLayout(context);
        }
        return _setPhoneLayout(context);
      }
    );
  }

  Widget _setPhoneLayout(BuildContext context) {
    return CustomScaffold(
      useSafeArea: true,
      useExtension: true,
      padding: EdgeInsets.all(paddingMid),
      onPopInvokedWithResult: (didPop, result) => BluetoothControlProvider.read(context).turnOff(),
      appBar: appBarWidget(context: context, title: 'Bluetooth Control', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context) {
    return CustomScaffold(
      useSafeArea: true,
      useExtension: true,
      padding: EdgeInsets.all(paddingMid),
      onPopInvokedWithResult: (didPop, result) => BluetoothControlProvider.read(context).turnOff(),
      appBar: appBarWidget(context: context, title: 'Bluetooth Control', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ListView(
      children: [
        Consumer<BluetoothControlProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusCard(context, provider),
                ColumnDivider(),
                _buildControlButtons(context, provider),
                ColumnDivider(),
                _buildPairedDevicesSection(context, provider),
                ColumnDivider(),
                _buildDiscoveredDevicesSection(context, provider),
                ColumnDivider(),
                if (provider.deviceStatus == Device.connected) ...[
                  _buildCommunicationSection(context, provider),
                ],
                ColumnDivider(),
                AnimateProgressButton(
                  labelButton: 'Lihat Log',
                  icon: Icon(Icons.library_books_rounded),
                  containerColor: ThemeColors.maroon(context),
                  onTap: () => startScreenSwipe(context, BluetoothControlLogScreen()),
                ),
              ],
            );
          },
        )
      ],
    );
  }

  Widget _buildStatusCard(BuildContext context, BluetoothControlProvider provider) {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (provider.deviceStatus) {
      case Device.connected:
        statusText = 'Terhubung';
        statusColor = Colors.green;
        statusIcon = Icons.bluetooth_connected;
        break;
      case Device.disconnected:
        statusText = 'Tidak Terhubung';
        statusColor = Colors.red;
        statusIcon = Icons.bluetooth_disabled;
        break;
      default:
        statusText = 'Menghubungkan';
        statusColor = Colors.orange;
        statusIcon = Icons.bluetooth_searching;
    }

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.greyVeryLowContrast(context),
        borderRadius: BorderRadius.circular(radiusSquare)
      ),
      child: Padding(
        padding: const EdgeInsets.all(paddingMid),
        child: Column(
          children: [
            Icon(statusIcon, size: iconBtnBig * 1.5, color: statusColor),
            ColumnDivider(),
            cText(context, provider.selectedPairingDevice.address != '' ? '$statusText • ${provider.selectedPairingDevice.name}' : statusText,
              style: TextStyles.large(context).copyWith(color: statusColor, fontWeight: FontWeight.bold)),
            ColumnDivider(),
            cText(context, 'Platform: ${provider.platformVersion}'),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons(BuildContext context, BluetoothControlProvider provider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AnimateProgressButton(
                labelButton: 'Segarkan',
                icon: const Icon(Icons.refresh),
                containerColor: ThemeColors.green(context),
                onTap: () => provider.getPairedDevices(context: context),
              ),
            ),
            RowDivider(),
            Expanded(
              child: AnimateProgressButton(
                labelButton: provider.isScanning ? 'Hentikan' : 'Pindai',
                icon: Icon(provider.isScanning ? Icons.stop : Icons.search),
                containerColor: provider.isScanning ? ThemeColors.purple(context) : ThemeColors.blue(context),
                onTap: () => provider.scanDevices(context: context),
              ),
            ),
          ],
        ),
        if (provider.deviceStatus == Device.connected) ...[
          ColumnDivider(),
          AnimateProgressButton(
            labelButton: 'Putuskan Sambungan',
            icon: Icon(Icons.bluetooth_disabled),
            containerColor: ThemeColors.red(context),
            onTap: () => provider.disconnect(realDisconnected: true, disconnectSystemPairing: true),
          ),
        ],
      ],
    );
  }

  Widget _buildPairedDevicesSection(BuildContext context, BluetoothControlProvider provider) {
    return Container(
      padding: EdgeInsets.all(paddingMid),
      decoration: BoxDecoration(
        color: ThemeColors.greyVeryLowContrast(context),
        borderRadius: BorderRadius.circular(radiusSquare)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cText(context, 'Perangkat Tersimpan', style: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold)),
          ColumnDivider(),
          provider.pairedDevices.isEmpty ? cText(context, 'Tidak ada perangkat terdeteksi') : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.pairedDevices.length,
            separatorBuilder: (context, index) => ColumnDivider(space: paddingNear),
            itemBuilder: (context, index) => _buildDeviceListTile(context, provider.pairedDevices[index], provider, true),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveredDevicesSection(BuildContext context, BluetoothControlProvider provider) {
    return Container(
      padding: EdgeInsets.all(paddingMid),
      decoration: BoxDecoration(
        color: ThemeColors.greyVeryLowContrast(context),
        borderRadius: BorderRadius.circular(radiusSquare)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: cText(context, provider.isScanning? 'Memindai...' : 'Perangkat Tersedia', style: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold))),
              if (provider.isScanning) ...[
                RowDivider(),
                LoadingAnimationWidget.hexagonDots(color: ThemeColors.blue(context), size: iconBtnMid),
                RowDivider(),
              ],
              Container(
                padding: EdgeInsets.symmetric(horizontal: paddingMid, vertical: paddingNear),
                decoration: BoxDecoration(
                    color: provider.discoveredDevices.isNotEmpty ? ThemeColors.greenVeryLowContrast(context) : ThemeColors.greyLowContrast(context),
                    borderRadius: BorderRadius.circular(radiusCircle)
                ),
                child: cText(context, '${provider.discoveredDevices.length} ditemukan', style: TextStyles.small(context)),
              ),
            ],
          ),
          ColumnDivider(),
          provider.discoveredDevices.isEmpty ? cText(context, provider.isScanning
              ? 'Mencari perangkat...'
              : 'Tidak ada perangkat ditemukan\nTekan tombol "Pindai" untuk mencari perangkat') : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.discoveredDevices.length,
            separatorBuilder: (context, index) => ColumnDivider(),
            itemBuilder: (context, index) => _buildDeviceListTile(context, provider.discoveredDevices[index], provider, false),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceListTile(BuildContext context, Device device, BluetoothControlProvider provider, bool isPaired) {
    return GestureDetector(
      onTap: () => provider.connectToDevice(device, useSystemPairing: true),
      child: Container(
        padding: EdgeInsets.all(paddingMid),
        decoration: BoxDecoration(
          color: provider.deviceStatus == Device.connected && provider.selectedPairingDevice.address != '' && provider.selectedPairingDevice.name == device.name
              ? ThemeColors.blueVeryLowContrast(context)
              : provider.tryToConnecting && provider.selectedPairingDevice.address == device.address
                ? ThemeColors.orangeLowContrast(context)
                : ThemeColors.greyLowContrast(context),
          borderRadius: BorderRadius.circular(radiusSquare)
        ),
        child: Row(
          children: [
            Icon(size: iconBtnMid, isPaired ? Icons.bluetooth : Icons.bluetooth_searching, color: isPaired ? ThemeColors.blue(context) : ThemeColors.grey(context)),
            RowDivider(space: paddingNear),
            if (provider.tryToConnecting && provider.selectedPairingDevice.address == device.address)...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cText(context, 'Menghubungkan ke ${device.name ?? 'Perangkat tidak dikenal'}', style: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold)),
                  cText(context, provider.uuidSelected),
                ],
              ),
            ] else ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cText(context, provider.deviceStatus == Device.connected && provider.selectedPairingDevice.address != '' && provider.selectedPairingDevice.name == device.name
                    ? '${device.name ?? 'Perangkat tidak dikenal'}  •  Terhubung'
                    : device.name ?? 'Perangkat tidak dikenal', style: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold)),
                  cText(context, device.address),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCommunicationSection(BuildContext context, BluetoothControlProvider provider) {
    return Container(
      padding: EdgeInsets.all(paddingMid),
      decoration: BoxDecoration(
        color: ThemeColors.greyVeryLowContrast(context),
        borderRadius: BorderRadius.circular(radiusSquare)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cText(context, 'Komunikasi', style: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold)),
          ColumnDivider(),
          Row(
            children: [
              Expanded(
                child: RegularTextField(
                  controller: provider.messageController,
                  hintText: 'Ketik pesan untuk dikirim...',
                  suffixIcon: Icon(Icons.send, size: iconBtnMid, color: ThemeColors.blue(context)),
                  isRequired: false,
                  suffixOnTap: () {
                    if (provider.messageController.text.trim().isNotEmpty) {
                      provider.sendData(provider.messageController.text);
                      provider.messageController.clear();
                    }
                  },
                ),
              ),
            ],
          ),
          ColumnDivider(),
          cText(context, 'Log Data Diterima', style: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold)),
          ColumnDivider(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(paddingMid),
            constraints: BoxConstraints(maxHeight: 500),
            decoration: BoxDecoration(color: ThemeColors.onSurface(context), borderRadius: BorderRadius.circular(radiusSquare)),
            child: ListView(
              shrinkWrap: true,
              children: [
                cText(context, provider.receivedData.isEmpty ? 'Belum ada data yang diterima...' : provider.receivedData)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BluetoothControlLogScreen extends StatelessWidget {
  const BluetoothControlLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppearanceSettingProvider, BluetoothControlProvider>(
        builder: (context, provider, provider2, child) {
          if (provider.isTabletMode.condition){
            if (getMediaQueryWidth(context) > provider.tabletModePixel.value) return _setTabletLayout(context, provider2);
            if (getMediaQueryWidth(context) < provider.tabletModePixel.value) return _setPhoneLayout(context, provider2);
          }
          return _setPhoneLayout(context, provider2);
        }
    );
  }

  Widget _setPhoneLayout(BuildContext context, BluetoothControlProvider provider){
    return CustomScaffold(
      useSafeArea: true,
      padding: EdgeInsets.all(paddingMid),
      appBar: appBarWidget(context: context, title: 'Bluetooth Log', showBackButton: true),
      body: _bodyWidget(context, provider)
    );
  }

  Widget _setTabletLayout(BuildContext context, BluetoothControlProvider provider){
    return CustomScaffold(
      useSafeArea: true,
      padding: EdgeInsets.all(paddingMid),
      appBar: appBarWidget(context: context, title: 'Bluetooth Log', showBackButton: true),
      body: _bodyWidget(context, provider)
    );
  }

  Widget _bodyWidget(BuildContext context, BluetoothControlProvider provider){
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: cText(context, 'Semua Log', style: TextStyles.large(context))),
            IconButton(icon: Icon(Icons.copy, size: iconBtnMid), onPressed: () => copyText(context, provider.logs.join('\n')))
          ],
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(paddingMid),
            decoration: BoxDecoration(
              color: ThemeColors.greyVeryLowContrast(context),
              borderRadius: BorderRadius.circular(radiusSquare)
            ),
            child: provider.logs.isEmpty ? Center(child: cText(context, 'Log Kosong', style: TextStyles.medium(context))) : ListView.builder(
              itemCount: provider.logs.length,
              itemBuilder: (context, index){
                final item = provider.logs[index];
                return cText(context, item, style: TextStyles.small(context));
              },
            ),
          ),
        ),
      ],
    );
  }
}