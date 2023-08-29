import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_faq/flutter_faq.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../controller/faq-controller.dart';
import '../../data/faq/faq-model.dart';
import '../../helpers/controller-generator.dart';

class HelpCenterPage extends StatelessWidget {
  final FaqController faqController = Get.find();
  final Controller stateController = Get.find();
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  RxBool isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    List<Faq> result = faqController.faqList;

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
              'Help Center',
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
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Contact Us', style: TextStyles.headingFont),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Modular.to.pushNamed(
                                              '/widget/compilance',
                                              arguments: 'RETURN_REFUND');
                                        },
                                        child: ImageBox(
                                          '316204af-0bc0-486d-81fb-55dd28e4674c',
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                      Center(
                                        child: Text('Re(turn)fund',
                                            style: TextStyles.body),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Modular.to.pushNamed(
                                              '/widget/compilance',
                                              arguments: 'USER_CARE');
                                        },
                                        child: ImageBox(
                                          '2229ac1f-3b17-4477-8970-d4441f5e6447',
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                      Center(
                                        child: FitText('User Care',
                                            style: TextStyles.body),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Modular.to.pushNamed(
                                              '/widget/compilance',
                                              arguments: 'PARTNERSHIP');
                                        },
                                        child: ImageBox(
                                          '82b731de-b1f2-49a2-ad4e-eb5ed0ccb0a3',
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                      Center(
                                        child: FitText('Partners',
                                            style: TextStyles.body),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Modular.to.pushNamed(
                                              '/widget/compilance',
                                              arguments: 'HIRING');
                                        },
                                        child: ImageBox(
                                          'a739ca3d-d626-4f84-9fa1-a4f92b53f970',
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                      Center(
                                        child: FitText("Hiring",
                                            style: TextStyles.body),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
                        Text('Need Immeddiate Assistance?',
                            style: TextStyles.headingFont),
                        GestureDetector(
                          onTap: (){
                            launch('mailto:hello@sbazar.app');
                          },
                          child: ListTile(
                            horizontalTitleGap:0.0,
                            leading: Icon(Icons.mail),
                            title: Text(
                              'hello@sbazar.app',
                              style: TextStyles.titleFont,
                            ),
                            // trailing: const Icon(Icons.chevron_right),
                          ),
                        ),
                        InkWell(
                          onTap: () async{
                            const url = 'https://api.whatsapp.com/message/7CXH5SMN32HXN1?autoload=1&app_absent=0';
                            if (await canLaunch(url)) {
                            await launch(url, forceWebView: true);
                            } else {
                            throw 'Could not launch $url';
                            }
                          },
                          child: ListTile(
                            horizontalTitleGap:0.0,
                            leading: Image.asset("assets/whatsapp.png",height: 20,width: 20,),
                            title: Text(
                              'Sbazar',
                              style: TextStyles.linkFont,
                            ),
                            // trailing: const Icon(Icons.chevron_right),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: SizedBox(
                           width: MediaQuery.of(context).size.width,
                          //       height: MediaQuery.of(context).size.height * .2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('FAQ', style: TextStyles.headingFont),
                              ListView.builder(
                                  // scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  itemCount: result[0].questions?.length,
                                  itemBuilder: (_, index) {
                                    return FAQ(
                                      queStyle: TextStyle(
                                          fontFamily: result[0]
                                              .questions?[index]
                                              .question
                                              ?.font
                                              ?.family,
                                          fontSize: result[0]
                                              .questions?[index]
                                              .question
                                              ?.font
                                              ?.size,
                                          color: result[0]
                                              .questions?[index]
                                              .question
                                              ?.font
                                              ?.color),
                                      question: result[0]
                                              .questions?[index]
                                              .question
                                              ?.text ??
                                          "",
                                      answer: result[0]
                                              .questions?[index]
                                              .answer
                                              ?.text ??
                                          "",
                                      ansStyle: TextStyle(
                                          fontFamily: result[0]
                                              .questions?[index]
                                              .answer
                                              ?.font
                                              ?.family,
                                          fontSize: result[0]
                                              .questions?[index]
                                              .answer
                                              ?.font
                                              ?.size,
                                          color: result[0]
                                              .questions?[index]
                                              .answer
                                              ?.font
                                              ?.color),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
