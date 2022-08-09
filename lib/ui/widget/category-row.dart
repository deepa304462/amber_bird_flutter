import 'dart:developer';

import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class CategoryRow extends StatefulWidget {
  CategoryRow({Key? key}) : super(key: key);

  @override
  State<CategoryRow> createState() => _CategoryRowState();
}

class _CategoryRowState extends State<CategoryRow> {
  bool isLoading = false;
  // RxList<ProductCategory> cList = RxList([]);
  final Controller myController = Get.put(Controller(), tag: 'mycontroller');
  @override
  initState() {
    getCategoryList();
    super.initState();
  }

  getCategoryList() async {
    setState(() {
      isLoading = true;
    });

    var payload = {"locale": 'en'};
    var response = await ClientService.post(
        path: 'productCategory/search?locale=en',
        payload: payload,
        ver: APIVersion.V1);

    if (response.statusCode == 200) {
      List<ProductCategory> cList = ((response.data as List<dynamic>?)
              ?.map((e) => ProductCategory.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      myController.setCategory(cList);
      print(cList);
      print(cList.length);
      // ProductCategory.fromMap(response.data);
      isLoading = false;
    } else {
      inspect(response);
    }

    setState(() {
      isLoading = false;
    });
  }

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
              TextButton(
                onPressed: () {
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
                  itemCount: myController.categoryList.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        children: [
                          Image.network(
                              '${ClientService.cdnUrl}${myController.categoryList[index].logoId}',
                              width: 80,
                              height: 80,
                              fit: BoxFit.fill),
                          Center(
                            child: Text(myController.categoryList[index].name!
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
  }
}
