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
        )),
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

            // reverse: true,
            // physics: BouncingScrollPhysics(),
            controller: controller,
            onPageChanged: (num) {
              _curr.value = num;
            },
            children: <Widget>[
              ...walletController.membershipInfo.value.map((element) {
                return Center(
                    child: Pages(
                  text: "Page ${element.id}",
                ));
              }),
              Center(
                  child: Pages(
                text: "Page 1",
              )),
              // Center(
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

class Pages extends StatelessWidget {
  final text;
  Pages({this.text});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}
