import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassDrawer extends StatelessWidget {
  final AuthController authController = Get.find();
  RxBool isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Container(
        color: AppColors.commonBgColor,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Forgot Password',
              style: TextStyles.titleFont.copyWith(color: AppColors.green),
            ),
            const SizedBox(height: 20),
            ITextBox(
                'Email',
                'email',
                authController.fieldValue['email'].toString(),
                false,
                TextInputType.emailAddress,
                false,
                false,
                callback),
            //           ITextBox(
            // 'Username',
            // 'username',
            // authController.fieldValue['username'].toString(),
            // false,
            // TextInputType.text,
            // false,
            // false,
            // callback),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                isLoading.value = true;
                await authController.resetPassInit();
                isLoading.value = false;
                snackBarClass.showToast(
                    context, 'Please check your mail! ,thanks');
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.primeColor)),
              child: Text(
                !isLoading.value ? 'Forgot Password' : 'Loading',
                style: TextStyles.titleFont.copyWith(color: AppColors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  callback(String name, String text) {
    authController.setFielsvalue(text, name);
  }
}
