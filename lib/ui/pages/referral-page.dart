import 'package:amber_bird/controller/referral-controller.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ReferralPage extends StatelessWidget {
  ReferralPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReferralController controller = Get.put(ReferralController());
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 50,
          leading: MaterialButton(
              onPressed: () {
                // Navigator.pop(context);
                 if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Modular.to.navigate('../../home/main');
                  // Modular.to.pushNamed('/home/main');
                }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.grey,
                    size: 15,
                  ),
                  // Text(
                  //   'Back',
                  //   style: TextStyles.bodyFont.copyWith(
                  //     color: AppColors.grey,
                  //   ),
                  // )
                ],
              )),
          elevation: 1,
          backgroundColor: Colors.white,
          title: Text(
            'Share & Earn Rewards',
            style: TextStyles.headingFont,
          )),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .4,
            width: MediaQuery.of(context).size.width,
            child: Lottie.network(
                'https://cdn2.sbazar.app/26525fe0-b20f-4a8c-b9a5-50d6ec73c5f0',
                repeat: true),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                return controller.isLoading.value
                    ? const LinearProgressIndicator()
                    : Column(
                        children: [
                          Text(
                            'Get ${CodeHelp.euro}9 for user you refer',
                            style: TextStyles.headingFont
                                .copyWith(color: AppColors.primeColor),
                          ),
                          Text(
                            'Share following link with your friends & family',
                            textAlign: TextAlign.center,
                            style: TextStyles.headingFont
                                .copyWith(color: Colors.grey),
                          ),
                          Row(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                        width: 2, color: AppColors.primeColor)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Obx(() {
                                    return Text(
                                      controller.shortLink.value.shortUrl!,
                                      style: TextStyles.bodyFontBold
                                          .copyWith(color: AppColors.grey),
                                    );
                                  }),
                                ),
                              ),
                              // const Divider(),
                              MaterialButton(
                                onPressed: () {
                                  CodeHelp.shareWithOther(
                                      'Try SBazar app now, ${controller.shortLink.value.shortUrl}',
                                      'Share now');
                                },
                                color: AppColors.primeColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.share,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Share',
                                        style: TextStyles.headingFont
                                            .copyWith(color: AppColors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      );
              })),
          termsAndCondition(context)
        ],
      ),
    );
  }

  termsAndCondition(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms & Conditions',
              style: TextStyles.headingFont,
            ),
            Text(
              '1. When your friend purchase something then you will get ${CodeHelp.euro}9 to your sbazar user account.',
              style: TextStyles.body,
            ),
            Text(
              '2. Offer can be change or limit.',
              style: TextStyles.body,
            )
          ],
        ),
      ),
    );
  }
}
