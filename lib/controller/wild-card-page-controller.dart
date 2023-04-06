import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
        existing = await SharedData.read('referBy');
      } catch (e) {}
      if (existing.isNotEmpty) {
      } else {
        CodeHelp.toast(
            'Received reference, Thank you. Offer will apply while checkout.');
        SharedData.save(referById, 'referBy');
      }
      Modular.to.navigate("/home/main");
    }
  }
}
