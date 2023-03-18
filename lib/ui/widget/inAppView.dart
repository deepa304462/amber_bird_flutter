import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../helpers/controller-generator.dart';
import 'loading-with-logo.dart';

class InApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<InApp> {
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  late InAppWebViewController _webViewController;
  String url = "";
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
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    return Stack(children: <Widget>[
      InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(args ?? '')),
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
        onUpdateVisitedHistory: (controller, url, androidIsReload) async {
          // log(controller.toString());
          // log(url.toString());
          if (url.toString() ==
              'https://prod.sbazar.app/order/${cartController.orderId.value}') {
            var inAppReviewDone = await SharedData.read('inAppReviewDone');
            if (inAppReviewDone != 'true') {
              final InAppReview inAppReview = InAppReview.instance;

              if (await inAppReview.isAvailable()) {
                inAppReview.requestReview();
                  SharedData.save(true.toString(), 'inAppReviewDone');
              }
            }
            Modular.to.navigate(
                './paymentStatus/${cartController.orderId.value}/${cartController.paymentData.value!.id!}');
          }
        },
      ),
      isLoading ? LoadingWithLogo() : const SizedBox()
    ]);
  }
}
