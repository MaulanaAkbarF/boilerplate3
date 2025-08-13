import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/webview/regular_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

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
      appBar: appBarWidget(context: context, title: 'WebView', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context) {
    return CustomScaffold(
      useSafeArea: true,
      useExtension: true,
      padding: EdgeInsets.zero,
      appBar: appBarWidget(context: context, title: 'WebView', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return RegularInAppWebView(initialUrl: 'https://www.hypermedialearning.com/');
  }
}