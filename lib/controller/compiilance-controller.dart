import 'package:amber_bird/data/complaince/complaince.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class CompilanceController extends GetxController {
  RxList<Complaince> compilanceList = <Complaince>[].obs;
  @override
  void onInit() {
    getCompilance();
    super.onInit();
  }

  getCompilance() {
    ClientService.post(path: 'complainceDetail/search', payload: {})
        .then((value) {
      if (value.statusCode == 200) {
        compilanceList.value =
            (value.data as List).map((e) => Complaince.fromMap(e)).toList();
      }
    });
  }
}
