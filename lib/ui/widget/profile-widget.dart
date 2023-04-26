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

import '../../helpers/controller-generator.dart';

class EditProfilePage extends StatelessWidget {
  final Controller stateController = Get.find();
  final AuthController authController = Get.put(AuthController());
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');

  RxBool isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primeColor,
          title: Text(
            'Edit Profile',
            style: TextStyles.headingFont.copyWith(color: Colors.white),
          ),
          leadingWidth: 50,
          leading: IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Modular.to.navigate('/home/main');
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
        floatingActionButton: MaterialButton(
          color: AppColors.primeColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          child: Text(
            !isLoading.value ? 'Save Profile' : 'Loading',
            style: TextStyles.body.copyWith(color: AppColors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       IconButton(
                //           onPressed: () {
                //             if (Navigator.canPop(context)) {
                //               Navigator.pop(context);
                //             } else {
                //               Modular.to.navigate('/home/main');
                //             }
                //           },
                //           icon: const Icon(Icons.arrow_back_ios,size: 15,))
                //     ]),
                SizedBox(
                  // height: ,
                  child: ImagePickerPage(
                      stateController.loggedInProfile.value.profileIcon ?? '',
                      imageCallback,
                      isLoadingCallback),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.commonBgColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppColors.commonBgColor)),
                  child: ITextBox(
                      'Full Name',
                      'fullName',
                      stateController.loggedInProfile.value.fullName.toString(),
                      false,
                      TextInputType.text,
                      false,
                      false,
                      callback),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Email', style: TextStyles.bodyFont),
                    Text(stateController.loggedInProfile.value.email ?? '',
                        style: TextStyles.bodyFontBold),
                  ],
                ),
                Text(
                    'Email is ${stateController.isEmailVerified.value ? ' verified' : 'not verified'}',
                    style: TextStyles.bodyFont),
                Text(
                    'Mobile number is ${stateController.isPhoneVerified.value ? ' verified' : 'not verified'}',
                    style: TextStyles.bodyFont),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Modular.to.navigate('../widget/address-list');
                    },
                    child: Text('Click to check saved addresses',
                        style: TextStyles.headingFont)),
                TextButton(
                  onPressed: () async {
                    isLoading.value = true;
                    // Modular.to.navigate('../home/reset-password');
                    var data = await stateController.resetPassInit();
                    isLoading.value = false;
                    snackBarClass.showToast(
                        context, 'Please check your mail !,thanks');
                  },
                  child: Text(
                      isLoading.value ? "Loading" : "Click to reset password",
                      style: TextStyles.headingFont),
                ),
              ],
            ),
          ),
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
