import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/compiilance-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/compilance/compilance.dart';
import 'package:amber_bird/data/compilance/detailed_content.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../../helpers/controller-generator.dart';

class AboutPage extends StatelessWidget {
  final Controller stateController = Get.find();
  final CompilanceController compilanceController = Get.find();
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
            if (Modular.to.canPop()) {
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
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            trailing: IconButton(
                                onPressed: () {
                                  //  CompilanceWidget(heading ??'', content: el);
                                  // Modular.to.pushNamed('/widget/compilance/'+el.id! );
                                },
                                icon: const Icon(Icons.chevron_right)),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
