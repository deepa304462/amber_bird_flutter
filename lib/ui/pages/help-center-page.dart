import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/customer_insight/customer_insight.dart';
import 'package:amber_bird/data/user_profile/user_profile.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/pages/profile-page.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/section-card.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../helpers/controller-generator.dart';
import '../widget/privacy-help-terms-section.dart';

class HelpCenterPage extends StatelessWidget {
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
            // Navigator.pop(context);
            if (Modular.to.canPop()) {
              Modular.to.pop();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Modular.to.navigate('../../home/main');
            }
            // stateController.navigateToUrl('/home/main');
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
              'Help Center',
              style: TextStyles.headingFont.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(5),
          color: AppColors.commonBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Contact Us', style: TextStyles.headingFont),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: ImageBox(
                                        '',
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Center(
                                      child: FitText('Return & refund',
                                          style: TextStyles.body),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: ImageBox(
                                        '',
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Center(
                                      child: FitText('Customer Service',
                                          style: TextStyles.body),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: ImageBox(
                                        '',
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Center(
                                      child: FitText('Partnership',
                                          style: TextStyles.body),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: ImageBox(
                                        '',
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Center(
                                      child: FitText("We're Hiring!",
                                          style: TextStyles.body),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Need Immeddiate Assistance?',
                          style: TextStyles.headingFont),
                      sectionCard('Support at sbazar.app', '', () => {},
                          icon: Icons.mail),
                          sectionCard('0049 176 35298960', '', () => {},
                          icon: Icons.phone),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('FAQ',
                          style: TextStyles.headingFont),
                      sectionCard('Mail Order FAQ', '', () => {}),
                      sectionCard('How to get a refund', '', () => {}),
                      sectionCard('Buy Xget Y% Disfcount promotion', '', () => {}),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
