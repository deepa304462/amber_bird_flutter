import 'package:amber_bird/controller/cart-controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../helpers/controller-generator.dart';
import 'loading-with-logo.dart';

class WebPageViewer extends StatefulWidget {
  final String pageUrl;
  WebPageViewer(this.pageUrl);
  @override
  _WebPageViewer createState() => new _WebPageViewer();
}

class _WebPageViewer extends State<WebPageViewer> {
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  late InAppWebViewController _webViewController;
  double progress = 0;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.pageUrl ?? '')),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
          ),
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;
          setState(() {
            isLoading = false;
          });
        },
        onLoadStart: (controller, url) {
          setState(() {
            isLoading = true;
          });
        },
        onLoadStop: (controller, url) async {
          setState(() {
            isLoading = false;
          });
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {},
        onUpdateVisitedHistory: (controller, url, androidIsReload) async {},
      ),
      isLoading ? LoadingWithLogo() : const SizedBox()
    ]);
  }
}
