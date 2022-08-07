import 'dart:developer';

import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isLoading = false;
  RxList<ProductCategory> cList = RxList([]);
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
      cList = RxList((response.data as List<dynamic>?)
              ?.map((e) => ProductCategory.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      // setState(() {
      //   cList=cList;
      // });
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
                onPressed: () {},
                child: Text(
                  "SEE ALL",
                  style: TextStyles.subHeadingFont,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 150,
          child: !isLoading
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cList.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: cList[index].name!.defaultText!.text == ''
                              ? const Color(0xFFE5E6E8)
                              : const Color(0xFFf16b26),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Image.network(
                                '${ClientService.cdnUrl}${cList[index].logoId}'),
                            Center(
                              child: Text(
                                  cList[index].name!.defaultText!.text ?? ''),
                            )
                          ],
                        ),
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
