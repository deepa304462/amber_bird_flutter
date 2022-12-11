import 'dart:convert';

import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  var resetPasswordValue = {'currentPassword': '', 'newPassword': '', 'confirmPassword': ''}.obs;
  RxBool passMatch = true.obs;
  final emailId;
  final token;

  UpdatePasswordController(this.emailId, this.token);

  @override
  void onInit() {
    checkUser();
    FlutterNativeSplash.remove();
    super.onInit();
  }

  checkUser() async {
    var data = jsonDecode(await SharedData.read('userData'));
    if (data['authEmail'] != emailId) {
      Modular.to.navigate('/home/main');
    }
  }

  void setResetPassvalue(String text, String name) {
    resetPasswordValue.value[name] = text;
    if (resetPasswordValue.value['newPassword'] !=
        resetPasswordValue.value['confirmPassword']) {
      passMatch.value = false;
    } else {
      passMatch.value = true;
    }
  }

  resetPassword(String token) async {
    var controller = Get.find<Controller>();
    var payload = {
      'email': controller.loggedInProfile.value.email,
      'password': resetPasswordValue.value['newPassword'],
      'token': token
    };
    var userUpdateResp =
        await ClientService.post(path: 'auth/passwordReset', payload: payload);
    if (userUpdateResp.statusCode == 200) {
      Modular.to.navigate('/home/main');
      return {"msg": "Edited Successfully!!", "status": "success"};
    } else {
      return {"msg": "Something Went Wrong!!", "status": "error"};
    }
  }
}
