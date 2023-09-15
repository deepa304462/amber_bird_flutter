import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class WildCardPageController extends GetxController {
  Rx<Uri> uri = Uri().obs;

  WildCardPageController(Uri givenUri, dynamic args) {
    uri.value = givenUri;
    syncPath(givenUri, args);
  }

  Future<void> syncPath(dynamic givenUri, dynamic args) async {
    print(givenUri);
    print("givenUri");
    print(args);
    // print(args['id']);
    print("args");

    if (givenUri.path.contains('refer')) {
      String referById = givenUri.path.split('/')[2];
      String existing = '';
      try {
        existing = await SharedData.read('referredById');
      } catch (e) {}
      if (existing.isNotEmpty) {
      } else {
        CodeHelp.toast(
            'Received reference, Thank you. Offer will apply while checkout.');
        SharedData.save(referById, 'referredById');
      }
      FlutterNativeSplash.remove();
      Modular.to.navigate("/home/main");
    } else if (givenUri.path.contains('product')) {
      print('inside product ');
      print(args);
      if (args is String) {
        final parsedUrl = Uri.parse(args);
        print(parsedUrl.queryParameters);
        FlutterNativeSplash.remove();
        Modular.to.navigate('/widget/product',
            arguments: parsedUrl.queryParameters['id']);
      } else {
        print(args['id']);
        FlutterNativeSplash.remove();
        Modular.to.navigate('/widget/product', arguments: args['id']);
      }
    }
  }
}
