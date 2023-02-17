import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/customer_insight/customer_insight.dart';
import 'package:amber_bird/data/user_profile/user_profile.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final Controller stateController = Get.find();
  final CartController cartController = Get.find();
  RxBool isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          profileCard(context, stateController.loggedInProfile.value,
              stateController.customerInsight.value),
          SingleChildScrollView(
            child: Column(children: [
              sectionCard('Address', 'Get list if saved address', () {
                Modular.to.navigate('../home/address-list');
                return {};
              }),
              sectionCard(
                  'FAQ', 'Get answer for your specific query', () => {}),
              sectionCard(
                  'Help', 'Get help from our customer care team', () => {}),
              sectionCard(
                  'Privacy policy', 'Explains legals and policies', () => {}),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Card(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () async {
                          isLoading.value = true;
                          // Modular.to.navigate('../home/reset-password');
                          var data = await stateController.resetPassInit();
                          isLoading.value = false;
                          snackBarClass.showToast(
                              context, 'Please check your mail !,thanks');
                        },
                        child: Text(
                            isLoading.value ? "Loading" : "Reset Password",
                            style: TextStyles.headingFont),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
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
        ],
      ),
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
          children: [
            ImageBox(
              'aa556b20-a25a-410d-8204-a419227932aa',
              width: MediaQuery.of(context).size.width,
              height: 170,
              fit: BoxFit.cover,
            ),
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
                            style: TextStyles.titleXLargeWhite
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
                                Modular.to.navigate('../home/edit-profile');
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
                          Modular.to.navigate('../home/orders');
                        }),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.grade,
                              color: Colors.blue,
                            ),
                            Text(
                              'Orders',
                              style: TextStyles.titleLargeBold,
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: (() {
                          Modular.to.navigate('../home/wishlist');
                        }),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            Text(
                              'Wishlist',
                              style: TextStyles.titleLargeBold,
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
                              style: TextStyles.titleLargeBold,
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

  Widget sectionCard(String title, String subtitle, Map Function() onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: ListTile(
            title: Text(
              title,
              style: TextStyles.titleLargeBold,
            ),
            subtitle: Text(
              subtitle,
              style: TextStyles.bodyFont,
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}
