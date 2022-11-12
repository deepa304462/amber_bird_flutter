import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/element/reset-password.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class ResetPasswordWidget extends StatelessWidget {
  final Controller stateController = Get.find();
  final AuthController authController = Get.put(AuthController());
  final CartController cartController = Get.find();

  RxBool isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                  onPressed: () {
                    Modular.to.navigate('../home/main');
                  },
                  icon: const Icon(Icons.arrow_back))
            ]),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ResetPassTextBox('Current Password', 'currentPassword', authController.resetPasswordValue['currentPassword'].toString(),
                        false, TextInputType.text, true, false, callback),
                    const SizedBox(
                      height: 10,
                    ),
                    ResetPassTextBox('New Password', 'newPassword', authController.resetPasswordValue['newPassword']
                            .toString(), false,
                        TextInputType.text, true, false, callback),
                    const SizedBox(
                      height: 10,
                    ),
                    ResetPassTextBox('Confirm Password', 'confirmPassword', authController.resetPasswordValue['confirmPassword']
                            .toString(),
                        false, TextInputType.text, true, false, callback),
                    !authController.passMatch.value
                        ? const Text('Confirm p/w & new p/w mismatches')
                        : const SizedBox(),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () async {
                        if (authController.passMatch.value) {
                          isLoading.value = true;
                          var data = await authController.resetPassword();
                          // if (data['status'] == 'success') {

                          //   cartController.fetchCart();
                          // }
                          isLoading.value = false;
                          snackBarClass.showToast(context, data['msg']);
                        } else {
                          snackBarClass.showToast(context,
                              "New Password and Confirm Password mismatched");
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.primeColor)),
                      child: Text(
                        !isLoading.value ? 'Reset Password' : 'Loading',
                        style: TextStyles.bodyWhiteLarge,
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  callback(String p1) {}
}
