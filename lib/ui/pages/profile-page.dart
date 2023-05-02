import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
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

import '../../helpers/controller-generator.dart';
import '../widget/privacy-help-terms-section.dart';

class ProfilePage extends StatelessWidget {
  final Controller stateController = Get.find();
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  RxBool isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        profileCard(context, stateController.loggedInProfile.value,
            stateController.customerInsight.value),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () async {
                    stateController.logout();
                    cartController.fetchCart();
                  },
                  child: Text("Logout", style: TextStyles.headingFont),
                ),
              ),
            ),
          ),
        ),
        PrivacyHelpTermsSection(),
      ],
    );
  }

  profileCard(
      BuildContext context, UserProfile value, CustomerInsight insight) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                                '35b50ba9-3bfe-4688-8b22-1d56f657f3bb',
                                width: MediaQuery.of(context).size.width * .2,
                              ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: FitText(
                            CodeHelp.titleCase(value.fullName ?? ''),
                            style: TextStyles.titleFont
                                .copyWith(color: Colors.black),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 15,
                                  ),
                                  FitText(value.userName!,
                                      style: TextStyles.bodyFontBold),
                                ],
                              ),
                              insight.userFriendlyCustomerId != null
                                  ? Row(
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          size: 15,
                                        ),
                                        FitText(
                                            '#${insight.userFriendlyCustomerId}',
                                            style: TextStyles.bodyFontBold),
                                      ],
                                    )
                                  : SizedBox(),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.call,
                                        size: 15,
                                      ),
                                      FitText(value.mobile!,
                                          style: TextStyles.bodyFontBold),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(
                                        Icons.email,
                                        size: 15,
                                      ),
                                      FitText(value.email!,
                                          style: TextStyles.bodyFontBold),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                Modular.to.pushNamed('../widget/edit-profile');
                              },
                              icon: const Icon(Icons.edit)),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        onPressed: (() {
                          Modular.to.pushNamed('../orders');
                        }),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.grade,
                              color: Colors.blue,
                            ),
                            Text(
                              'Orders',
                              style: TextStyles.headingFont,
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: (() {
                          Modular.to.pushNamed('../wishlist');
                        }),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            Text(
                              'Wishlist',
                              style: TextStyles.headingFont,
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: (() {}),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_activity,
                              color: Colors.amberAccent,
                            ),
                            Text(
                              'Events',
                              style: TextStyles.headingFont,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
