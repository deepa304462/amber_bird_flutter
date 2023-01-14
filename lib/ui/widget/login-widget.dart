import 'dart:developer';

import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/bootom-drawer/forgot-pass.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class LoginWidget extends StatelessWidget {
  final AuthController authController = Get.find();
  final CartController cartController = Get.find();
  final Controller controller = Get.find();
  RxBool isLoading = false.obs;
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primeColor,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 48),
          child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyles.bodyWhiteLargeBold,
                  ),
                  Text(
                    'Glad to see You!',
                    style: TextStyles.bodyWhiteLarge,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  LoginType.mobilePassword == authController.loginWith.value
                      ? ITextBox('contact number', 'mobile', '', false,
                          TextInputType.phone, false, false, callback)
                      : const SizedBox(),
                  LoginType.emailPassword == authController.loginWith.value
                      ? ITextBox('Email', 'email', '', false,
                          TextInputType.emailAddress, false, false, callback)
                      : const SizedBox(),
                  LoginType.usernamePassword == authController.loginWith.value
                      ? ITextBox('Username', 'username', '', false,
                          TextInputType.text, false, false, callback)
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  ITextBox('Password', 'password', '', false,
                      TextInputType.visiblePassword, true, false, callback),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        showModalBottomSheet<void>(
                          // context and builder are
                          // required properties in this widget
                          context: context,
                          useRootNavigator: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)),
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          elevation: 3,
                          builder: (context) {
                            return ForgotPassDrawer();
                          },
                        );
                      },
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyles.bodyWhiteBold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      onPressed: () async {
                        isLoading.value = true;
                        var data = await authController.login();
                        print(data);
                        if (data['status'] == 'success') {
                          controller.getLoginInfo();
                          controller.isLogin.value = true;
                          controller.setCurrentTab(0);
                          cartController.fetchCart();
                        }
                        isLoading.value = false;
                        snackBarClass.showToast(context, data['msg']);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(AppColors.white),
                      ),
                      child: Text(
                        isLoading.value ? 'Loading' : 'Login',
                        style: TextStyles.headingFont,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: Divider(
                            color: AppColors.white,
                            height: 36,
                          )),
                    ),
                    Text(
                      "Or Login with",
                      style: TextStyles.bodyWhite,
                    ),
                    Expanded(
                      child: Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 10.0),
                          child: Divider(
                            color: AppColors.white,
                            height: 36,
                          )),
                    ),
                  ]),
                  // TextButton(
                  //   style: TextButton.styleFrom(
                  //       padding: EdgeInsets.zero,
                  //       minimumSize: Size(50, 30),
                  //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //       alignment: Alignment.centerLeft),
                  //   onPressed: () {
                  //     authController.setLoginWith(LoginType.usernamePassword);
                  //   },
                  //   child: Text(
                  //     'Login with Username & Password',
                  //     style: (TextStyles.bodyFont),
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: isLoading.value
                              ? Icon(Icons.refresh_outlined)
                              : Image.asset(
                                  "assets/google_logo.png",
                                  width: 25,
                                ),
                          iconSize: 10,
                          onPressed: () async {
                            isLoading.value = true;
                            var data = await authController.LoginWithGoogle();
                            if (data['status'] == 'success') {
                              controller.isLogin.value = true;
                              controller.getLoginInfo();
                              controller.setCurrentTab(0);
                              cartController.fetchCart();
                            }
                            isLoading.value = false;
                            snackBarClass.showToast(context, data['msg']);
                          },
                        ),
                      ),
                      Expanded(
                        child: const Icon(Icons.facebook),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyles.bodyWhiteLarge,
                      children: <TextSpan>[
                        TextSpan(text: "Don't have an account? "),
                        TextSpan(
                            text: 'Sign up',
                            style: TextStyles.titleGreen,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                authController.resetFieldValue();
                                Modular.to.navigate('/home/signup');
                                print('Sign up"');
                              }),
                      ],
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () async {
                  //     authController.resetFieldValue();
                  //     Modular.to.navigate('/home/signup');
                  //   },
                  //   style: ButtonStyle(
                  //       backgroundColor: MaterialStateProperty.all<Color>(
                  //           AppColors.lightGrey)),
                  //   child: Text(
                  //     'Sign Up',
                  //     style: TextStyles.titleLarge,
                  //   ),
                  // ),
                  // TextButton(
                  //   style: TextButton.styleFrom(
                  //       padding: EdgeInsets.zero,
                  //       minimumSize: Size(50, 30),
                  //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //       alignment: Alignment.centerLeft),
                  //   onPressed: () {
                  //     authController.setLoginWith(LoginType.emailPassword);
                  //   },
                  //   child: Text(
                  //     'Login with Email & Password',
                  //     style: (TextStyles.bodyFont),
                  //   ),
                  // ),
                  // TextButton(
                  //   onPressed: () {
                  //     authController.setLoginWith(LoginType.mobilePassword);
                  //   },
                  //   style: TextButton.styleFrom(
                  //       padding: EdgeInsets.zero,
                  //       minimumSize: Size(50, 30),
                  //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //       alignment: Alignment.centerLeft),
                  //   child: Text(
                  //     'Login with Mobile & Password',
                  //     style: (TextStyles.bodyFont),
                  //   ),
                  // ),
                ],
              )),
        ),
      ),
    );
  }

  callback(String name, String text) {
    authController.setFielsvalue(text, name);
  }
}
