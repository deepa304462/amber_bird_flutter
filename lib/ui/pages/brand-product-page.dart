import 'package:amber_bird/controller/appbar-scroll-controller.dart';
import 'package:amber_bird/controller/brand-page-controller.dart';
import 'package:amber_bird/controller/brand-product-page-controller.dart';
import 'package:amber_bird/data/brand/brand.dart';
import 'package:amber_bird/data/category/category.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/loading-with-logo.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class BrandProductPage extends StatelessWidget {
  final String id;
  late BrandProductPageController controller;
  final AppbarScrollController appbarScrollController = Get.find();
  BrandProductPage(this.id, {Key? key}) : super(key: key) {
    controller = ControllerGenerator.create(BrandProductPageController(),
        tag: 'brandProductController');
    controller.setBrandId(id);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const LoadingWithLogo()
          : Scaffold(
              appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                toolbarHeight: 50,
                leadingWidth: 50,
                backgroundColor: AppColors.primeColor, 
                leading: IconButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      appbarScrollController.navigateToPop(context);
                    } else {
                      appbarScrollController.navigateTo('../../home/main');
                      // Modular.to.pushNamed('/home/main');
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                title: Row(
                  children: [
                    ImageBox(
                      '${controller.brand.value.logoId}',
                      width: 40,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${controller.brand.value.name}',
                      style: TextStyles.bodyFont.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(4, 5, 4, 8),
                      child: categoryList(controller, context)),
                  productList(context),
                ],
              ),
            ),
    );
  }

  Widget categoryList(BrandProductPageController controller, context) {
    return SizedBox(
      height: 75,
      // width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.categoryList.length,
        itemBuilder: (_, index) {
          Category currentCat = controller.categoryList[index];
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    //  controller.categoryList
                    controller.selectedCategory.value = currentCat.id!;
                    controller.searchProducts();
                  },
                  child: ImageBox(
                    controller.categoryList[index].logoId!,
                    width: 50,
                    height: 50,
                  ),
                ),
                Center(
                  child: Text(
                    (controller.categoryList[index].name!.defaultText!.text ??
                                    '')
                                .length >
                            7
                        ? '${(controller.categoryList[index].name!.defaultText!.text ?? '').substring(0, 6)}...'
                        : controller
                                .categoryList[index].name!.defaultText!.text ??
                            '',
                    style: currentCat.id == controller.selectedCategory.value
                        ? TextStyles.body.copyWith(fontWeight: FontWeight.bold)
                        : TextStyles.body,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget brandInfo(Rx<Brand> brand, BuildContext context) {
    return Card(
      child: ListTile(
        leading: ImageBox(
          brand.value.logoId!,
          width: 100,
          height: 100,
        ),
        title: Text(
          brand.value.name!,
          style: TextStyles.headingFont,
        ),
        subtitle: Text(
          brand.value.description!.defaultText!.text!,
          style: TextStyles.bodyFontBold,
        ),
      ),
    );
  }

  productList(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.78,
      // width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          // Container(
          //   color: AppColors.off_red,
          //   padding: const EdgeInsets.all(3),
          //   child: Stack(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
          //         child: Card(
          //           clipBehavior: Clip.hardEdge,
          //           child: Stack(
          //             children: [
          //               Lottie.asset('assets/profile-cover-background.json',
          //                   width: MediaQuery.of(context).size.width,
          //                   height: 100,
          //                   fit: BoxFit.cover),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: ImageBox(
          //                       '${controller.brand.value.logoId}',
          //                       width: 100,
          //                       fit: BoxFit.contain,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       const RibbonWidget(
          //         text: 'Exclusive',
          //       )
          //     ],
          //   ),
          // ),
          Expanded(
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              padding: const EdgeInsets.all(4),
              physics: const BouncingScrollPhysics(),
              itemCount: controller.productList.length,
              itemBuilder: (_, index) {
                var product = controller.productList[index];
                return ProductCard(product, product.id, 'BRAND',
                    product.varient!.price!, null, null);
              },
            ),
          ),
        ],
      ),
    );
  }
}
