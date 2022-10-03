import 'dart:developer';

import 'package:amber_bird/controller/category-controller.dart';
import 'package:amber_bird/controller/product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryRow extends StatelessWidget {
  bool isLoading = false;
  // RxList<ProductCategory> cList = RxList([]);
  final CategoryController categoryController = Get.put(CategoryController());
  // final ProductController productController = Get.put(ProductController());
  final Controller myController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: 70,
        child: !isLoading
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: categoryController.categoryList.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            categoryController.selectedCatergory.value =
                                categoryController.categoryList[index].id ?? '';
                            categoryController.getSubCategory(
                                categoryController.categoryList[index].id);

                            categoryController.selectedSubCatergory.value =
                                'all';
                            categoryController.getProductList();
                            myController.setCurrentTab(1);
                          },
                          child: ImageBox(
                            categoryController.categoryList[index].logoId!,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Center(
                          child: Text(categoryController.categoryList[index]
                                  .name!.defaultText!.text ??
                              ''),
                        )
                      ],
                    ),
                  );
                },
              )
            : SizedBox(),
      );
    });
  }
}
