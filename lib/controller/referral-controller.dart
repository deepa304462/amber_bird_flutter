import 'dart:convert';
import 'dart:developer';

import 'package:amber_bird/data/short_link/short_link.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:get/get.dart';

class ReferralController extends GetxController {
  Rx<ShortLink> shortLink = new ShortLink().obs;
  Rx<bool> isLoading = true.obs;
  @override
  void onInit() {
    syncShortLink();
    super.onInit();
  }

  Future<void> syncShortLink() async {
    dynamic loggedInUser = jsonDecode(await SharedData.read('userData'));
    if (!(loggedInUser['mappedTo']['_id'] as String).isEmpty) {
      ClientService.get(path: 'shortLink', id: loggedInUser['mappedTo']['_id'])
          .then((value) {
        isLoading.value = false;
        shortLink.value = ShortLink.fromMap(value.data);
      });
    }
  }
}