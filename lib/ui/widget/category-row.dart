import 'dart:developer';

import 'package:amber_bird/controller/category-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

// class CategoryRow extends StatefulWidget {
//   CategoryRow({Key? key}) : super(key: key);

//   @override
//   State<CategoryRow> createState() => _CategoryRowState();
// }

// class _CategoryRowState extends State<CategoryRow> {
class CategoryRow extends StatelessWidget {
  bool isLoading = false;
  // RxList<ProductCategory> cList = RxList([]);
  final CategoryController categoryController = Get.put(CategoryController());
  final Controller myController = Get.put(Controller());
  
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
                TextButton(
                  onPressed: () {
                    myController.setCurrentTab(2);
                    Modular.to.navigate('/category');
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
                            Image.network(
                                '${ClientService.cdnUrl}${categoryController.categoryList[index].logoId}',
                                width: 80,
                                height: 80,
                                fit: BoxFit.fill),
                            Center(
                              child: Text(categoryController.categoryList[index].name!
                                      .defaultText!.text ??
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
