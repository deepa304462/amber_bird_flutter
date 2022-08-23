import 'package:amber_bird/data/appmanger/appmanger.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
 
class OnBoardingController extends GetxController {
  var onboardingData = Appmanger.fromJson("{}").obs;
  @override
  void onInit() {
    getOboarding();
    super.onInit();
  }

  getOboarding() async {
    var payload = {'': ''};
    var response = await ClientService.get(
        path: 'appManager', id: '60180d73-0c10-4d04-a22a-00ab2137e31f');

    if (response.statusCode == 200) {
      Appmanger data = Appmanger.fromMap(response.data as Map<String, dynamic>);
      onboardingData.value = (data);
      print(data);
         }
  }

  
}
