import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/compiilance-controller.dart';
import 'package:amber_bird/data/complaince/complaince.dart';
import 'package:amber_bird/data/complaince/content.dart';
import 'package:amber_bird/data/complaince/detailed_content.dart';
import 'package:amber_bird/data/deal_product/description.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_faq/flutter_faq.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../../controller/faq-controller.dart';
import '../../data/faq/faq-model.dart';

class FAQWidget extends StatelessWidget {
  final AuthController authController = Get.find();
  RxBool isLoading = false.obs;
  final FaqController faqController = Get.find();
  String id;
  FAQWidget(this.id);

  @override
  Widget build(BuildContext context) {
    List<Faq> result = faqController.faqList.where((el) {
      return el.id! == id;
    }).toList();
    print(result);
    Faq detailedContent =
        result[0].questions!.length > 0 ? result[0] : {} as Faq;
    // var heading = detailedContent.sectionHeading != null &&
    //         detailedContent.sectionHeading!.defaultText != null
    //     ? detailedContent.sectionHeading!.defaultText!.text
    //     : (detailedContent.sectionHeading != null
    //         ? detailedContent.sectionHeading!.languageTexts![0].text
    //         : '');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        leadingWidth: 50,
        backgroundColor: AppColors.primeColor,
        title: Text(
          detailedContent.topic ?? '',
          style: TextStyles.bodyFont.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            if (Modular.to.canPop()) {
              Navigator.pop(context);
              Modular.to.pop();
            } else if (Navigator.canPop(context)) {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detailedContent.topic ?? '',
              style: TextStyles.headingFont,
            ),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  // scrollDirection: Axis.vertical,
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: result[0].questions!.length,
                  itemBuilder: (_, index) {
                    return FAQ(
                        isExpanded: false,
                        showDivider: false,
                        queStyle: TextStyles.titleFont,
                        //  TextStyle(
                        //     fontFamily: result[0]
                        //         .questions?[index]
                        //         .question
                        //         ?.font
                        //         ?.family,
                        //     fontSize: result[0]
                        //         .questions?[index]
                        //         .question
                        //         ?.font
                        //         ?.size,
                        //     color: result[0]
                        //         .questions?[index].question?.font?.color),
                        question:
                            result[0].questions?[index].question?.text ?? "",
                        answer: result[0].questions?[index].answer?.text ?? "",
                        ansStyle: TextStyles.bodyFont

                        // TextStyle(
                        //     fontFamily: result[0]
                        //         .questions?[index]
                        //         .answer
                        //         ?.font
                        //         ?.family,
                        //     fontSize: result[0]
                        //         .questions?[index]
                        //         .answer
                        //         ?.font
                        //         ?.size,
                        //     color: result[0]
                        //         .questions?[index]
                        //         .answer
                        //         ?.font
                        //         ?.color),

                        );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
