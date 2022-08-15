import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 0);
  // final Controller myController = Get.put(Controller(), tag: 'mycontroller');
  final Controller myController = Get.find();
  final ProductSummary? product;

  ProductDetailScreen(this.product, {Key? key}) : super(key: key);

  Widget productPageView(double width, double height) {
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
              onPageChanged: myController.switchBetweenProductImages,
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

  // Widget _ratingBar(BuildContext context) {
  //   return Row(
  //     children: [
  //       RatingBar.builder(
  //           initialRating: product.rating,
  //           direction: Axis.horizontal,
  //           itemBuilder: (_, index) {
  //             return const Icon(Icons.star, color: Colors.amber);
  //           },
  //           onRatingUpdate: (rating) {}),
  //       const SizedBox(width: 30),
  //       Text(
  //         "(4500 Reviews)",
  //         style: Theme.of(context)
  //             .textTheme
  //             .headline3
  //             ?.copyWith(fontWeight: FontWeight.w300),
  //       )
  //     ],
  //   );
  // }

  // // Widget productVarientListView() {
  //   return ListView.builder(
  //     scrollDirection: Axis.horizontal,
  //     itemCount: myController.sizeType(product).length,
  //     itemBuilder: (_, index) {
  //       return InkWell(
  //         onTap: () {
  //           // myController.switchBetweenProductSizes(product, index);
  //         },
  //         child: Container(
  //           margin: const EdgeInsets.only(right: 5, left: 5),
  //           alignment: Alignment.center,
  //           width: myController.isNominal(product) ? 40 : 70,
  //           decoration: BoxDecoration(
  //               color: myController.sizeType(product)[index].isSelected == false
  //                   ? Colors.white
  //                   : AppColor.lightOrange,
  //               borderRadius: BorderRadius.circular(10),
  //               border: Border.all(color: Colors.grey, width: 0.4)),
  //           child: FittedBox(
  //             child: Text(
  //               //Map<String,bool>
  //               myController.sizeType(product)[index].numerical,
  //               style:
  //                   const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          productPageView(width, height),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product!.name!.defaultText!.text ?? '',
                  // style: Theme.of(context).textTheme.headline2,
                ),
                // const SizedBox(height: 10),
                // _ratingBar(context),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(product!.varient!.price!.offerPrice != null
                        ? "\$${product!.varient!.price!.actualPrice}"
                        : "\$${product!.varient!.price!.offerPrice}"),
                    const SizedBox(width: 3),
                    Visibility(
                      visible: product!.varient!.price!.offerPrice != null
                          ? true
                          : false,
                      child: Text(
                        "\$${product!.varient!.price!.offerPrice}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      product!.varient!.currentStock > 0
                          ? "Available in stock"
                          : "Not available",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  "About",
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 10),
                Text(product!.description!.defaultText!.text ?? ''),
                const SizedBox(height: 20),
                // SizedBox(
                //   height: 40,
                //   child: GetBuilder<Controller>(
                //     builder: (Controller controller) {
                //       return productSizesListView();
                //     },
                //   ),
                // ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text("Add to cart"),
                    onPressed: product!.varient!.currentStock > 0
                        ? () => myController.addToCart(product)
                        : null,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
