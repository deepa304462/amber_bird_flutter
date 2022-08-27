import 'dart:developer';

import 'package:amber_bird/controller/category-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPage extends StatelessWidget {
  bool isLoading = false;

  final CategoryController categoryController = Get.find();

  @override
  Widget build(BuildContext context) {
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
                              categoryController.selectedCatergory.value =
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
                          Obx(() => Center(
                                child: Text(
                                  categoryController.categoryList[index].name!
                                          .defaultText!.text ??
                                      '',
                                  style: (categoryController
                                              .selectedCatergory.value.id ==
                                          categoryController
                                              .categoryList[index].id)
                                      ? TextStyles.bodyGreen
                                      : TextStyles.bodySm,
                                ),
                              ))
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
                              mController.selectedSubCatergory.value =
                                  mController.subCategoryList[index];
                            },
                            child: Obx(
                              () => Text(
                                  mController.subCategoryList[index].name!
                                          .defaultText!.text ??
                                      '',
                                  style: (mController
                                              .selectedSubCatergory.value.id ==
                                          mController.subCategoryList[index].id)
                                      ? TextStyles.titleGreen
                                      : TextStyles.title),
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () { 
                              mController.selectedSubCatergory.value =
                                  mController.subCategoryList[index]; 
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
  }
}
