import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import '../widget/cart/cart-widget.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  final Controller stateController = Get.find();
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
              // Navigator.pop(context);
              stateController.navigateToUrl('/home/main');
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
                'My Cart',
                style: TextStyles.headingFont.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        body: CartWidget());
    //  SizedBox(
    //   height: MediaQuery.of(context).size.height * .7,
    //   child: SingleChildScrollView(
    //     child:

    //     Column(children: [CartWidget(), SaveLater()]),
    //   ),
    // );
  }
}
