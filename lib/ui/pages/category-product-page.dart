import 'package:amber_bird/controller/category-product-page-controller.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class CategoryProductPage extends StatelessWidget {
  final String id;
  const CategoryProductPage(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryProductPageController(id), tag: id);
    return Obx(() {
      return controller.isLoading.value
          ? const Center(child: LinearProgressIndicator())
          : Scaffold(
              appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                toolbarHeight: 50,
                leadingWidth: 50,
                backgroundColor: AppColors.primeColor,
                leading: IconButton(
                  onPressed: () {
                    try {
                      if (Modular.to.canPop()) {
                        Navigator.pop(context);
                        Modular.to.pop();
                      } else if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Modular.to.navigate('../../home/main');
                      }
                    } catch (err) {
                      Modular.to.navigate('/home/main');
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
                      controller.category.value.logoId ?? '',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      controller.category.value.name!.defaultText!.text!,
                      style: TextStyles.headingFont
                          .copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ),
              body: ListView(
                children: [
                  // categoryInfo(controller.category, context),
                  productList(controller.productList, context)
                ],
              ));
    });
  }

  Widget productList(RxList<ProductSummary> productList, BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: productList.isNotEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height * .9,
                child: MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemCount: productList.length,
                    itemBuilder: (_, index) {
                      return ProductCard(productList[index],
                          productList[index].id, 'CATEGORY', null, null, null);
                    }),
              )
            : SizedBox()
        //        Wrap(
        //   direction: Axis.horizontal,
        //   spacing: 8,
        //   runSpacing: 12,
        //   children: productList
        //       .map(
        //         (product) => SizedBox(
        //           width: MediaQuery.of(context).size.width * .4,
        //           child: Padding(
        //             padding: const EdgeInsets.symmetric(vertical: 8),
        //             child: ProductCard(
        //                 product, product.id, 'CATEGORY', null, null, null),
        //           ),
        //         ),
        //       )
        //       .toList(),
        // ),
        );
  }
}
