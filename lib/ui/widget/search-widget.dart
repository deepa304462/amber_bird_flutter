import 'package:amber_bird/controller/search-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/services/client-service.dart';
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
// Demo list to show querying
  List<String> searchTerms = [
    "Apple",
    "Banana",
    "Mango",
    "Pear",
    "Watermelons",
    "Blueberries",
    "Pineapples",
    "Strawberries"
  ];
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
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
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
    List<String> matchQuery = [];
    print(query);
    searchController.getsearchData(query);
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return Obx(
      () => ListView.builder(
        itemCount: searchController.searchProductList.value.length,
        itemBuilder: (context, index) {
          var product = searchController.searchProductList.value[index];
          return ListTile(
              onTap: () {
                close(context, null);
                Modular.to
                    .navigate('/home/product-detail', arguments: product.id);
              },
              title: Row(
                children: [
                  product.images!.length > 0
                      ? Image.network(
                          '${ClientService.cdnUrl}${product.images![0]}',
                          height: 20,
                          fit: BoxFit.fill)
                      : const SizedBox(child: Icon(Icons.gif_box)),
                  Text(product.name!.defaultText!.text!),
                ],
              ));
        },
      ),
    );
  }
}
