import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/ui/widget/appBar/location-widget.dart';
import 'package:amber_bird/ui/widget/search-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class AppBarWidget extends StatelessWidget {
  final Controller stateController = Get.find();
  final WishlistController wishlistController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: LocationWidget()
                // Showcase(
                //     key: stateController.showKeyMap['pincode']!.key,
                //     description: stateController.showKeyMap['pincode']!.desc,
                //     title: stateController.showKeyMap['pincode']!.title,
                //     child: LocationWidget()),
                ),
            Expanded(
              child: Image.asset(
                'assets/home.png',
                // width: 50,
                fit: BoxFit.cover,
              ),
            ),
            //  IconButton(onPressed: () => {}, icon: const Icon(Icons.layers)),
            Expanded(
              // alignment: Alignment.centerRight,
              // fit: BoxFit.fitHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Showcase(
                    key: stateController.showKeyMap['refer']!.key,
                    description: stateController.showKeyMap['refer']!.desc,
                    title: stateController.showKeyMap['refer']!.title,
                    titleTextStyle: TextStyles.titleFont,
                    descTextStyle: TextStyles.body,
                    child: IconButton(
                        onPressed: () =>
                            Modular.to.navigate('/widget/refer-page'),
                        icon: Icon(Icons.share, color: AppColors.DarkGrey)),
                  ),
                  Showcase(
                    key: stateController.showKeyMap['coinWallet']!.key,
                    description: stateController.showKeyMap['coinWallet']!.desc,
                    title: stateController.showKeyMap['coinWallet']!.title,
                    titleTextStyle: TextStyles.titleFont,
                    descTextStyle: TextStyles.body,
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        IconButton(
                          // padding: EdgeInsets.all(0),
                          onPressed: () {
                            if (stateController.isLogin.value) {
                              Modular.to.navigate('/widget/wallet');
                            } else {
                              // Modular.to.navigate('/login');
                              Modular.to.navigate('/widget/account');
                            }
                          },
                          icon: Icon(FontAwesomeIcons.coins,
                              color: AppColors.DarkGrey),
                        ),
                        InkWell(
                          onTap: () {
                            if (stateController.isLogin.value) {
                              Modular.to.navigate('/widget/wallet');
                            } else {
                              Modular.to.navigate('/widget/account');
                            }
                          },
                          child: Card(
                            color: Colors.yellow[700],
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Obx(
                                () => Text(
                                    stateController.customerDetail.value
                                                .personalInfo !=
                                            null
                                        ? stateController.customerDetail.value
                                            .personalInfo!.scoins
                                            .toString()
                                        : '0',
                                    style: TextStyles.bodySm),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchWidget(),
          ],
        ),
      ],
    );
  }
}

class AppBarShrinkWidget extends StatelessWidget {
  final Controller stateController = Get.find();
  final WishlistController wishlistController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        SearchWidget(),
        const SizedBox(
          width: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Showcase(
              key: stateController.showKeyMap['refer']!.key,
              description: stateController.showKeyMap['refer']!.desc,
              title: stateController.showKeyMap['refer']!.title,
              titleTextStyle: TextStyles.titleFont,
              descTextStyle: TextStyles.body,
              child: IconButton(
                  onPressed: () => Modular.to.navigate('/widget/refer-page'),
                  icon: Icon(Icons.share, color: AppColors.DarkGrey)),
            ),
            Showcase(
              key: stateController.showKeyMap['coinWallet']!.key,
              description: stateController.showKeyMap['coinWallet']!.desc,
              title: stateController.showKeyMap['coinWallet']!.title,
              titleTextStyle: TextStyles.headingFont,
              descTextStyle: TextStyles.body,
              child: Stack(
                fit: StackFit.loose,
                children: [
                  IconButton(
                    onPressed: () {
                      if (stateController.isLogin.value) {
                        // Modular.to.pushNamed('/widget/wallet');
                        Modular.to.navigate('/widget/wallet');
                      } else {
                        Modular.to.navigate('/widget/account');
                      }
                    },
                    icon:
                        Icon(FontAwesomeIcons.coins, color: AppColors.DarkGrey),
                  ),
                  InkWell(
                    onTap: () {
                      if (stateController.isLogin.value) {
                        // Modular.to.pushNamed('/widget/wallet');
                        Modular.to.navigate('/widget/wallet');
                      } else {
                        Modular.to.navigate('/widget/account');
                      }
                    },
                    child: Card(
                      color: Colors.yellow[700],
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Obx(
                          () => Text(
                              stateController
                                          .customerDetail.value.personalInfo !=
                                      null
                                  ? stateController
                                      .customerDetail.value.personalInfo!.scoins
                                      .toString()
                                  : '0',
                              style: TextStyles.bodySm),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
