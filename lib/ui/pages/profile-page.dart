import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/user_profile/user_profile.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final Controller stateController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListView(physics: const BouncingScrollPhysics(), children: [
      profileCard(context, stateController.loggedInProfile.value),
      sectionCard('FAQ', 'Get answer for your specific query', () => {}),
      sectionCard('Help', 'Get help from our customer care team', () => {}),
      sectionCard('Privacy policy', 'Explains legals and policies', () => {}),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              onPressed: () async {
                stateController.logout();
              },
              child: Text("Logout", style: TextStyles.headingFont),
            ),
          ),
        ),
      ),
    ]);
  }

  profileCard(BuildContext context, UserProfile value) {
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
                        child: ImageBox(
                          '35b50ba9-3bfe-4688-8b22-1d56f657f3bb',
                          width: MediaQuery.of(context).size.width * .2,
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            CodeHelp.titleCase(value!.fullName!),
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
                                  Text(value.userName!,
                                      style: TextStyles.bodyFontBold),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.call,
                                        size: 15,
                                      ),
                                      Text(value.mobile!,
                                          style: TextStyles.bodyFontBold),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.email,
                                        size: 15,
                                      ),
                                      Text(value.email!,
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
                              icon: Icon(Icons.edit)),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        onPressed: (() {}),
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
                        onPressed: (() {}),
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
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}
