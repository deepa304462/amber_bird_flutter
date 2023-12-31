import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/services/firebase-cloud-message-sync-service.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class ComingSoonWidget extends StatelessWidget {
  final AuthController authController = Get.find();
  RxBool isLoading = false.obs;

  callback(String name, String text) {
    authController.setFielsvalue(text, name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        leadingWidth: 50,
        backgroundColor: AppColors.primeColor,
        title: Text(
          'Welcome',
          style: TextStyles.bodyFont.copyWith(color: Colors.white),
        ),
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
      body: Container(
        color: AppColors.commonBgColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 48),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // Text('Welcome  to Sbazar', style: TextStyles.headingFont),
              Image.asset(
                'assets/app_initial_loading_screen.png',
                width: MediaQuery.of(context).size.width * .7,
              ),
              Image.asset(
                'assets/biggest.png',
                width: MediaQuery.of(context).size.width * .7,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'LAUNCHING SOON',
                      style: TextStyles.headingFont
                          .copyWith(color: AppColors.primeColor),
                    )
                  ],
                ),
              ),
              // SizedBox(
              //   height: 200,
              //   width: MediaQuery.of(context).size.width,
              //   child: Lottie.network(
              //     'https://assets5.lottiefiles.com/packages/lf20_vw2szd2m.json',
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              Text(
                'To get notified, please submit your mail and connect with us',
                style:
                    TextStyles.headingFont.copyWith(color: AppColors.DarkGrey),
              ),
              ITextBox('Email', 'email', '', false, TextInputType.emailAddress,
                  false, false, callback),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () async {
                    isLoading.value = true;
                    var data = await authController.addInMarketInfo();
                    if (data['status'] == 'success') {
                      FCMSyncService.subcribeTopic('launch_subscriber');
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Modular.to.navigate('/home/main');
                      }
                    }
                    isLoading.value = false;
                    snackBarClass.showToast(context, data['msg']);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.primeColor, // your color here
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5.0))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.primeColor),
                  ),
                  child: Text(
                    isLoading.value ? 'Loading' : 'Submit',
                    style:
                        TextStyles.headingFont.copyWith(color: AppColors.white),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
