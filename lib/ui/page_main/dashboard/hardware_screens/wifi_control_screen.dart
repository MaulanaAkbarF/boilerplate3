import 'package:boilerplate_3_firebaseconnect/core/utilities/extensions/primitive_data/string_ext.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/dialog/dialog_action/input_dialog.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/divider/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../../../../core/constant_values/global_values.dart';
import '../../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../../core/state_management/providers/features/wifi_control_provider.dart';
import '../../../../core/utilities/functions/media_query_func.dart';
import '../../../layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import '../../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../../layouts/styleconfig/textstyle.dart';
import '../../../layouts/styleconfig/themecolors.dart';

class WifiControlScreen extends StatelessWidget {
  const WifiControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => WifiControlProvider.read(context).initialize());

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
      appBar: appBarWidget(context: context, title: 'Wi-Fi Control', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context) {
    return CustomScaffold(
      useSafeArea: true,
      useExtension: true,
      padding: EdgeInsets.all(paddingMid),
      appBar: appBarWidget(context: context, title: 'Wi-Fi Control', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ListView(
      children: [
        Consumer<WifiControlProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusCard(context, provider),
                ColumnDivider(),
                AnimateProgressButton(
                  labelButton: provider.isScanning ? 'Hentikan Pemindaian' : 'Pindai Jaringan',
                  icon: Icon( provider.isScanning ? Icons.signal_wifi_bad_rounded : Icons.wifi_find_rounded),
                  containerColor:  provider.isScanning ? ThemeColors.purple(context) : ThemeColors.blue(context),
                  onTap: () => provider.startScan(),
                ),
                ColumnDivider(),
                _buildPairedNetworkSection(context, provider),
              ],
            );
          },
        )
      ],
    );
  }

  Widget _buildStatusCard(BuildContext context, WifiControlProvider provider) {
    return Container(
      decoration: BoxDecoration(
          color: ThemeColors.greyVeryLowContrast(context),
          borderRadius: BorderRadius.circular(radiusSquare)
      ),
      child: Padding(
        padding: const EdgeInsets.all(paddingMid),
        child: Column(
          children: [
            Icon(provider.isConnected ? Icons.wifi_rounded : Icons.wifi_off_rounded, size: iconBtnBig * 1.5,
                color: provider.isConnected ? ThemeColors.green(context) : ThemeColors.red(context)),
            ColumnDivider(),
            cText(context, provider.isConnected ? 'Terhubung • ${provider.currentSsid?.removesAllQuotes ?? "Tidak Terhubung"}' : "Tidak Terhubung",
                style: TextStyles.large(context).copyWith(color: provider.isConnected ? ThemeColors.green(context) : ThemeColors.red(context), fontWeight: FontWeight.bold)),
            ColumnDivider(),
            cText(context, provider.isConnected
                ? provider.isExpandedInfo ? 'Sembunyikan Informasi' : 'Tampilkan Informasi'
                : 'Status Wi-Fi: ${provider.isWifiEnabled ? "Aktif" : "Non-Aktif"}', onTap: () => provider.isConnected ? provider.toggleMoreWifiInfo() : null),
            if (provider.isExpandedInfo)...[
              ColumnDivider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  textInfo(context, 'SSID', provider.networkDetails?.ssid ?? 'Tidak ada info', provider),
                  textInfo(context, 'BSSID', provider.networkDetails?.bssid ?? 'Tidak ada info', provider),
                  textInfo(context, 'IP', provider.networkDetails?.ipAddress ?? 'Tidak ada info', provider),
                  textInfo(context, 'IPv6', provider.networkDetails?.ipv6Address ?? 'Tidak ada info', provider),
                  textInfo(context, 'Gateway IP', provider.networkDetails?.gatewayIp ?? 'Tidak ada info', provider),
                  textInfo(context, 'Broadcast IP', provider.networkDetails?.broadcastIp ?? 'Tidak ada info', provider),
                  textInfo(context, 'Subnet Mask', provider.networkDetails?.subnetMask ?? 'Tidak ada info', provider),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget textInfo(BuildContext context, String title, String value, WifiControlProvider provider){
    return Row(
      children: [
        Expanded(flex: 3, child: cText(context, '$title: ')),
        Expanded(flex: 6, child: cText(context, value, align: TextAlign.end)),
      ],
    );
  }

  Widget _buildPairedNetworkSection(BuildContext context, WifiControlProvider provider) {
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
          provider.accessPoints.isEmpty ? cText(context, 'Tidak ada perangkat terdeteksi') : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.accessPoints.length,
            separatorBuilder: (context, index) => ColumnDivider(space: paddingNear),
            itemBuilder: (context, index) => _buildDeviceListTile(context, provider.accessPoints[index], provider, true),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceListTile(BuildContext context, WiFiAccessPoint network, WifiControlProvider provider, bool isPaired) {
    return GestureDetector(
      onTap: () async {
        await showDialog(context: context, builder: (context) => DialogInputTextField(header: network.ssid, label: 'Masukkan Kata Sandi', controller: TextEditingController(),
          acceptedOnTap: (value){
            if (value.trim() != '') {
              provider.connectToWifi(context: context, network.ssid, value).then((value) {
                if (value) Navigator.pop(context);
              });
            }
          })
        );
      },
      child: Container(
        padding: EdgeInsets.all(paddingMid),
        decoration: BoxDecoration(
            color: provider.isConnected && provider.currentSsid != '' && provider.currentSsid == network.ssid
                ? ThemeColors.blueVeryLowContrast(context)
                : ThemeColors.greyLowContrast(context),
            borderRadius: BorderRadius.circular(radiusSquare)
        ),
        child: Row(
          children: [
            Icon(size: iconBtnMid, isPaired ? Icons.bluetooth : Icons.bluetooth_searching, color: isPaired ? ThemeColors.blue(context) : ThemeColors.grey(context)),
            RowDivider(space: paddingNear),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cText(context, provider.isConnected && provider.currentSsid != '' && provider.currentSsid == network.ssid
                    ? '${network.ssid}  •  Terhubung'
                    : network.ssid, style: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold)),
                cText(context, network.bssid),
              ],
            ),
          ],
        ),
      ),
    );
  }
}