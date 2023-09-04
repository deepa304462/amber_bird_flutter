import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../../controller/faq-controller.dart';
import '../../data/faq/faq-model.dart';

class FAQWidget extends StatelessWidget {
  final String id;
  FAQWidget(this.id);

  final AuthController authController = Get.find();

  RxBool isLoading = false.obs;

  final FaqController faqController = Get.find();

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
      body: SingleChildScrollView(
        //    padding: EdgeInsets.all(2),
        child: Column(
          children: [
            ExpansionPanelList.radio(
              elevation: 4,
              //  expandedHeaderPadding: EdgeInsets.only(bottom: 100),
              children: result[0]
                  .questions!
                  .map<ExpansionPanelRadio>((QuestionElement questionElement) {
                return ExpansionPanelRadio(
                    backgroundColor: Colors.grey[100],
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) =>
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                          child: Text("${questionElement.question?.text}",
                              textAlign: TextAlign.start,
                              style: TextStyles.titleFont),
                        ),
                    body: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 5, 20),
                      child: Text("${questionElement.answer?.text}",
                          style: TextStyles.body),
                    ),
                    value: questionElement.question ?? "");
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
