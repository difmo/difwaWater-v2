import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String initialUrl;

  const PaymentWebViewScreen({super.key, required this.initialUrl});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    final PlatformWebViewControllerCreationParams params =
        PlatformWebViewControllerCreationParams();

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (url) {
            print("🌐 Loading URL: ${url.url}");
            setState(() => _isLoading = true);

            // ✅ Detect success or failure and handle navigation
            if (url.url.toString().contains("status") &&
                url.url.toString().contains("payment_id")) {
              Uri uri = Uri.parse(url.toString());
              String? status = uri.queryParameters["status"];
              String? paymentId = uri.queryParameters["payment_id"];
              print("Payment Status: $status");
              print("Payment ID: $paymentId");

              // ✅ Payment Success — Navigate & pass data
              if (status == "success") {
                Navigator.pop(
                    context, {"status": "success", "payment_id": paymentId});
              } else {
                // ❌ Payment Failed — Pop with failure
                Navigator.pop(context, {"status": "failed"});
              }
            }
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            print("✅ Finished Loading: $url");
          },
          onWebResourceError: (error) {
            print("❌ Webview Error: $error");
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));

    // Handle Android-specific WebChromeClient issues
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setOnPlatformPermissionRequest(
        (request) => request.grant(),
      );
    }
  }

  // Handle back navigation
  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // WebView
              WebViewWidget(controller: _controller),

              // Loading Indicator
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
