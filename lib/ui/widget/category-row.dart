import 'package:amber_bird/controller/category-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryRow extends StatelessWidget {
  bool isLoading = false;
  final CategoryController categoryController = Get.put(CategoryController());
  final Controller myController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: 75,
        child: !isLoading
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: categoryController.mainTabs.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            categoryController.selectedCatergory.value =
                                categoryController.mainTabs[index].id ?? '';
                            categoryController.getSubCategory(
                                categoryController.mainTabs[index].id);

                            categoryController.selectedSubCatergory.value =
                                'all';
                            categoryController.getProductList();
                            myController.setCurrentTab(1);
                          },
                          child: ImageBox(
                            categoryController.mainTabs[index].logoId!,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Center(
                          child: Text(
                            (categoryController.mainTabs[index].name!
                                                .defaultText!.text ??
                                            '')
                                        .length >
                                   7
                                ? '${(categoryController.mainTabs[index].name!
                                                .defaultText!.text ??
                                            '')
                                        .substring(0, 6)}...'
                                : categoryController.mainTabs[index].name!
                                        .defaultText!.text ??
                                    '',
                            style: TextStyles.body,
                          ),
                        )
                      ],
                    ),
                  );
                },
              )
            : const SizedBox(),
      );
    });
  }
}
