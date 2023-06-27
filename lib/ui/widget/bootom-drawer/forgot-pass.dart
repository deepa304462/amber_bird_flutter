import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassDrawer extends StatelessWidget {
  final AuthController authController = Get.find();
  RxBool isLoading = false.obs;
  RxString error = ''.obs;
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
            const SizedBox(height: 10),
            Obx(() => error.value != ''
                ? Text(error.value,
                    style:
                        TextStyles.body.copyWith(color: AppColors.primeColor))
                : const SizedBox()),
            TextButton(
              onPressed: () async {
                if (!isLoading.value) {
                  error.value = '';
                  isLoading.value = true;
                  var data = await authController.resetPassInit();
                  isLoading.value = false;
                  if (data['status'] == 'success') {
                    snackBarClass.showToast(
                        context, 'Please check your mail! ,thanks');
                    Navigator.of(context).pop();
                  } else {
                    error.value = data['msg'];
                    snackBarClass.showToast(context, data['msg']);
                  }
                }
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.primeColor)),
              child: Obx(() => Text(
                    !isLoading.value ? 'Forgot Password' : 'Loading',
                    style:
                        TextStyles.titleFont.copyWith(color: AppColors.white),
                  )),
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
