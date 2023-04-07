import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wallet-controller.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SpointsPage extends StatelessWidget {
  WalletController walletController = Get.put(WalletController());
  final Controller stateController = Get.find();
  PageController controller = PageController();

  final RxInt _curr = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Obx(
          () => PageView(
            scrollDirection: Axis.horizontal,
            controller: controller,
            onPageChanged: (num) {
              _curr.value = num;
            },
            children: <Widget>[
              ...walletController.membershipInfo.value.map((element) {
                return Container(
                  color: AppColors.golden,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            element.name!.defaultText != null
                                ? (element.name!.defaultText!.text ?? '')
                                : element.name!.languageTexts![0].text ?? '',
                            style: TextStyles.headingFont.copyWith(
                                color: AppColors.white,
                                fontSize: FontSizes.xLarge),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Range : ${element.spointsRangeMin} - ${element.spointsRangeMax}',
                            style: TextStyles.headingFont
                                .copyWith(color: AppColors.green),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Benefits',
                        style: TextStyles.headingFont
                            .copyWith(color: AppColors.white),
                      ),
                      Row(
                        children: [
                          ...element.benefits!.map((benefit) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: AppColors.primeColor),
                                color: AppColors.primeColor,
                              ),
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.fromLTRB(20, 3, 3, 3),
                              child: Text(
                                benefit,
                                style: TextStyles.headingFont.copyWith(
                                    color: AppColors.darkOrange,
                                    fontSize: FontSizes.large),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              // Center(
              //     child: Pages(
              //   text: "Page 1",
              // )),
              // // Center(
              //     child: Pages(
              //   text: "Page 2",
              // )),
              // Center(
              //     child: Pages(
              //   text: "Page 3",
              // )),
              // Center(
              //     child: Pages(
              //   text: "Page 4",
              // ))
            ],
          ),
        ),
      )
    ]);
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
