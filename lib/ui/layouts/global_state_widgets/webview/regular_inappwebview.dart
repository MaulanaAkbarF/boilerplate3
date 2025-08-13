import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_return_widgets/future_state_func.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// A StatefulWidget that encapsulates an InAppWebView with required and optional parameters.
class RegularInAppWebView extends StatefulWidget {
  /// Required: The initial URL to load in the WebView.
  final String initialUrl;

  /// Optional: Settings to configure the WebView behavior.
  final InAppWebViewSettings? settings;

  /// Optional: WebView environment for Windows platform.
  final WebViewEnvironment? webViewEnvironment;

  /// Optional: Callback when the WebView is created.
  final void Function(InAppWebViewController)? onWebViewCreated;

  /// Optional: Callback when the WebView starts loading a URL.
  final void Function(InAppWebViewController, WebUri?)? onLoadStart;

  /// Optional: Callback when the WebView finishes loading a URL.
  final void Function(InAppWebViewController, WebUri?)? onLoadStop;

  /// Optional: Callback to handle navigation requests.
  final Future<NavigationActionPolicy> Function(InAppWebViewController, NavigationAction)? shouldOverrideUrlLoading;

  /// Optional: Callback for progress changes during loading.
  final void Function(InAppWebViewController, int)? onProgressChanged;

  /// Optional: Callback for console messages from JavaScript.
  final void Function(InAppWebViewController, ConsoleMessage)? onConsoleMessage;

  /// Optional: Pull-to-refresh controller for refreshing the WebView.
  final PullToRefreshController? pullToRefreshController;

  const RegularInAppWebView({
    super.key,
    required this.initialUrl,
    this.settings,
    this.webViewEnvironment,
    this.onWebViewCreated,
    this.onLoadStart,
    this.onLoadStop,
    this.shouldOverrideUrlLoading,
    this.onProgressChanged,
    this.onConsoleMessage,
    this.pullToRefreshController,
  });

  @override
  State<RegularInAppWebView> createState() => _RegularInAppWebViewState();
}

class _RegularInAppWebViewState extends State<RegularInAppWebView> {
  InAppWebViewController? _webViewController;
  double _progress = 0;

  Future<bool> _onWillPop() async {
    if (_webViewController != null) {
      final canGoBack = await _webViewController!.canGoBack();
      if (canGoBack) {
        _webViewController!.goBack();
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) Navigator.of(context).pop();
      },
      child: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.initialUrl)),
            initialSettings: widget.settings ??
              InAppWebViewSettings(
                isInspectable: kDebugMode,
                javaScriptEnabled: true,
                allowsInlineMediaPlayback: true,
                iframeAllowFullscreen: true,
              ),
            webViewEnvironment: widget.webViewEnvironment,
            pullToRefreshController: widget.pullToRefreshController,
            onWebViewCreated: (controller) {
              _webViewController = controller;
              widget.onWebViewCreated?.call(controller);
            },
            onLoadStart: (controller, url) {
              setState(() => _progress = 0);
              widget.onLoadStart?.call(controller, url);
            },
            onLoadStop: (controller, url) async {
              widget.pullToRefreshController?.endRefreshing();
              setState(() => _progress = 1);
              widget.onLoadStop?.call(controller, url);
            },
            shouldOverrideUrlLoading: widget.shouldOverrideUrlLoading,
            onProgressChanged: (controller, progress) {
              setState(() => _progress = progress / 100);
              widget.onProgressChanged?.call(controller, progress);
            },
            onConsoleMessage: widget.onConsoleMessage,
          ),
          if (_progress < 1.0)...[
            onLoadingState(context: context, response: 'Memuat Halaman Web...'),
            LinearProgressIndicator(value: _progress)
          ]
          else
            const SizedBox()
        ],
      ),
    );
  }
}