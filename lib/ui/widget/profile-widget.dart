import 'dart:developer';

import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/image-picker.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class ProfileWidget extends StatelessWidget {
  final Controller stateController = Get.find();
  final AuthController authController = Get.put(AuthController());
  final CartController cartController = Get.find();

  RxBool isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Email', style: TextStyles.bodyFont),
                      Text(stateController.loggedInProfile.value.email ?? '',
                          style: TextStyles.bodyFontBold),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Email verified', style: TextStyles.bodyFont),
                      Switch(
                        value: stateController.isEmailVerified.value,
                        onChanged: null,
                      ),
                      !stateController.isEmailVerified.value
                          ? TextButton(
                              onPressed: () async {
                                var data = await stateController.resendMail();
                                if (data != null) {
                                  snackBarClass.showToast(context, data['msg']);
                                }
                              },
                              child: Text('Verify Mail',
                                  style: TextStyles.bodyGreen),
                            )
                          : const SizedBox()
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Mobile verified'),
                      Switch(
                        value: stateController.isPhoneVerified.value,
                        onChanged: null,
                      ),
                      !stateController.isPhoneVerified.value
                          ? TextButton(
                              onPressed: () async {
                                var data = await stateController.resendMail();
                                if (data != null) {
                                  snackBarClass.showToast(context, data['msg']);
                                }
                              },
                              child: Text('Verify Mobile',
                                  style: TextStyles.bodyGreen),
                            )
                          : const SizedBox()
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      // height: ,
                      child: ImagePickerPage(
                          stateController.loggedInProfile.value.profileIcon ??
                              '',
                          imageCallback,
                          isLoadingCallback),
                    ),
                    ITextBox(
                        'Full Name',
                        'fullName',
                        stateController.loggedInProfile.value.fullName
                            .toString(),
                        false,
                        TextInputType.text,
                        false,
                        false,
                        callback),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () async {
                        isLoading.value = true;
                        var data = await authController.editProfile();
                        if (data['status'] == 'success') {
                          stateController.isLogin.value = true;
                          stateController.getLoginInfo();
                          stateController.setCurrentTab(0);
                          cartController.fetchCart();
                        }
                        isLoading.value = false;
                        snackBarClass.showToast(context, data['msg']);
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.primeColor)),
                      child: Text(
                        !isLoading.value ? 'Edit Profile' : 'Loading',
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

  callback(String name, String text) {
    authController.setFielsvalue(text, name);
  }

  imageCallback(String p1) {
    // 'profileImageId':''

    authController.setFielsvalue(p1, 'profileImageId'); 
  }

  isLoadingCallback(bool val) {
    isLoading.value = val;
  }
}
