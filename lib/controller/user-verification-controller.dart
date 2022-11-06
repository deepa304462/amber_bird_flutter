import 'dart:convert';

import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class UserVerificationController extends GetxController {
  final emailId;
  final token;

  UserVerificationController(this.emailId, this.token);

  @override
  void onInit() {
    verifyUser();

    super.onInit();
  }

  verifyUser() async {
    var userData = jsonDecode(await (SharedData.read('userData')));
    if (userData['authEmail'] == emailId) {
      var response = await ClientService.get(
          path: 'auth/confirm?email=${emailId}&token=${token}');
      if (response.statusCode == 200) {}
    }else{
      Modular.to.navigate('/home/main');
    }
    // "authEmail" -> "mridudixit15@gmail.com"
  }
}
