import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponWidget extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find();
    // final Controller stateController = Get.find();
    controller.text = cartController.couponName.toString();
    return Obx(() {
      controller.text = cartController.couponName.toString();
      return FractionallySizedBox(
        widthFactor: 1,
        child: TextField(
          controller: controller,
          readOnly: true,
          onTap: () {
            showSearch(context: context, delegate: CustomSearchDelegate());
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                print(controller.value.text);
              },
              icon: const Icon(Icons.search),
            ),
            labelText: "Apply coupon codes",
            contentPadding: const EdgeInsets.all(10.0),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      );
    });
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final CartController cartController = Get.find();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // List<String> matchQuery = [];
    print(query);
    cartController.getsearchData(query);
    return Obx(
      () => ListView.builder(
        itemCount: cartController.searchCouponList.value.length,
        itemBuilder: (context, index) {
          var coupon = cartController.searchCouponList.value[index];
          return ListTile(
            onTap: () {
              close(context, null);
            },
            title: Row(
              children: [
                Text(coupon.couponCode ?? ''),
                Text(coupon.reward!.discountPercent!.toString()),
              ],
            ),
            subtitle: Column(
              children: [
                (coupon.description != null &&
                        coupon.description!.defaultText != null)
                    ? Text(coupon.description!.defaultText!.text!)
                    : const SizedBox(),
                coupon.reward!.discountPercent != null
                    ? Row(
                        children: [
                          const Text('Discount Percent'),
                          Text(coupon.reward!.discountPercent!.toString()),
                        ],
                      )
                    : const SizedBox(),
                coupon.reward!.discountUptos != null
                    ? Row(
                        children: [
                          const Text('Discount Upto'),
                          Text(coupon.reward!.discountUptos!.toString()),
                        ],
                      )
                    : const SizedBox(),
                coupon.reward!.flatDiscount != null
                    ? Row(
                        children: [
                          const Text('Flat Discount'),
                          Text(coupon.reward!.flatDiscount!.toString()),
                        ],
                      )
                    : const SizedBox(),
                ElevatedButton(
                    onPressed: () async {
                      var data =
                          await cartController.isApplicableCoupun(coupon);
                      if (data) {
                        snackBarClass.showToast(context, 'coupon is valid ');
                        cartController.selectedCoupon.value = coupon;
                        cartController.calculateTotalCost();
                        // controller.text = cartController.couponName.toString();
                        cartController.setSearchVal(coupon.couponCode);
                        close(context, cartController.couponName.toString());
                      } else {
                        snackBarClass.showToast(
                            context, 'coupon is not valid ');
                      }
                    },
                    child: const Text('Apply'))
              ],
            ),
          );
        },
      ),
    );
  }
}
