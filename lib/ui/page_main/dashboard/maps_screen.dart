import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/enum_values.dart';
import '../../../core/constant_values/global_values.dart';
import '../../../core/state_management/providers/_global_widget/location_provider.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/state_management/providers/features/google_maps_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../../core/utilities/functions/system_func.dart';
import '../../layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/global_state_widgets/dialog/dialog_action/custom_dialog.dart';
import '../../layouts/global_state_widgets/divider/custom_divider.dart';
import '../../layouts/global_state_widgets/textfield/textfield_form/regular_form.dart';
import '../../layouts/styleconfig/textstyle.dart';
import '../../layouts/styleconfig/themecolors.dart';

class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      padding: EdgeInsets.zero,
      appBar: appBarWidget(context: context, title: 'Maps', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context) {
    return CustomScaffold(
      useSafeArea: true,
      useExtension: true,
      padding: EdgeInsets.zero,
      appBar: appBarWidget(context: context, title: 'Maps', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleMapsProvider(context),
      child: Consumer2<GoogleMapsProvider, LocationSettingProvider>(
        builder: (context, provider, locationProvider, child) {
        return Stack(
            children: [
              GoogleMap(
                zoomControlsEnabled: false,
                mapToolbarEnabled: true,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                mapType: provider.mapType,
                initialCameraPosition: CameraPosition(target: provider.startLocation, zoom: 3.65), // Default full map Indonesia: 3.65,
                onMapCreated: (controller) async {
                  provider.controllerGoogleMap.complete(controller);
                  provider.setMapsController(controller);
                  if (locationProvider.geocodingModel.latitude == 0 || locationProvider.geocodingModel.longitude == 0) await locationProvider.getCurrentUserLocation(context);
                  provider.mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(locationProvider.geocodingModel.latitude, locationProvider.geocodingModel.longitude), zoom: 18)));
                  await locationProvider.getCurrentUserLocation(context);
                },
                onCameraMove: (CameraPosition cameraPositions) {
                  provider.setCameraPosition(cameraPositions);
                  provider.setMapsState(GoogleMapsState.loading);
                },
                onCameraIdle: () async {
                  if (provider.mapState == GoogleMapsState.loading){
                    bool conn = await checkInternetConnectivity();
                    if (conn){
                      if (provider.cameraPosition != null){
                        locationProvider.reset();
                        await locationProvider.getLocationFromMaps(provider.cameraPosition!.target.latitude, provider.cameraPosition!.target.longitude);
                        provider.setMapsState(GoogleMapsState.success);
                      } else {
                        showToastTop(context, 'Posisi Kamera Kosong');
                        provider.setMapsState(GoogleMapsState.failed);
                      }
                    } else {
                      showToastTop(context, 'Koneksi internet terputus!');
                      provider.setMapsState(GoogleMapsState.failed);
                    }
                  }
                },
              ),
              if (provider.mapState == GoogleMapsState.loading || provider.mapState == GoogleMapsState.success || provider.mapState == GoogleMapsState.failed)
                Center(child: Padding(padding: const EdgeInsets.only(bottom: paddingVeryFar), child: Icon(Icons.location_on, color: ThemeColors.red(context), size: iconBtnBig))),
              if (provider.mapState == GoogleMapsState.loading) _onLoadingLayout(context, provider.mapState.text),
              if (provider.mapState == GoogleMapsState.success || provider.mapState == GoogleMapsState.failed) _onAddressLayout(context, provider, locationProvider)
            ],
          );
        },
      ),
    );
  }

  Widget _onLoadingLayout(BuildContext context, String text){
    return Positioned(bottom: paddingMid, left: paddingMid, right: paddingMid, child: Container(
        padding: EdgeInsets.all(paddingMid),
        decoration: BoxDecoration(color: ThemeColors.onSurface(context), borderRadius: BorderRadius.circular(radiusSquare)),
        child: Column(
          children: [
            cText(context, text, align: TextAlign.center, style: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold)),
            const ColumnDivider(space: spaceNear),
            LoadingAnimationWidget.inkDrop(color: ThemeColors.blue(context), size: iconBtnMid)
          ],
        ),
      ),
    );
  }

  Widget _onAddressLayout(BuildContext context, GoogleMapsProvider provider, LocationSettingProvider locationProvider){
    return Positioned(bottom: paddingMid, left: paddingMid, right: paddingMid,
      child: Column(
        children: [
          if (provider.option.isNotEmpty) ...[
            _onLocationListLayout(context, provider),
            ColumnDivider()
          ],
          Container(
            padding: EdgeInsets.fromLTRB(paddingMid, 0, paddingMid, paddingMid),
            decoration: BoxDecoration(color: ThemeColors.onSurface(context).withValues(alpha: .85), borderRadius: BorderRadius.circular(radiusSquare)),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.location_pin, color: ThemeColors.red(context)),
                    cText(context, 'Lokasi Anda', align: TextAlign.center),
                    Expanded(child: GestureDetector(onTap: () => showSearchLocation(context, provider), child: Container(color: Colors.transparent,
                        child: cText(context, provider.mapSearchTechnology.text, maxLines: 1, align: TextAlign.right, style: TextStyles.medium(context).copyWith(color: ThemeColors.blueHighContrast(context), fontWeight: FontWeight.bold))))),
                    IconButton(onPressed: provider.changeSearchMapTechnology, icon: Icon(Icons.change_circle, color: ThemeColors.orange(context))),
                    IconButton(onPressed: provider.changeMapTerrain, icon: Icon(Icons.map_outlined, color: ThemeColors.green(context))),
                  ],
                ),
                cText(context, locationProvider.geocodingModel.address ?? 'unknown', align: TextAlign.center, style: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold)),
                if (locationProvider.geocodingModel.latitude != 0 && locationProvider.geocodingModel.longitude != 0 && locationProvider.geocodingModel.address != "")...[
                  ColumnDivider(),
                  AnimateProgressButton(
                    labelButton: 'Konfirmasi',
                    containerColor: ThemeColors.blueHighContrast(context),
                    shadowColor: ThemeColors.surface(context),
                    onTap: () async {

                    },
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _onLocationListLayout(BuildContext context, GoogleMapsProvider provider) {
    return Container(
      padding: EdgeInsets.all(paddingMid),
      decoration: BoxDecoration(color: ThemeColors.onSurface(context).withValues(alpha: .85), borderRadius: BorderRadius.circular(radiusSquare)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.location_pin, color: ThemeColors.green(context)),
              cText(context, 'Daftar Lokasi', align: TextAlign.center),
              Expanded(child: GestureDetector(onTap: () => provider.setExpandedList(), child: Container(color: Colors.transparent,
                  child: cText(context, provider.isExpanded ? 'Sembunyikan' : 'Tampilkan', align: TextAlign.right,
                      style: TextStyles.medium(context).copyWith(color: ThemeColors.blueHighContrast(context), fontWeight: FontWeight.bold))))),
            ],
          ),
          if (provider.isExpanded)...[
            ColumnDivider(),
            Container(
              constraints: BoxConstraints(maxHeight: getMediaQueryHeight(context) * 0.18),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: provider.option.length,
                separatorBuilder: (context, index) => ColumnDivider(space: paddingNear),
                itemBuilder: (context, index){
                  final item = provider.option[index];
                  return GestureDetector(
                    onTap: () {
                      print('Lat: ${item.lat}, Lon: ${item.lon}');
                      provider.mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(item.lat, item.lon), zoom: 18)));
                    },
                    child: Container(padding: EdgeInsets.all(paddingMid), decoration: BoxDecoration(color: ThemeColors.greyLowContrast(context), borderRadius: BorderRadius.circular(radiusSquare)),
                        child: cText(context, item.displayname, style: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold))),
                  );
                },
              ),
            )
          ]
        ],
      ),
    );
  }

  Future<void> showSearchLocation(BuildContext context, GoogleMapsProvider provider) async {
    await showDialog(context: context, builder: (context) => DialogCustom(
      header: 'Cari Lokasi',
      description: 'Jangan memasukkan imbuhan seperti "Komplek", "Kampung", "Jembatan" dsb',
      descriptionTextStyle: TextStyles.medium(context).copyWith(color: ThemeColors.redHighContrast(context)),
      child: Expanded(
        child: Column(
          children: [
            RegularTextField(
              controller: provider.tecSearch,
              hintText: 'Masukkan alamat yang ingin Anda cari',
              isRequired: false,
            ),
          ],
        ),
      ),
      acceptedOnTap: () async {
        await provider.searchLocation();
        Navigator.pop(context);
      },
    ));
  }
}