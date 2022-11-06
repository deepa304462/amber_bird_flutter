import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class LoginWidget extends StatelessWidget {
  final AuthController authController = Get.find();
    final CartController cartController = Get.find();
  final Controller controller = Get.find();
  RxBool isLoading = false.obs;
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
          child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    'https://cdn2.sbazar.app/383ba026-222a-4a16-8c24-b6f7f7227630',
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'Get access',
                    style: TextStyles.titleXLargePrimary,
                  ),
                  LoginType.mobilePassword == authController.loginWith.value
                      ? ITextBox('contact number', 'mobile', '', false,
                          TextInputType.phone, false,false, callback)
                      : const SizedBox(),
                  LoginType.emailPassword == authController.loginWith.value
                      ? ITextBox('Email', 'email', '', false,
                          TextInputType.emailAddress, false, false,callback)
                      : const SizedBox(),
                  LoginType.usernamePassword == authController.loginWith.value
                      ? ITextBox('Username', 'userName', '', false,
                          TextInputType.emailAddress, false, false,callback)
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  ITextBox('Password', 'password', '', false,
                      TextInputType.visiblePassword, true,false, callback),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.primeColor)),
                        child: Text(
                          isLoading.value ? 'Loading' : 'Login',
                          style: TextStyles.bodyWhiteLarge,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () async {
                          authController.resetFieldValue();
                          Modular.to.navigate('/home/signup');
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.lightGrey)),
                        child: Text(
                          'Sign Up',
                          style: TextStyles.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    onPressed: () {
                      authController.setLoginWith(LoginType.usernamePassword);
                    },
                    child: Text(
                      'Login with Username & Password',
                      style: (TextStyles.bodyFont),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    onPressed: () {
                      authController.setLoginWith(LoginType.emailPassword);
                    },
                    child: Text(
                      'Login with Email & Password',
                      style: (TextStyles.bodyFont),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      authController.setLoginWith(LoginType.mobilePassword);
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: Text(
                      'Login with Mobile & Password',
                      style: (TextStyles.bodyFont),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
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
                      const Icon(Icons.facebook),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  callback(String p1) {}
}
