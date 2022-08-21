import 'dart:developer';

import 'package:amber_bird/controller/category-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

// class CategoryPage extends StatefulWidget {
//   CategoryPage({Key? key}) : super(key: key);

//   @override
//   State<CategoryPage> createState() => _CategoryPageState();
// }

// class _CategoryPageState extends State<CategoryPage> {
class CategoryPage extends StatelessWidget {
  bool isLoading = false;
  ProductCategory selectedCatergory = new ProductCategory();
  ProductCategory selectedSubCatergory = new ProductCategory();
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Categories",
                  style: TextStyles.headingFont,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: categoryController.categoryList.isNotEmpty
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
                                print(
                                    "Container clicked ${index}${categoryController.categoryList[index]}");
                                selectedCatergory =
                                    categoryController.categoryList[index];
                                categoryController.getSubCategory(
                                    categoryController.categoryList[index].id);
                              },
                              child: Image.network(
                                  '${ClientService.cdnUrl}${categoryController.categoryList[index].logoId}',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.fill),
                            ),
                            Center(
                              child: Text(
                                categoryController.categoryList[index].name!
                                        .defaultText!.text ??
                                    '',
                                style: (selectedCatergory.id ==
                                        categoryController
                                            .categoryList[index].id)
                                    ? TextStyles.bodyGreen
                                    : TextStyles.bodySm,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  )
                : const SizedBox(),
          ),
          GetX<CategoryController>(
            builder: (mController) {
              if (mController.subCategoryList.isNotEmpty) {
                print(mController.subCategoryList.isNotEmpty);
                return SizedBox(
                  height: 58,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: mController.subCategoryList.length,
                    itemBuilder: (_, index) {
                      return Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.lightGrey),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                selectedSubCatergory =
                                    mController.subCategoryList[index];
                              },
                              child: Text(
                                  mController.subCategoryList[index].name!
                                          .defaultText!.text ??
                                      '',
                                  style: (selectedSubCatergory.id ==
                                          mController.subCategoryList[index].id)
                                      ? TextStyles.titleGreen
                                      : TextStyles.title),
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                print(
                                    "Container clicked ${index}${mController.subCategoryList[index]}");
                                selectedSubCatergory =
                                    mController.subCategoryList[index];
                                // setState(() {
                                //   isLoading = false;
                                // });
                                // getSubCategory(cList[index].id);
                              },
                              child: Image.network(
                                  '${ClientService.cdnUrl}${mController.subCategoryList[index].logoId}',
                                  width: 25,
                                  height: 25,
                                  fit: BoxFit.fill),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      );
    });
  }
}
