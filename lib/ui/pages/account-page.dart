import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/pages/profile-page.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/section-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../helpers/controller-generator.dart';

class AccountPage extends StatelessWidget {
  final Controller stateController = Get.find();
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  RxBool isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          toolbarHeight: 50,
          leadingWidth: 50,
          backgroundColor: AppColors.primeColor,
          leading: MaterialButton(
            onPressed: () {
              stateController.navigateToUrl('/home/main');
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 15,
            ),
          ),
          title: Column(
            children: [
              Text(
                'My Profile',
                style: TextStyles.headingFont.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Obx(
            () => stateController.isLogin.value
                ? ProfilePage()
                : AccountWidget(context),
          ),
        ));
  }

  Widget AccountWidget(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.asset('assets/profile-cover-background.json',
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: (stateController.loggedInProfile.value
                                              .profileIcon !=
                                          '' &&
                                      stateController.loggedInProfile.value
                                              .profileIcon !=
                                          null)
                                  ? ImageBox(
                                      '${stateController.loggedInProfile.value.profileIcon}',
                                      width: MediaQuery.of(context).size.width *
                                          .2,
                                      type: 'download',
                                    )
                                  : ImageBox(
                                      '35b50ba9-3bfe-4688-8b22-1d56f657f3bb',
                                      width: MediaQuery.of(context).size.width *
                                          .2,
                                    ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: FitText(
                                  'Full Name',
                                  style: TextStyles.titleFont
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextButton(
                            onPressed: () async {
                              Modular.to.navigate('/login');
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: AppColors
                                            .primeColor, // your color here
                                        width: 1,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppColors.primeColor),
                            ),
                            child: Text(
                              isLoading.value ? 'Loading' : 'Login',
                              style: TextStyles.headingFont
                                  .copyWith(color: AppColors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          sectionCard('Help Center', '',Icons.question_mark_rounded,
              () => {Modular.to.pushNamed('/widget/help-center')} ),
          sectionCard('About Sbazar', '', Icons.info_outline_rounded,
              () => {Modular.to.pushNamed('/widget/about-page')},
              ),
          // PrivacyHelpTermsSection(),
        ],
      ),
    );
  }
}
