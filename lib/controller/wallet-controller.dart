import 'dart:ffi';

import 'package:amber_bird/data/membership/membership.info.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  RxList<Membership> membershipInfo = <Membership>[].obs;

  @override
  void onInit() {
    super.onInit();
    getMembertypeIfo();
  }

  getMembertypeIfo() async {
    var resp =
        await ClientService.post(path: 'membershipInfo/search', payload: {});
    if (resp.statusCode == 200) {
      // items.value =[];
      List<Membership> list = ((resp.data as List<dynamic>?)
              ?.map((e) => Membership.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);

      membershipInfo.value = list;
    }
  }
}
