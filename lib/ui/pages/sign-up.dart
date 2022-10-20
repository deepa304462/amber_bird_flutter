import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatelessWidget {
  final AuthController authController = Get.find();
  final Controller controller = Get.find();
  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(builder: (mController) {
      return Card(
        elevation: 5,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sign Up',
                style: TextStyles.titleXLargePrimary,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              ITextBox(
                  'Full Name',
                  'fullName',
                  mController.fieldValue['fullName'].toString(),
                  false,
                  TextInputType.text,
                  false,
                  callback),
              const SizedBox(
                height: 10,
              ),
              ITextBox(
                  'Mobile',
                  'mobile',
                  mController.fieldValue['mobile'].toString(),
                  false,
                  TextInputType.phone,
                  false,
                  callback),
              const SizedBox(
                height: 10,
              ),
              ITextBox(
                  'Email',
                  'email',
                  mController.fieldValue['email'].toString(),
                  false,
                  TextInputType.emailAddress,
                  false,
                  callback),
              const SizedBox(
                height: 10,
              ),
              ITextBox(
                  'Password',
                  'password',
                  mController.fieldValue['password'].toString(),
                  false,
                  TextInputType.visiblePassword,
                  true,
                  callback),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  try {
                    isLoading.value = true;
                    var data = await mController.signInWithGoogle();
                    print(data);
                    if (data['status'] == 'success') {
                      controller.isLogin.value = true;
                      controller.setCurrentTab(0);
                    }
                    isLoading.value = false;
                    var showToast =
                        snackBarClass.showToast(context, data['msg']);
                  } catch (e) {
                    isLoading.value = false;
                    var showToast = snackBarClass.showToast(
                        context, 'Something went wrong...');
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        !isLoading.value ? 'Sign in with Google' : 'Loading',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  isLoading.value = true;
                  var data = await mController.signInWithFacebook();
                  if (data['status'] == 'success') {
                    controller.isLogin.value = true;
                    controller.setCurrentTab(0);
                  }
                  isLoading.value = false;
                  snackBarClass.showToast(context, data['msg']);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.facebook),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        !isLoading.value ? 'Sign in with Facebook' : 'Loading',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () async {
                  isLoading.value = true;
                  var data = await mController.signUp();
                  if (data['status'] == 'success') {
                    controller.isLogin.value = true;
                    controller.getLoginInfo();
                    controller.setCurrentTab(0);
                  }
                  isLoading.value = false;
                  snackBarClass.showToast(context, data['msg']);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.primeColor)),
                child: Text(
                  !isLoading.value ? 'Sign up' : 'Loading',
                  style: TextStyles.bodyWhiteLarge,
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  callback(String p1) {}
}
