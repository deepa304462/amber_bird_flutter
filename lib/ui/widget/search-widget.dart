import 'dart:convert';

import 'package:amber_bird/controller/search-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final SearchController searchController = Get.put(SearchController());
    final Controller stateController = Get.find();
    controller.text = searchController.search.toString();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.lightGrey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            // controller: controller,
            readOnly: true,
            onTap: () {
              showSearch(
                  context: context,
                  // delegate to customize the search bar
                  delegate: CustomSearchDelegate());
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  // searchController.setSearchVal(controller.value.text);
                  // if(stateController.activePageName.value != 'search'){
                  //   Modular.to.navigate('/home/search',
                  //       arguments: controller.value.text);
                  // }
                },
                icon: Icon(
                  Icons.search_outlined,
                  color: AppColors.primeColor,
                ),
              ),
              labelText: "Search Product here...",
              contentPadding: const EdgeInsets.all(8.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(
                  color: AppColors.grey,
                ),
              ),
              hintStyle: TextStyle(color: AppColors.primeColor),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: AppColors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final SearchController searchController = Get.find();

// first overwrite to
// clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
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
      icon: Icon(Icons.arrow_back),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    searchController.getsearchData(query);
    return Obx(
      () => searchController.searching.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                productResults(context, searchController),
                categoryResults(context, searchController),
                brandResults(context, searchController)
              ],
            ),
    );
  }

  Widget productResults(
      BuildContext context, SearchController searchController) {
    return Column(
      children:
          searchController.productResp.value.response!.docs!.map((product) {
        return ListTile(
            onTap: () {
              close(context, null);
              Modular.to.navigate('product/${product.id}');
            },
            leading: ImageBox(
              jsonDecode(product.extraData!)['images'][0],
              width: 50,
              height: 50,
            ),
            title: Text(
              product.name!,
              style: TextStyles.titleLargeBold,
            ));
      }).toList(),
    );
  }

  Widget categoryResults(
      BuildContext context, SearchController searchController) {
    return Column(
      children:
          searchController.categoryResp.value.response!.docs!.map((category) {
        return ListTile(
            onTap: () {
              close(context, null);
              Modular.to.navigate('/categoryProduct/${category.id}');
            },
            leading: jsonDecode(category.extraData!)['logoId'] != null
                ? ImageBox(
                    jsonDecode(category.extraData!)['logoId'],
                    width: 50,
                    height: 50,
                  )
                : Icon(Icons.category),
            title: Text(
              category.name!,
              style: TextStyles.titleLargeBold,
            ));
      }).toList(),
    );
  }

  Widget brandResults(BuildContext context, SearchController searchController) {
    return Column(
      children: searchController.brandResp.value.response!.docs!.map((brand) {
        return ListTile(
            onTap: () {
              close(context, null);
              Modular.to.navigate('/brandProduct/${brand.id}');
            },
            leading: jsonDecode(brand.extraData!)['logoId'] != null
                ? ImageBox(
                    jsonDecode(brand.extraData!)['logoId'],
                    width: 50,
                    height: 50,
                  )
                : Icon(Icons.category),
            title: Text(
              brand.name!,
              style: TextStyles.titleLargeBold,
            ));
      }).toList(),
    );
  }
}
