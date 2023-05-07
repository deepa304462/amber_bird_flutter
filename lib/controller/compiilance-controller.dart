import 'package:amber_bird/data/compilance/compilance.dart';
import 'package:amber_bird/services/client-service.dart'; 
import 'package:get/get.dart'; 

class CompilanceController extends GetxController {
   RxList<Compilance> compilanceList = <Compilance>[].obs;
  @override
  void onInit() {
    getCompilance();
    super.onInit();
  }

  getCompilance()   {
     ClientService.post(path: 'complainceDetail/search', payload: {})
        .then((value) {
      compilanceList.value = (value.data as List).map((e) => Compilance.fromMap(e)).toList(); 
    });
  }
}
