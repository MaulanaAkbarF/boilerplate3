class WifiNetworkDetails {
  final String? ssid;
  final String? bssid;
  final String? ipAddress;
  final String? ipv6Address;
  final String? subnetMask;
  final String? gatewayIp;
  final String? broadcastIp;

  WifiNetworkDetails({
    this.ssid,
    this.bssid,
    this.ipAddress,
    this.ipv6Address,
    this.subnetMask,
    this.gatewayIp,
    this.broadcastIp,
  });

  factory WifiNetworkDetails.fromNetworkInfo({
    String? ssid,
    String? bssid,
    String? ipAddress,
    String? ipv6Address,
    String? subnetMask,
    String? gatewayIp,
    String? broadcastIp,
  }) {
    return WifiNetworkDetails(
      ssid: ssid,
      bssid: bssid,
      ipAddress: ipAddress,
      ipv6Address: ipv6Address,
      subnetMask: subnetMask,
      gatewayIp: gatewayIp,
      broadcastIp: broadcastIp,
    );
  }

  @override
  String toString() {
    return 'WifiNetworkDetails(ssid: $ssid, bssid: $bssid, ipAddress: $ipAddress, ipv6Address: $ipv6Address, '
        'subnetMask: $subnetMask, gatewayIp: $gatewayIp, broadcastIp: $broadcastIp)';
  }
}