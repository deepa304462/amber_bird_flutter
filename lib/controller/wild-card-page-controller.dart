import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class WildCardPageController extends GetxController {
  Rx<Uri> uri = Uri().obs;

  WildCardPageController(Uri givenUri) {
    uri.value = givenUri;
    syncPath(givenUri);
  }

  Future<void> syncPath(Uri givenUri) async {
    print(givenUri);
    print("givenUri");

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
    } else if (givenUri.path.contains('app')) {
      String shortcodeId = givenUri.path.split('/')[2];
      var payload = {
        "shortUrl": 'https://sbazar.app/app/${shortcodeId}',
      };
      print(payload);
      var resp = await ClientService.post(
          path: 'product/shortLinkToProduct', payload: payload);
      if (resp.statusCode == 200 && resp.data != null && resp.data != '') {
        FlutterNativeSplash.remove();
        Modular.to.pushReplacementNamed('/widget/product/${resp.data}');
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (BuildContext context) => PageA()));
        // Modular.to.pushNamed('/widget/product/${resp.data}');
      } else {
        FlutterNativeSplash.remove();
        Modular.to.navigate("/home/main");
      }
    }
  }
}
