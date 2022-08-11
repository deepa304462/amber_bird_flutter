import 'dart:developer';

import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isLoading = false;
  ProductCategory selectedCatergory = new ProductCategory();
  ProductCategory selectedSubCatergory = new ProductCategory();
  final Controller myController = Get.put(Controller(), tag: 'mycontroller');
  @override
  initState() {
    getCategoryList();
    super.initState();
  }

  getCategoryList() async {
    if (!myController.categoryList.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      var payload = {"data": ""};
      var response = await ClientService.searchQuery(
          path: 'cache/productCategory/search', query: payload, lang: 'en');

      if (response.statusCode == 200) {
        List<ProductCategory> cList = ((response.data as List<dynamic>?)
                ?.map((e) => ProductCategory.fromMap(e as Map<String, dynamic>))
                .toList() ??
            []);
        myController.setCategory(cList);
        // print(myController.categoryList);
      } else {
        inspect(response);
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  getSubCategory(catId) async {
    setState(() {
      isLoading = true;
    });
    var payload = {"parentCategoryId": catId};
    var response = await ClientService.searchQuery(
        path: 'cache/productCategory/search', query: payload, lang: 'en');

    if (response.statusCode == 200) {
      List<ProductCategory> sList = ((response.data as List<dynamic>?)
              ?.map((e) => ProductCategory.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      myController.setSubCategory(sList);
      print(myController.subCategoryList);
    } else {
      inspect(response);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
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
            child: myController.categoryList.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: myController.categoryList.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                print(
                                    "Container clicked ${index}${myController.categoryList[index]}");
                                selectedCatergory =
                                    myController.categoryList[index];
                                getSubCategory(
                                    myController.categoryList[index].id);
                              },
                              child: Image.network(
                                  '${ClientService.cdnUrl}${myController.categoryList[index].logoId}',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.fill),
                            ),
                            Center(
                              child: Text(
                                myController.categoryList[index].name!
                                        .defaultText!.text ??
                                    '',
                                style: (selectedCatergory.id ==
                                        myController.categoryList[index].id)
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

          GetX<Controller>(
            init: myController,
            //initState: (state) =>state.controller!.reviewIds = resultModel.reviews,
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
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              child: Text(
                                  mController.subCategoryList[index].name!
                                          .defaultText!.text ??
                                      '',
                                  style: (selectedSubCatergory.id ==
                                          myController
                                              .subCategoryList[index].id)
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
                                setState(() {
                                  isLoading = false;
                                });
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
          // sList.isNotEmpty
          //     ? SizedBox(
          //         height: 45,
          //         child: ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           itemCount: sList.length,
          //           itemBuilder: (_, index) {
          //             return Container(
          //               margin: const EdgeInsets.all(8),
          //               padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(10),
          //                   color: AppColors.lightGrey),
          //               child: Row(
          //                 children: [
          //                   Text(sList[index].name!.defaultText!.text ?? '',
          //                       style: TextStyles.title),
          //                   InkWell(
          //                     onTap: () {
          //                       print(
          //                           "Container clicked ${index}${sList[index]}");
          //                       // getSubCategory(cList[index].id);
          //                     },
          //                     child: Image.network(
          //                         '${ClientService.cdnUrl}${sList[index].logoId}',
          //                         width: 25,
          //                         height: 25,
          //                         fit: BoxFit.fill),
          //                   ),
          //                 ],
          //               ),
          //             );
          //           },
          //         ),
          //       )
          //     : const SizedBox(),
        ],
      ),
    );
  }
}
