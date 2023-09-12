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
  // getWallet() async {

  //     coinWallet.value = controller.customerDetail.value.personalInfo.!;

  // }

  final RxInt _curr = 0.obs;

  @override
  Widget build(BuildContext context) {
    // getWallet();
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
          )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                stateController.customerDetail.value.personalInfo?.spoints != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Total S-POINTS',
                            style: TextStyles.headingFont.copyWith(color: Colors.white),
                          ),
                          Text(
                            stateController.customerDetail.value.personalInfo?.spoints.toString() ?? '',
                            style: TextStyles.titleFont.copyWith(color: Colors.white),
                          )
                        ],
                      )
                    : const SizedBox(),
         
              ],
            ),
          ),
        ),
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
          child: Obx(() {
            int indesMember = walletController.membershipInfo.indexWhere((elem) => elem.id == stateController.userType.value);
            controller = PageController(initialPage: indesMember);
            return PageView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: walletController.membershipInfo.length,
                // onPageChanged: (index) {
                //   setState(() {
                //     _currentIndex = index % walletController.membershipInfo.length;
                //   });
                // },
                itemBuilder: (context, index) {
                  var element = walletController.membershipInfo[index];
                  // return PageView(
                  //           scrollDirection: Axis.horizontal,
                  //           controller: controller,
                  //           // reverse: true,
                  //           onPageChanged: (num) {
                  //             _curr.value = num;
                  //           },
                  //           children: <Widget>[
                  //             ...walletController.membershipInfo.map(
                  //               (element) {
                  return Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    decoration: BoxDecoration(),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ImageBox(
                                    element.imageId!,
                                    width: MediaQuery.of(context).size.width - 48,
                                    height: MediaQuery.of(context).size.height * .25,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  element.id == memberShipType.Platinum.name
                                      ? 'Range: Above ${element.spointsRangeMin}'
                                      : 'Range: ${element.spointsRangeMin} - ${element.spointsRangeMax}',
                                  style: TextStyles.headingFont.copyWith(color: AppColors.green),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
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
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 5, top: 5),
                                      child: Row(children: [
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
                                                style: TextStyles.titleFont.copyWith(color: AppColors.DarkGrey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    );
                                  },
                                ).toList(),
                              ],
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(Icons.arrow_circle_left, color: AppColors.DarkGrey),
                            onPressed: () {
                              controller.previousPage(duration: Duration(seconds: 2), curve: Curves.easeInBack);
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_circle_right,
                              color: AppColors.DarkGrey,
                            ),
                            onPressed: () {
                              controller.nextPage(
                                duration: Duration(seconds: 2),
                                curve: Curves.easeIn,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  );
                  //     },
                  //   ),
                  // ],
                });
          }),
        ),
      ],
    );
  }
}
