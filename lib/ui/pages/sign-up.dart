import 'dart:developer';

import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatelessWidget {
  final AuthController authController = Get.find();
  final Controller controller = Get.find();
  final CartController cartController = Get.find();
  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(builder: (mController) {
      return Card(
        elevation: 5,
        color: AppColors.primeColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: SingleChildScrollView(
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
                // SizedBox(
                //   height: 200,
                //   child: ImagePickerPage(
                //       controller.loggedInProfile.value.profileIcon ?? '',
                //       imageCallback,
                //       isLoadingCallback),
                // ),
                const SizedBox(
                  height: 0,
                ),
                ITextBox(
                    'Full Name',
                    'fullName',
                    mController.fieldValue['fullName'].toString(),
                    false,
                    TextInputType.text,
                    false,
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
                    false,
                    callback),
                const SizedBox(
                  height: 10,
                ),
                ITextBox(
                    'Username',
                    'username',
                    mController.fieldValue['username'].toString(),
                    false,
                    TextInputType.text,
                    false,
                    false,
                    callback),
                mController.usernameValid.value
                    ? const SizedBox()
                    : Text(
                        'Not Valid Username. Suggestion: ${mController.suggestedUsername.value}',
                        style: TextStyles.bodyWhite,
                      ),
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
                    mController.fieldValue['isThirdParty'] as bool,
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
                    false,
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
                        // controller.isLogin.value = true;
                        // controller.getLoginInfo();
                        // controller.setCurrentTab(0);
                        // cartController.fetchCart();
                      }
                      isLoading.value = false;

                      snackBarClass.showToast(context, data['msg']);
                    } catch (e) {
                      isLoading.value = false;
                      snackBarClass.showToast(
                          context, 'Something went wrong...');
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: const Image(
                          image: AssetImage("assets/google_logo.png"),
                          height: 35.0,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            !isLoading.value
                                ? 'Sign in with Google'
                                : 'Loading',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
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
                      controller.getLoginInfo();
                      controller.setCurrentTab(0);
                      cartController.fetchCart();
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
                          !isLoading.value
                              ? 'Sign in with Facebook'
                              : 'Loading',
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
                TextButton(
                  onPressed: () async {
                    await mController.checkValidityUsername();
                    if (mController.usernameValid.value) {
                      isLoading.value = true;
                      var data = await mController.signUp();
                      if (data['status'] == 'success') {
                        controller.getLoginInfo();
                        controller.setCurrentTab(0);
                        cartController.fetchCart();
                      }
                      isLoading.value = false;
                      snackBarClass.showToast(context, data['msg']);
                    } else {
                      snackBarClass.showToast(
                          context, 'Please fill corrct username');
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.primeColor)),
                  child: Text(
                    !isLoading.value ? 'Sign up' : 'Loading',
                    style: TextStyles.bodyWhiteLarge,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  callback(String name, String text) {
    authController.setFielsvalue(text, name);
  }

  imageCallback(String p1) {
    authController.setFielsvalue(p1, 'profileImageId');
    log(p1);
  }

  isLoadingCallback(bool val) {
    isLoading.value = val;
  }
}
