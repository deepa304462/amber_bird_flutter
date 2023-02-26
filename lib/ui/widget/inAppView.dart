import 'package:amber_bird/controller/cart-controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class InApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<InApp> {
  final CartController cartController = Get.find();
  late InAppWebViewController _webViewController;
  String url = "";
  double progress = 0;
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
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    return Container(
      child: Column(children: <Widget>[ 
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(args ?? '')),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                ),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {},
              onLoadStop: (controller, url) async {},
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {},
              onUpdateVisitedHistory: (controller, url, androidIsReload) async {
                // log(controller.toString());
                // log(url.toString());
                if (url.toString() ==
                    'https://prod.sbazar.app/order/${cartController.orderId.value}') {
                  CartController cartController = Get.find();
                  await cartController.paymentStatusCheck();
                  Modular.to.navigate('./paymentStatus');
                } 
              },
            ),
          ),
        )
      ]),
    );
  }
}
