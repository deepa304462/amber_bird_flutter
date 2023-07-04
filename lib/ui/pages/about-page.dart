import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/compiilance-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/compilance/compilance.dart';
import 'package:amber_bird/data/compilance/detailed_content.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../helpers/controller-generator.dart';

class AboutPage extends StatelessWidget {
  final Controller stateController = Get.find();
  final CompilanceController compilanceController = Get.find();
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  RxBool isLoading = false.obs;
  RxString version = ''.obs;

  getVerInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = '${packageInfo.version}-${packageInfo.buildNumber}';
  }

  @override
  Widget build(BuildContext context) {
    getVerInfo();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        leadingWidth: 50,
        backgroundColor: AppColors.primeColor,
        leading: MaterialButton(
          onPressed: () {
            if (Modular.to.canPop()) {
              Navigator.pop(context);
              Modular.to.pop();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Modular.to.navigate('../../home/main');
            }
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
              'About us',
              style: TextStyles.bodyFont.copyWith(color: Colors.white),
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
                height: 200,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/home.png',
                            width: MediaQuery.of(context).size.width * .5,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            '${version.value}',
                            style:
                                TextStyles.body.copyWith(color: AppColors.grey),
                          )
                        ]),
                  ),
                ),
              ),
              Divider(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        ...compilanceController.compilanceList
                            .map((Compilance el) {
                          DetailedContent detailedContent =
                              el.detailedContent!.length > 0
                                  ? el.detailedContent![0]
                                  : {} as DetailedContent;
                          var heading = detailedContent.sectionHeading! !=
                                      null &&
                                  detailedContent.sectionHeading!.defaultText !=
                                      null
                              ? detailedContent
                                  .sectionHeading!.defaultText!.text
                              : detailedContent
                                  .sectionHeading!.languageTexts![0].text;
                          return ListTile(
                            onTap: () {
                              Modular.to
                                  .pushNamed('/widget/compilance/' + el.id!);
                            },
                            title: Text(
                              heading ?? '',
                              style: TextStyles.titleFont,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                          );
                        }).toList(),
                        // ListTile(
                        //   title: Text(
                        //     'Privacy Policy',
                        //     style: TextStyles.titleFont,
                        //   ),
                        //   trailing: const Icon(Icons.chevron_right),
                        // ),
                        // ListTile(
                        //   title: Text(
                        //     'Cookies Settings',
                        //     style: TextStyles.titleFont,
                        //   ),
                        //   trailing: const Icon(Icons.chevron_right),
                        // ),
                        // ListTile(
                        //   title: Text(
                        //     'Accessibility Statement',
                        //     style: TextStyles.titleFont,
                        //   ),
                        //   trailing: const Icon(Icons.chevron_right),
                        // ),
                        // ListTile(
                        //   title: Text(
                        //     'Brand Endorsement Policy',
                        //     style: TextStyles.titleFont,
                        //   ),
                        //   trailing: const Icon(Icons.chevron_right),
                        // ),
                        // ListTile(
                        //   title: Text(
                        //     'DCMA',
                        //     style: TextStyles.titleFont,
                        //   ),
                        //   trailing: const Icon(Icons.chevron_right),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Coyright 2023-2030 Sbazar',
                            style:
                                TextStyles.body.copyWith(color: AppColors.grey),
                          ),
                          Text(
                            'All rights reseved',
                            style:
                                TextStyles.body.copyWith(color: AppColors.grey),
                          )
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //     child: Obx(() => Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [Text('Version: ${version.value}')]))),
    );
  }
}
