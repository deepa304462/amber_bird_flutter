import 'dart:developer';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:flutter/cupertino.dart';
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
    log(args.toString());
    return Container(
      child: Column(children: <Widget>[
        // Container(
        //   padding: EdgeInsets.all(20.0),
        //   child: Text(
        //       "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"),
        // ),
        // Container(
        //     padding: EdgeInsets.all(10.0),
        //     child: progress < 1.0
        //         ? LinearProgressIndicator(value: progress)
        //         : Container()),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: InAppWebView(
              initialUrlRequest:
                  // URLRequest(url: Uri.parse("https://flutter.dev/")),
                  URLRequest(url: Uri.parse(args?['href'] ?? '')),
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
              )),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {
                // setState(() {
                //   this.url = url as String;
                // });
              },
              onLoadStop: (controller, url) async {
                // setState(() {
                //   this.url = url as String;
                // });
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                print(progress);
                // setState(() {
                //   this.progress = progress / 100;
                // });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                log(controller.toString());
                log(url.toString());
                if (url.toString() == 'https://app.sbazar.app/order/${cartController.paymentData.value!.id}') {
                  CartController cartController = Get.find();
                  cartController.paymentStatusCheck();
                  Modular.to.navigate('./paymentStatus');
                }
                log(androidIsReload.toString());
                // setState(() {
                //   this.url = url.toString();
                //   urlController.text = this.url;
                // });
              },
            ),
          ),
        ),
        // ButtonBar(
        //   alignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     ElevatedButton(
        //       child: Icon(Icons.arrow_back),
        //       onPressed: () {
        //         if (_webViewController != null) {
        //           _webViewController.goBack();
        //         }
        //       },
        //     ),
        //     ElevatedButton(
        //       child: Icon(Icons.arrow_forward),
        //       onPressed: () {
        //         if (_webViewController != null) {
        //           _webViewController.goForward();
        //         }
        //       },
        //     ),
        //     ElevatedButton(
        //       child: Icon(Icons.refresh),
        //       onPressed: () {
        //         if (_webViewController != null) {
        //           _webViewController.reload();
        //         }
        //       },
        //     ),
        //   ],
        // ),
      ]),
    );
  }
}
