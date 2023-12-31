import 'dart:convert';

import 'package:amber_bird/controller/search-controller.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final SearchDataController searchController =
        Get.put(SearchDataController());
    controller.text = searchController.search.toString();
    return Expanded(
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Obx(
          () {
            return Center(
              child: TextField(
                // controller: controller,
                readOnly: true,
                controller:
                    TextEditingController(text: searchController.search.value),
                onTap: () {
                  showSearch(
                      context: context,
                      // delegate to customize the search bar
                      delegate: CustomSearchDelegate());
                },
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    color: AppColors.grey,
                    size: 18,
                  ),
                  label: const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text("Search for products"),
                  ),
                  labelStyle:
                      TextStyles.titleFont.copyWith(color: AppColors.grey),
                  // contentPadding: const EdgeInsets.all(2.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(
                      color: AppColors.grey,
                    ),
                  ),
                  hintStyle: TextStyle(color: AppColors.primeColor),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: AppColors.grey),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final SearchDataController searchController = Get.find();

// first overwrite to
// clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back_ios,
        size: 15,
      ),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    // List<String> matchQuery = [];
    searchController.getsearchData(query);
    return searchWidgetResult(context);
    // ListView.builder(
    //   itemCount: matchQuery.length,
    //   itemBuilder: (context, index) {
    //     var result = matchQuery[index];
    //     return ListTile(
    //       title: Text(result),
    //     );
    //   },
    // );
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    searchController.getsearchData(query);
    return searchWidgetResult(context);
  }

  Widget searchWidgetResult(BuildContext context) {
    return Obx(
      () => ListView(
        children: [
          query == ''
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text(
                    'Popular searches: ',
                    style: TextStyles.titleFont
                        .copyWith(color: AppColors.DarkGrey),
                  ),
                )
              : const SizedBox(),
          query == ''
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: PopularSearchWidget(context, searchController))
              : const SizedBox(),
          searchController.searchingProduct.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : productResults(context, searchController),
          searchController.searchingCategory.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : categoryResults(context, searchController),
          searchController.searchingBrand.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : brandResults(context, searchController)
        ],
      ),
    );
  }

  Widget PopularSearchWidget(context, SearchDataController searchController) {
    return Wrap(
        // direction: Axis.vertical,
        children: searchController.popularItems.map<Widget>(
      (data) {
        return Container(
          height: 20,
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                width: 1,
                color: query == data['value']
                    ? AppColors.primeColor
                    : AppColors.commonBgColor),
            color: query == data['value']
                ? AppColors.primeColor
                : AppColors.commonBgColor,
            // borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              query = data['value'];
            },
            child: Text(
              data['label'],
              style: TextStyles.body.copyWith(color: AppColors.primeColor),
            ),
          ),
        );
      },
    ).toList());
  }

  Widget productResults(
      BuildContext context, SearchDataController searchController) {
    return Column(
      children: searchController.productResp.value.response!.docs!.map(
        (product) {
          return Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.grey))),
            child: ListTile(
              onTap: () {
                close(context, null);
                Modular.to.navigate('/widget/product', arguments: product.id);
              },
              leading: ImageBox(
                jsonDecode(product.extraData!)['images'][0] ?? '',
                key: Key(product.id!),
                width: 30,
                height: 30,
              ),
              title: Text(
                product.name!,
                style: TextStyles.bodyFont,
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget categoryResults(
      BuildContext context, SearchDataController searchController) {
    return Column(
      children: searchController.categoryResp.value.response!.docs!.map(
        (category) {
          return Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.grey))),
              child: ListTile(
                onTap: () {
                  close(context, null);
                  Modular.to.navigate('/widget/categoryProduct',
                      arguments: category.id);
                },
                leading: jsonDecode(category.extraData!)['logoId'] != null
                    ? ImageBox(
                        jsonDecode(category.extraData!)['logoId'],
                        key: Key(category.id!),
                        width: 30,
                        height: 30,
                      )
                    : const Icon(Icons.category),
                title: Text(
                  category.name!,
                  style: TextStyles.bodyFont,
                ),
              ));
        },
      ).toList(),
    );
  }

  Widget brandResults(
      BuildContext context, SearchDataController searchController) {
    return Column(
      children: searchController.brandResp.value.response!.docs!.map(
        (brand) {
          return Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.grey))),
            child: ListTile(
              onTap: () {
                close(context, null);
                Modular.to
                    .navigate('/widget/brandProduct', arguments: brand.id);
              },
              leading: jsonDecode(brand.extraData!)['logoId'] != null
                  ? ImageBox(
                      jsonDecode(brand.extraData!)['logoId'],
                      key: Key(brand.id!),
                      width: 30,
                      height: 30,
                    )
                  : const Icon(Icons.category),
              title: Text(
                brand.name!,
                style: TextStyles.bodyFont,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
