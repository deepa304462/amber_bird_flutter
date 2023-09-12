import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/compiilance-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/pages/profile-page.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/section-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controller/faq-controller.dart';
import '../../helpers/controller-generator.dart';

class AccountPage extends StatelessWidget {
  final Controller stateController = Get.find();
  final FaqController faqController =
      ControllerGenerator.create(FaqController(), tag: 'faqController');
  final CompilanceController compilanceController =
      Get.put(CompilanceController());

  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  RxBool isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        stateController.navigateToUrl('/home/main');
        return Future<bool>.value(false);
      },
      child: Scaffold(
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
                  style: TextStyles.bodyFont.copyWith(color: Colors.white),
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
          )),
    );
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
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: ImageBox(
                                  '80febc8a-4623-476e-b948-f96c207a774b',
                                  width: MediaQuery.of(context).size.width * .2,
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
                              isLoading.value ? 'Loading' : 'Login / Sign up',
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
          sectionCard('Help Center', '', Icons.help_outline,
              () => {Modular.to.pushNamed('/widget/help-center')}),
          sectionCard('Setting', '', Icons.settings,
              () => { Modular.to
                  .pushNamed('../widget/edit-profile')}),
          sectionCard(
            'About Sbazar',
            '',
            Icons.info_outline_rounded,
            () => {Modular.to.pushNamed('/widget/about-page')},
          ),
          // PrivacyHelpTermsSection(),
        ],
      ),
    );
  }
}
