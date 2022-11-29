import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/update-password-controller.dart';
import 'package:amber_bird/ui/element/reset-password.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ResetPasswordWidget extends StatelessWidget {
  // final Controller stateController = Get.find();

  // final CartController cartController = Get.find();

  RxBool isLoading = false.obs;

  final String email;
  final String code;
  ResetPasswordWidget(this.email, this.code, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UpdatePasswordController updatePassController =
        Get.put(UpdatePasswordController(email, code));
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                // Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       IconButton(
                //           onPressed: () {
                //             Modular.to.navigate('../home/main');
                //           },
                //           icon: const Icon(Icons.arrow_back))
                //     ]),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Lottie.network(
                            'https://assets8.lottiefiles.com/packages/lf20_i1e4j8gy.json',
                            frameRate: FrameRate(50),
                            repeat: false),
                        // ResetPassTextBox(
                        //     'Current Password',
                        //     'currentPassword',
                        //     authController.resetPasswordValue['currentPassword']
                        //         .toString(),
                        //     false,
                        //     TextInputType.text,
                        //     true,
                        //     false,
                        //     callback),
                        const SizedBox(
                          height: 10,
                        ),
                        ResetPassTextBox(
                            'New Password',
                            'newPassword',
                            updatePassController
                                .resetPasswordValue['newPassword']
                                .toString(),
                            false,
                            TextInputType.text,
                            true,
                            false,
                            callback),
                        const SizedBox(
                          height: 10,
                        ),
                        ResetPassTextBox(
                            'Confirm Password',
                            'confirmPassword',
                            updatePassController
                                .resetPasswordValue['confirmPassword']
                                .toString(),
                            false,
                            TextInputType.text,
                            true,
                            false,
                            callback),
                        !updatePassController.passMatch.value
                            ? const Text('Confirm p/w & new p/w mismatches')
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          onPressed: () async {
                            if (updatePassController.passMatch.value) {
                              isLoading.value = true;
                              var data = await updatePassController
                                  .resetPassword(code);
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
                            !isLoading.value ? 'Update Password' : 'Loading',
                            style: TextStyles.bodyWhiteLarge,
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  callback(String p1) {}
}
