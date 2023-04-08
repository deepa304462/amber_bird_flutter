import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/bootom-drawer/forgot-pass.dart';
import 'package:amber_bird/ui/widget/privacy-help-terms-section.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../../helpers/controller-generator.dart';

class LoginWidget extends StatelessWidget {
  final AuthController authController = Get.find();
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  final Controller controller = Get.find();
  RxBool isLoading = false.obs;
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primeColor,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 48),
          child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome',
                    style:
                        TextStyles.headingFont.copyWith(color: AppColors.white),
                  ),
                  Text(
                    'Glad to see You!',
                    style:
                        TextStyles.headingFont.copyWith(color: AppColors.white),
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
                        style: TextStyles.headingFont
                            .copyWith(color: AppColors.white),
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
                      style: TextStyles.body.copyWith(color: AppColors.white),
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
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: AppColors.white)),
                          child: IconButton(
                            icon: isLoading.value
                                ? const Icon(Icons.refresh_outlined)
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
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: AppColors.white)),
                          child: IconButton(
                            icon: const Icon(Icons.facebook),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyles.body.copyWith(color: AppColors.white),
                      children: <TextSpan>[
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                            text: 'Sign up',
                            style: TextStyles.body
                                .copyWith(color: AppColors.secondaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                authController.resetFieldValue();
                                Modular.to.navigate('/signup'); 
                              }),
                      ],
                    ),
                  ),
                 
                  PrivacyHelpTermsSection()
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
