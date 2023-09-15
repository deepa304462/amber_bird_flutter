import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/customer_insight/customer_insight.dart';
import 'package:amber_bird/data/user_profile/user_profile.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:amber_bird/ui/widget/section-card.dart';

import '../../helpers/controller-generator.dart';

class ProfilePage extends StatelessWidget {
  final Controller stateController = Get.find();
  final WishlistController wishlistController = Get.find();
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  RxBool isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        profileCard(context, stateController.loggedInProfile.value,
            stateController.customerInsight.value),
        myOrders(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Modular.to.pushNamed('/widget/refer-page');
                  },
                  child: ListTile(
                    dense: true,
                    leading: Icon(Icons.wallet_giftcard),
                    title: RichText(
                      text: TextSpan(
                        style: TextStyles.body,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Refer Friends, Get ',
                            style: TextStyles.headingFont,
                          ),
                          TextSpan(
                            text: '9${CodeHelp.euro}',
                            style: TextStyles.headingFont
                                .copyWith(color: AppColors.primeColor),
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                // sectionCard(
                //     'Refer Friends, Get 9${CodeHelp.euro}',
                //     '',
                //     Icons.wallet_giftcard,
                //     () => {Modular.to.pushNamed('/widget/refer-page')},
                //     isDense: true),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card(
              child: Column(
            children: [
              sectionCard('Help Center', '', Icons.help_outline_rounded,
                  () => {Modular.to.pushNamed('/widget/help-center')},
                  isDense: true),
              sectionCard('Setting', '', Icons.settings,
                  () => {Modular.to.pushNamed('../widget/edit-profile')},
                  isDense: true),
              sectionCard(
                'About Sbazar',
                '',
                Icons.info_outline_rounded,
                () => {Modular.to.pushNamed('/widget/about-page')},
                isDense: true,
              ),
            ],
          )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            child: Center(
              child: InkWell(
                onTap: () {
                  stateController.logout();
                  cartController.fetchCart();
                },
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  height: 300,
                  child: Text(
                    'Log Out',
                    style: TextStyles.headingFont,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  myOrders() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: Column(children: [
          InkWell(
            onTap: () {
              Modular.to.pushNamed('../widget/orders');
            },
            child: ListTile(
              dense: true,
              leading: Icon(Icons.list_alt),
              title: Text(
                'Orders',
                style: TextStyles.headingFont,
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 80,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Modular.to.pushNamed('../widget/orders');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            border: Border.all(color: AppColors.lightGrey)),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.monitor,
                            size: 30,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text('Pending', style: TextStyles.body),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 80,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Modular.to.pushNamed('../widget/orders');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            border: Border.all(color: AppColors.lightGrey)),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.shopping_bag,
                            size: 30,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: FitText('Processing', style: TextStyles.body),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 80,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Modular.to.pushNamed('../widget/orders');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            border: Border.all(color: AppColors.lightGrey)),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.local_shipping_outlined,
                            size: 30,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: FitText('Shipped', style: TextStyles.body),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 80,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Modular.to.pushNamed('../widget/orders');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            border: Border.all(color: AppColors.lightGrey)),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.done,
                            size: 30,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: FitText("Received", style: TextStyles.body),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 80,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Modular.to.pushNamed('../widget/orders');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            border: Border.all(color: AppColors.lightGrey)),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.cancel,
                            size: 30,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: FitText('Cancel', style: TextStyles.body),
                    )
                  ],
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  profileCard(
      BuildContext context, UserProfile value, CustomerInsight insight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Lottie.asset('assets/profile-cover-background.json',
                width: MediaQuery.of(context).size.width,
                height: 230,
                fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: (stateController
                                        .loggedInProfile.value.profileIcon !=
                                    '' &&
                                stateController
                                        .loggedInProfile.value.profileIcon !=
                                    null)
                            ? ImageBox(
                                '${stateController.loggedInProfile.value.profileIcon}',
                                width: MediaQuery.of(context).size.width * .2,
                                type: 'download',
                              )
                            : ImageBox(
                                '80febc8a-4623-476e-b948-f96c207a774b',
                                width: MediaQuery.of(context).size.width * .2,
                              ),
                      ),
                      Expanded(
                        child: ListTile(
                          dense: true,
                          title: Row(
                            children: [
                              FitText(
                                CodeHelp.titleCase(value.fullName ?? ''),
                                style: TextStyles.headingFont
                                    .copyWith(color: Colors.black),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Modular.to
                                        .pushNamed('../widget/edit-profile');
                                  },
                                  icon: const Icon(
                                    Icons.edit_rounded,
                                    size: 18,
                                  ))
                            ],
                          ),
                          subtitle: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ImageBox(
                                    stateController.membershipList[
                                                stateController
                                                    .userType.value] !=
                                            null
                                        ? stateController
                                            .membershipList[
                                                stateController.userType.value]!
                                            .iconId!
                                        : '',
                                    width: 15,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  FitText(stateController.getMemberShipText(),
                                      style: TextStyles.titleFont),
                                ],
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.call,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  FitText(value.mobile!,
                                      style: TextStyles.titleFont),
                                ],
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Icon(
                                    Icons.email,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  FitText(value.email!,
                                      style: TextStyles.titleFont),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: InkWell(
                              onTap: () {
                                Modular.to.pushNamed('/widget/wallet');
                              },
                              child: Column(
                                children: [
                                  Text(
                                    stateController.customerDetail.value
                                                .personalInfo !=
                                            null
                                        ? stateController.customerDetail.value
                                            .personalInfo!.scoins
                                            .toString()
                                        : '0',
                                    style: TextStyles.headingFont,
                                  ),
                                  Center(
                                    child: FitText('S-Coins',
                                        style: TextStyles.body),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: InkWell(
                              onTap: () {
                                Modular.to.pushNamed('/widget/wallet');
                              },
                              child: Column(
                                children: [
                                  Text(
                                    stateController.customerDetail.value
                                                .personalInfo !=
                                            null
                                        ? stateController.customerDetail.value
                                            .personalInfo!.spoints
                                            .toString()
                                        : '0',
                                    style: TextStyles.headingFont,
                                  ),
                                  Center(
                                    child: Text('S-Points',
                                        style: TextStyles.body),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: InkWell(
                              onTap: () {
                                Modular.to.pushNamed('/widget/wishlist');
                              },
                              child: Column(children: [
                                Text(
                                  wishlistController.wishlistProducts.length > 0
                                      ? wishlistController
                                          .wishlistProducts.length
                                          .toString()
                                      : '0',
                                  style: TextStyles.headingFont,
                                ),
                                Center(
                                  child: FitText('Wishlist',
                                      style: TextStyles.body),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: InkWell(
                              onTap: () {
                                Modular.to.pushNamed('/widget/cart');
                              },
                              child: Column(
                                children: [
                                  Text(
                                    (cartController.saveLaterProducts.length)
                                        .toString(),
                                    style: TextStyles.headingFont,
                                  ),
                                  Center(
                                    child: FitText("Saved",
                                        style: TextStyles.body),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     MaterialButton(
                  //       onPressed: (() {
                  //         Modular.to.pushNamed('../widget/orders');
                  //       }),
                  //       child: Row(
                  //         children: [
                  //           const Icon(
                  //             Icons.grade,
                  //             color: Colors.blue,
                  //           ),
                  //           Text(
                  //             'Orders',
                  //             style: TextStyles.headingFont,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     MaterialButton(
                  //       onPressed: (() {
                  //         Modular.to.pushNamed('../widget/wishlist');
                  //       }),
                  //       child: Row(
                  //         children: [
                  //           const Icon(
                  //             Icons.favorite,
                  //             color: Colors.red,
                  //           ),
                  //           Text(
                  //             'Wishlist',
                  //             style: TextStyles.headingFont,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     MaterialButton(
                  //       onPressed: (() {}),
                  //       child: Row(
                  //         children: [
                  //           const Icon(
                  //             Icons.local_activity,
                  //             color: Colors.amberAccent,
                  //           ),
                  //           Text(
                  //             'Events',
                  //             style: TextStyles.headingFont,
                  //           ),
                  //         ],
                  //       ),
                  //     )
                  //   ],
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
