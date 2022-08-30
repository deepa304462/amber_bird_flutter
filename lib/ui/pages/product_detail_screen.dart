import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/data/product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 0);
  // final Controller myController = Get.put(Controller(), tag: 'mycontroller');
  final CartController cartController = Get.find();
  final Controller stateController = Get.find();

  final String? pId;
  // final Price? dealPrice;
  final String? refId;
  final String? addedFrom;

  ProductDetailScreen(this.pId, this.refId, this.addedFrom, {Key? key});

  Widget productPageView(Product product, double width, double height) {
    return Container(
      height: height * 0.42,
      width: width,
      decoration: const BoxDecoration(
        color: Color(0xFFE5E6E8),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(200),
          bottomLeft: Radius.circular(200),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: height * 0.32,
            child: PageView.builder(
              itemCount: product!.images!.length,
              controller: _pageController,
              // onPageChanged: myController.switchBetweenProductImages,
              itemBuilder: (_, index) {
                return Image.network(
                    '${ClientService.cdnUrl}${product!.images![index]}',
                    // width: 80,
                    // height: 80,
                    fit: BoxFit.contain
                    // scale: 3,

                    );
              },
            ),
          ),
          // Obx(
          //   () => SmoothIndicator(
          //       effect: const WormEffect(
          //           dotColor: Colors.white,
          //           activeDotColor: AppColor.darkOrange),
          //       offset: myController.productImageDefaultIndex.value.toDouble(),
          //       count: product.images.length),
          // )
        ],
      ),
    );
  }

  Widget productVarientView(List<Varient> varientList , activeVariant) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: varientList.length,
          shrinkWrap: true,
          itemBuilder: (_, index) {
            var currentVarient = varientList[index];
            return SizedBox(
              height: 50,
              child: Card(
                color: activeVariant == index ? Colors.grey: Colors.white,
                margin: const EdgeInsets.all(5),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                        '${currentVarient!.weight!} ${currentVarient!.unit!}'),
                  ),
                ),
              ),
            );
          }),
    );
    // return Row(
    //   children: [
    //     Text('${product!.varient!.weight!} ${product!.varient!.unit!}'),
    //   ],
    // );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    print('aaaaaaaaaaaaaaaaaaaaaaaaaa$pId');
    final ProductController productController =
        Get.put(ProductController(pId ?? ''), tag: pId ?? "");
    return Obx(() => productController.product.value.id != null
        ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                productPageView(productController.product.value, width, height),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productController
                                .product.value!.name!.defaultText!.text ??
                            '',
                        style: TextStyles.detailProductName,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                              "\$${productController.product.value!.varients![0].price!.offerPrice}"),
                          const SizedBox(width: 3),
                          Visibility(
                            visible: productController.product.value!
                                        .varients![0].price!.offerPrice !=
                                    null
                                ? true
                                : false,
                            child: Text(
                              "\$${productController.product.value!.varients![0].price!.actualPrice}",
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            productController.product.value!.varients![0]!
                                        .currentStock >
                                    0
                                ? "Available in stock"
                                : "Not available",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      productVarientView(
                          productController.product.value.varients ?? [] ,
                          productController.activeIndexVariant.value),
                      const SizedBox(height: 30),
                      Text(
                        "About",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      const SizedBox(height: 10),
                      Text(productController
                              .product.value!.description!.defaultText!.text ??
                          ''),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primeColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              textStyle: TextStyles.bodyWhite),
                          onPressed: productController.product.value!
                                      .varients![0]!.currentStock >
                                  0
                              ? () {
                                  // if (stateController.isLogin.value) {
                                  //   cartController.addToCart(
                                  //       product, refId!, addedFrom!, 1);
                                  // } else {
                                  //   stateController.setCurrentTab(3);
                                  //   var showToast = snackBarClass.showToast(
                                  //       context, 'Please Login to preoceed');
                                  // }
                                }
                              : () {
                                  // if (stateController.isLogin.value) {
                                  //   cartController.addToCart(
                                  //       product, refId!, addedFrom!, 1);
                                  // } else {
                                  //   stateController.setCurrentTab(3);
                                  //   var showToast = snackBarClass.showToast(
                                  //       context, 'Please Login to preoceed');
                                  // }
                                },
                          child: Text("Add to cart",
                              style: TextStyles.addTocartText),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        : const Center(
            child: Text("Loading"),
          ));
  }
}
