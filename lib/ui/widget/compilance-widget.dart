import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/compiilance-controller.dart';
import 'package:amber_bird/data/complaince/complaince.dart';
import 'package:amber_bird/data/complaince/content.dart';
import 'package:amber_bird/data/complaince/detailed_content.dart';
import 'package:amber_bird/data/deal_product/description.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class CompilanceWidget extends StatelessWidget {
  final AuthController authController = Get.find();
  RxBool isLoading = false.obs;
  final CompilanceController compilanceController = Get.find();
  String id;
  CompilanceWidget(this.id);

  @override
  Widget build(BuildContext context) {
    List<Complaince> result = compilanceController.compilanceList.where((el) {
      return el.id! == id;
    }).toList();
    print(result);
    DetailedContent detailedContent = result[0].detailedContent!.length > 0
        ? result[0].detailedContent![0]
        : {} as DetailedContent;
    var heading = detailedContent.sectionHeading != null &&
            detailedContent.sectionHeading!.defaultText != null
        ? detailedContent.sectionHeading!.defaultText!.text
        : (detailedContent.sectionHeading != null
            ? detailedContent.sectionHeading!.languageTexts![0].text
            : '');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        leadingWidth: 50,
        backgroundColor: AppColors.primeColor,
        title: Text(
          heading ?? '',
          style: TextStyles.bodyFont.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Modular.to.navigate('/home/main');
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 15,
          ),
        ),
      ),
      body: Container(
        color: AppColors.commonBgColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: result[0].detailedContent!.length,
                itemBuilder: (_, index) {
                  DetailedContent currentDetaildContent =
                      result[0].detailedContent![index];
                  var sectionHeading = currentDetaildContent.sectionHeading !=
                              null &&
                          currentDetaildContent.sectionHeading!.defaultText !=
                              null
                      ? currentDetaildContent.sectionHeading!.defaultText!.text
                      : ((currentDetaildContent.sectionHeading != null &&
                              currentDetaildContent
                                      .sectionHeading!.languageTexts!.length >
                                  0)
                          ? currentDetaildContent
                              .sectionHeading!.languageTexts![0].text
                          : '');
                  List<Content> contentList =
                      currentDetaildContent.content ?? [];
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sectionHeading ?? '',
                          style: TextStyles.headingFont,
                        ),
                        ...contentList.map((e) {
                          var subHeading = e.subHeading != null &&
                                  e.subHeading!.defaultText != null
                              ? e.subHeading!.defaultText!.text
                              : ((e.subHeading != null &&
                                      e.subHeading!.languageTexts!.length > 0)
                                  ? e.subHeading!.languageTexts![0].text
                                  : '');
                          List<Description> subContentList = e!.content ?? [];
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subHeading ?? '',
                                  style: TextStyles.titleFont,
                                ),
                                ...subContentList.map((subContent) {
                                  var currentSubContent = subContent != null &&
                                          subContent.defaultText != null
                                      ? subContent.defaultText!.text
                                      : subContent.languageTexts![0].text;
                                  return Html(
                                      data: currentSubContent ?? '',
                                      style: {
                                        "body": Style(
                                            fontSize: FontSize(FontSizes.body),
                                            fontWeight: FontWeight.w300,
                                            fontFamily: Fonts.body),
                                      });
                                }).toList()
                              ]);
                        }).toList()
                      ]);
                })),
      ),
    );
  }
}
