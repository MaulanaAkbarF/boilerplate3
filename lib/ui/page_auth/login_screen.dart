import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/constant_values/assets_values.dart';
import '../../core/constant_values/global_values.dart';
import '../../core/models/_global_widget_model/geocoding.dart';
import '../../core/services/firebase/firebase_messaging.dart';
import '../../core/state_management/providers/_global_widget/realtime_provider.dart';
import '../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../core/state_management/providers/auth/user_provider.dart';
import '../../core/utilities/functions/media_query_func.dart';
import '../../core/utilities/functions/page_routes_func.dart';
import '../../core/utilities/functions/system_func.dart';
import '../layouts/global_return_widgets/media_widgets_func.dart';
import '../layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import '../layouts/global_state_widgets/custom_background/container_background.dart';
import '../layouts/global_state_widgets/custom_page_animation/pa_zoom_out.dart';
import '../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../layouts/global_state_widgets/custom_text/custom_line_text.dart';
import '../layouts/global_state_widgets/divider/custom_divider.dart';
import '../layouts/global_state_widgets/textfield/textfield_form/regular_form.dart';
import '../layouts/global_state_widgets/textfield/textfield_hidden/regular_password.dart';
import '../layouts/styleconfig/textstyle.dart';
import '../layouts/styleconfig/themecolors.dart';
import '../page_main/_bottom_navbar/main_navbar_floating.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  XFile? imageFiles;
  final _formLoginScreen = GlobalKey<FormState>();
  final TextEditingController tecUser = TextEditingController(text: '');
  final TextEditingController tecPass = TextEditingController(text: '');
  final TextEditingController tecPinput = TextEditingController(text: '');

  List<GeocodingModel> data = [
    GeocodingModel(latitude: 92301203, longitude: 12312321),
    GeocodingModel(latitude: 5656456, longitude: 36457546),
    GeocodingModel(latitude: 456456, longitude: 75674365),
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      /// Letakkan kode ini pada halaman awal yang tampil ketika pertama kali membuka aplikasi
      /// Namun jangan letakkan kode ini pada halaman splash screen atau sejenisnya
      /// Letakkan pada halaman login [jika tidak ada fitur auto-login] atau halaman beranda [jika terdapat fitur auto-login]
      /// Karena kode ini juga mencakup penanganan aksi notifikasi pada saat aplikasi dimatikan [onTerminated]
      await fcmNotificationInit(context);
      await getFcmNotificationToken();
    });

    return Consumer<AppearanceSettingProvider>(
      builder: (context, provider, child) {
        if (kIsWeb) {
          if (getMediaQueryWidth(context) < minWebLayoutWidth) return _setPhoneLayout(context);
          return _setWebLayout(context);
        }
        if (provider.isTabletMode.condition){
          if (getMediaQueryWidth(context) > provider.tabletModePixel.value) return _setTabletLayout(context);
          if (getMediaQueryWidth(context) < provider.tabletModePixel.value) return _setPhoneLayout(context);
        }
        return _setPhoneLayout(context);
      }
    );
  }

  Widget _setPhoneLayout(BuildContext context){
    return CustomScaffold(
      canPop: false,
      useSafeArea: true,
      useExtension: true,
      showBackgroundLogo: true,
      padding: EdgeInsets.zero,
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
      canPop: false,
      useSafeArea: true,
      useExtension: true,
      showBackgroundLogo: true,
      padding: EdgeInsets.zero,
      body: _bodyWidget(context)
    );
  }

  Widget _setWebLayout(BuildContext context){
    return CustomScaffold(
      canPop: false,
      useSafeArea: true,
      useExtension: true,
      showBackgroundLogo: true,
      padding: EdgeInsets.zero,
      body: _bodyWebWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return Form(
      key: _formLoginScreen,
      child: Padding(
        padding: const EdgeInsets.all(paddingFar),
        child: ListView(
          shrinkWrap: true,
          children: [
            ColumnDivider(space: paddingFar * 2),
            Align(alignment: Alignment.centerLeft, child: loadDefaultAppLogoPNG(sizeLogo: 30)),
            ColumnDivider(space: spaceNear),
            RealtimeProvider.realtimeWidget(context),
            Align(alignment: Alignment.centerLeft, child: cText(context, 'Selamat Datang!', style: TextStyles.giant(context).copyWith(fontWeight: FontWeight.bold))),
            Align(alignment: Alignment.centerLeft, child: cText(context, 'Masuk ke dalam aplikasi untuk mengakses beragam fitur yang Anda perlukan!', style: TextStyles.semiLarge(context))),
            ColumnDivider(space: spaceMid),
            RegularTextField(
              labelText: 'Username',
              controller: tecUser,
              minInput: 5,
              shadowColor: ThemeColors.surface(context),
              isRequired: false,
            ),
            ColumnDivider(space: spaceMid),
            RegularPasswordField(
              labelText: 'Password',
              controller: tecPass,
              minInput: 5,
              shadowColor: ThemeColors.surface(context),
              isRequired: false,
            ),
            ColumnDivider(space: spaceFar),
            AnimateProgressButton(
              labelButton: 'Masuk',
              containerColor: ThemeColors.blueHighContrast(context),
              shadowColor: ThemeColors.surface(context),
              onTap: () async {
                if (_formLoginScreen.currentState!.validate()){
                  if (kIsWeb) {
                    context.go('/dashboard');
                  } else {
                    final success = await UserProvider.read(context).login(context: context, email: 'variousra@gmail.com', name: 'Maulana Akbar Firdausya');
                    if (success == true) {
                      startScreenSwipe(context, MainFloatingNavbar());
                    } else {
                      showSnackBar(context, 'Login Gagal!');
                    }
                  }
                } else {
                  showSnackBar(context, 'Data belum lengkap!');
                }
              },
            ),
            LineText(text: 'atau'),
            AnimateProgressButton(
              labelButton: 'Masuk dengan Google',
              containerColorStart: ThemeColors.orange(context),
              containerColorEnd: ThemeColors.redHighContrast(context),
              shadowColor: ThemeColors.surface(context),
              image: loadImageAssetPNG(path: iconGooglePNG, width: iconBtnSmall, height: iconBtnSmall),
              onTap: () async {
                final success = await UserProvider.read(context).loginWithGoogle(context: context);
                if (success == true) {
                  startScreenSwipe(context, MainFloatingNavbar());
                } else {
                  showSnackBar(context, 'Login Gagal!');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyWebWidget(BuildContext context){
    return Form(
      key: _formLoginScreen,
      child: Padding(
        padding: const EdgeInsets.all(paddingFar),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageAnimationZoomOut(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(alignment: Alignment.center, child: loadDefaultAppLogoPNG(sizeLogo: 60)),
                    ColumnDivider(space: paddingFar),
                    Align(alignment: Alignment.center, child: cText(context, 'Selamat Datang', style: TextStyles.semiGiga(context).copyWith(fontWeight: FontWeight.bold))),
                    ColumnDivider(space: paddingFar),
                    Align(alignment: Alignment.center, child: cText(context, 'Masuk ke dalam aplikasi untuk mengakses beragam fitur yang Anda perlukan!', align: TextAlign.center, style: TextStyles.semiGiant(context))),
                  ],
                ),
              ),
            ),
            RowDivider(),
            CustomContainer(
              isExpanded: true,
              width: 500,
              padding: EdgeInsets.all(paddingVeryFar),
              containerColor: ThemeColors.greyVeryLowContrast(context),
              child: PageAnimationZoomOut(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ColumnDivider(space: spaceMid),
                    RegularTextField(
                      labelText: 'Username',
                      controller: tecUser,
                      minInput: 5,
                      shadowColor: ThemeColors.surface(context),
                      isRequired: false,
                    ),
                    ColumnDivider(space: spaceMid),
                    RegularPasswordField(
                      labelText: 'Password',
                      controller: tecPass,
                      minInput: 5,
                      shadowColor: ThemeColors.surface(context),
                      isRequired: false,
                    ),
                    ColumnDivider(space: spaceFar),
                    AnimateProgressButton(
                      labelButton: 'Masuk',
                      containerColor: ThemeColors.blueHighContrast(context),
                      shadowColor: ThemeColors.surface(context),
                      onTap: () async {
                        if (_formLoginScreen.currentState!.validate()){
                          if (kIsWeb) {
                            context.replace('/dashboard');
                          } else {
                            startScreenSwipe(context, MainFloatingNavbar());
                          }
                        } else {
                          showSnackBar(context, 'Data belum lengkap!');
                          showToastTop(context, 'Data belum lengkap!');
                        }
                      },
                    ),
                    LineText(text: 'atau'),
                    // (web.GoogleSignInPlugin()).renderButton(
                    //   configuration: web.GSIButtonConfiguration(
                    //     type: web.GSIButtonType.standard,
                    //     theme: web.GSIButtonTheme.outline,
                    //     size: web.GSIButtonSize.large,
                    //     text: web.GSIButtonText.signin,
                    //     logoAlignment: web.GSIButtonLogoAlignment.left,
                    //   ),
                    // ),
                    ColumnDivider(space: spaceMid),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}