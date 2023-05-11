import 'package:amber_bird/controller/referral-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
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
    Controller stateController = Get.find();
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
                    color: AppColors.white,
                    size: 15,
                  ),
                ],
              )),
          elevation: 1,
          title: Text(
            'Give 9${CodeHelp.euro} : Get 9${CodeHelp.euro} ',
            style: TextStyles.bodyFont.copyWith(color: Colors.white),
          )),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          Stack(
            children: [
              Positioned(
                top: 30,
                left: 150,
                child: Text(
                  'Get 9${CodeHelp.euro} for user you refer',
                  style:
                      TextStyles.bodyFont.copyWith(color: AppColors.primeColor),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .4,
                width: MediaQuery.of(context).size.width,
                child: Lottie.network(
                    'https://cdn2.sbazar.app/26525fe0-b20f-4a8c-b9a5-50d6ec73c5f0',
                    repeat: true),
              ),
            ],
          ),
          Obx(() {
            return stateController.isLogin.value
                ? controller.isLoading.value
                    ? const LinearProgressIndicator()
                    : Column(
                        children: [
                          Text(
                            'Share following link with your friends & family',
                            textAlign: TextAlign.center,
                            style: TextStyles.bodyFont
                                .copyWith(color: Colors.grey),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
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
                                  borderRadius: BorderRadius.circular(0),
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
                                        style: TextStyles.bodyFont
                                            .copyWith(color: AppColors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                : TextButton(
                    onPressed: () async {
                      Modular.to.navigate('../../widget/account');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          side: BorderSide(
                            color: AppColors.primeColor, // your color here
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5.0))),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.primeColor),
                    ),
                    child: Text(
                      'Invite Now',
                      style: TextStyles.headingFont
                          .copyWith(color: AppColors.white),
                    ),
                  );
          }),
          SizedBox(
            height: 400,
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 50,
                  leadingWidth: 50,
                  backgroundColor: AppColors.primeColor,
                  title: TabBar(
                    tabs: [
                      Tab(
                          child: Text(
                        '9€ Terms',
                        style:
                            TextStyles.bodyFont.copyWith(color: Colors.white),
                      )),
                      Tab(
                        child: Text('Earn S-COINS',
                            style: TextStyles.bodyFont
                                .copyWith(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    termsAndCondition(context),
                    scoinRules(context),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  termsAndCondition(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleText('Rules'),
          infoText(
              '1.A sends referral link to B worth 9€.\n2.B has 9 days to redeem the coupon by placing first order.\n3.When B placed first order within 9 days and order is shipped.\n4.A will get 9€ coupon which will expire in 29 days.'),
          const SizedBox(
            height: 10,
          ),
          titleText('Conditions'),
          infoText(
              '1.Referee can redeem only one coupon per order.\n2.Not in conjunction with other coupon.Cart value must be above €69.\n3.Excludes already discounted products.\n4.9€ offer valid for 99 days, later it will be 5€'),
        ],
      ),
    );
  }

  scoinRules(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleText('On Purchase'),
          infoText(
              'S-COINS/S-POINTS get added. ex: 100€ Purchase may yield 100 S-COINS/S-POINTS.'),
          const SizedBox(
            height: 10,
          ),
          titleText('On Referral'),
          infoText(
              'In addition to S-COINS earned from your own purchases you earn 10% extra Coins on purchases made by friends you referred.  Exciting ? Yes, sharing is always extra Happiness ,  Your points will show up after the end of the return limit period of the referred purchaser.There is always someone to share your happiness with. Lets celebrate sharing!😊'),
          const SizedBox(
            height: 10,
          ),
          titleText('Upcoming'),
          infoText('Monthly Tasks \nBonus Coins products.\nmuch more…'),
        ],
      ),
    );
  }

  titleText(String s) {
    return Text(
      s,
      style: TextStyles.bodyFont
          .copyWith(color: AppColors.primeColor, fontWeight: FontWeight.bold),
    );
  }

  infoText(String s) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        s,
        style: TextStyles.bodyFont
            .copyWith(color: AppColors.DarkGrey, fontWeight: FontWeight.w500),
      ),
    );
  }
}
