import 'dart:developer';

import 'package:amber_bird/controller/category-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class CategoryRow extends StatelessWidget {
  bool isLoading = false;
  // RxList<ProductCategory> cList = RxList([]);
  final CategoryController categoryController = Get.put(CategoryController());
  final Controller myController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Categories",
                  style: TextStyles.headingFont,
                ),
                TextButton(
                  onPressed: () {
                    myController.setCurrentTab(1);
                    // Modular.to.navigate('/home/category');
                  },
                  child: Text(
                    "SEE ALL",
                    style: TextStyles.subHeadingFont,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: !isLoading
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
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

                                categoryController.selectedSubCatergory.value = 'all';
                                categoryController.getProductList();
                                 myController.setCurrentTab(1);
                              },
                              child: Image.network(
                                  '${ClientService.cdnUrl}${categoryController.categoryList[index].logoId}',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.fill),
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
          )
        ],
      );
    });
  }
}
