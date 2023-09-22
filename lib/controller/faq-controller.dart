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
    ClientService.post(path: 'faq/search', payload: {}).then((value) {
      if (value.statusCode == 200) {
        faqList.value =
            (value.data as List).map((e) => Faq.fromMap(e)).toList();
      }
    });
  }
}
