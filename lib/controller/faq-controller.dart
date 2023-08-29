import 'dart:convert';

import 'package:get/get.dart';

import '../data/faq/faq-model.dart';
import '../services/client-service.dart';

class FaqController extends GetxController {
  Rx<Faq> faq = Faq().obs;
  RxList<Faq> faqList = <Faq>[].obs;
  @override
  void onInit() {
    getFaq();
    super.onInit();
  }

  getFaq() {
    ClientService.post(path: '/faq/search', payload: {}).then((value) {
      if (value.statusCode == 200) {
        // print(jsonEncode(value.data));
        //print(value.data);
        //  faq.value = Faq.fromJson(value.data);
        //    print(faq.value);

        //faq.value = Faq.fromMap(jsonDecode(value.data));

        faqList.value =
            (value.data as List).map((e) => Faq.fromMap(e)).toList();
      }
    });
  }
}
