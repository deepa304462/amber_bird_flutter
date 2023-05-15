import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wallet-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpointsPage extends StatelessWidget {
  WalletController walletController = Get.put(WalletController());
  final Controller stateController = Get.find();
  PageController controller = PageController();

  final RxInt _curr = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.primeColor,
                  AppColors.primeColor.withOpacity(.8),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Membership',
                    style: TextStyles.headingFont.copyWith(color: Colors.white),
                  ),
                  Text(
                    stateController.getMemberShipText(),
                    style: TextStyles.titleFont.copyWith(color: Colors.white),
                  )
                ],
              ),
            )),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Obx(
            () => PageView(
              scrollDirection: Axis.horizontal,
              controller: controller,
              onPageChanged: (num) {
                _curr.value = num;
              },
              children: <Widget>[
                ...walletController.membershipInfo.map(
                  (element) {
                    return Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ImageBox(
                                      element.imageId!,
                                      width: MediaQuery.of(context).size.width -
                                          48,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '(${element.spointsRangeMin} - ${element.spointsRangeMax})',
                                    style: TextStyles.headingFont
                                        .copyWith(color: AppColors.green),
                                  ),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     SizedBox(
                              //       width: 110,
                              //       child: ImageBox(
                              //         element.imageId!,
                              //         height: 100,
                              //         width: 100,
                              //         // fit: BoxFit.contain,
                              //       ),
                              //     ),
                              //     Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Text(
                              //           element.name!.defaultText != null
                              //               ? (element.name!.defaultText!.text ??
                              //                   '')
                              //               : element
                              //                       .name!.languageTexts![0].text ??
                              //                   '',
                              //           style: TextStyles.headingFont.copyWith(
                              //               color: AppColors.primeColor,
                              //               fontSize: FontSizes.xLarge),
                              //         ),
                              //       ],
                              //     ),
                              //   ],
                              // ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Benefits: ',
                                    style: TextStyles.headingFont,
                                  ),
                                  ...element.benefits!.map(
                                    (benefit) {
                                      return Row(children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.thumb_up_alt_outlined,
                                                  size: 14,
                                                  color: AppColors.primeColor,
                                                ),
                                              ),
                                              TextSpan(text: '  '),
                                              TextSpan(
                                                text: benefit,
                                                style: TextStyles.titleFont
                                                    .copyWith(
                                                        color:
                                                            AppColors.DarkGrey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]);
                                    },
                                  ).toList(),
                                ],
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(Icons.arrow_circle_left,color:AppColors.DarkGrey),
                              onPressed: () {
                                controller.previousPage(
                                    duration: Duration(seconds:2), curve: Curves.easeInBack);
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.arrow_circle_right,color: AppColors.DarkGrey,),
                              onPressed: () {
                                controller.nextPage(
                                    duration: Duration(seconds: 2),
                                    curve: Curves.easeIn,);
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// class Pages extends StatelessWidget {
//   final text;
//   Pages({this.text});
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         text,
//         textAlign: TextAlign.center,
//         style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }
