import 'dart:convert';

import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
      if (response.statusCode == 200) {
        if (userData['username'] != null) {
          var tokenResp = await ClientService.get(
              path: 'auth', id: '${userData['username']}?locale=en');
          print(tokenResp);
          if (tokenResp.statusCode == 200) {
            SharedData.save(jsonEncode(tokenResp.data), 'userData');
            SharedData.save(true.toString(), 'isLogin');
            try {
              if (Get.isRegistered<Controller>()) {
                var controller = Get.find<Controller>();
                controller.getLoginInfo();
              }
            } catch (error) {
              FlutterNativeSplash.remove();
              Modular.to.navigate('/home/main');
            }
            FlutterNativeSplash.remove();
            Modular.to.navigate('/home/main');
          } else {
            //logout
            if (Get.isRegistered<Controller>()) {
              var controller = Get.find<Controller>();
              controller.logout();
            }
            FlutterNativeSplash.remove();
            Modular.to.navigate('/home/login');
          }
        }
      } else {
        FlutterNativeSplash.remove();
        Modular.to.navigate('/home/main');
      }
    } else {
      FlutterNativeSplash.remove();
      Modular.to.navigate('/home/login');
    }
  }
}
