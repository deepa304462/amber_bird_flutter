import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class MegaMenuController extends GetxController {
  RxList<GenericTab> mainTabs = <GenericTab>[].obs; //RxList([]);
  RxList<ProductCategory> catList = <ProductCategory>[].obs;
  RxList<GenericTab> subMenuList = <GenericTab>[].obs;
  RxList<DealProduct> dealProductList = <DealProduct>[].obs;
  RxList<Multi> multiProd = <Multi>[].obs;
  RxList<ProductSummary> productList = <ProductSummary>[].obs;

  RxString selectedParentTab = "".obs;
  RxString selectedType = "".obs;
  RxString selectedSubMenu = "".obs;
  RxBool isLoading = true.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    getCategory();
  }

  getCategory() async {
    var payload = {'onlyParentCategories': true};
    var response = await ClientService.searchQuery(
        path: 'cache/productCategory/search', query: payload, lang: 'en');
    var resp;
    if (response.statusCode == 200) {
      if (response.data.length > 1) {
        resp = response.data;
      } else {
        var payload = {"parentCategoryId": response.data[0]['_id']};
        var response1 = await ClientService.searchQuery(
            path: 'cache/productCategory/search', query: payload, lang: 'en');

        if (response1.statusCode == 200) {
          resp = response1.data;
        }
      }
      List<ProductCategory> list = ((resp as List<dynamic>?)
              ?.map((e) => ProductCategory.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      catList.value = (list);

      List<GenericTab> cList = [];
      cList.add(GenericTab(
          image: '441a4502-d2a0-44fc-9ade-56af13a2f7f0',
          id: dealName.SALES.name,
          type: 'DEAL',
          text: 'Sales'));
      cList.add(GenericTab(
          image: '34038fcf-20e1-4840-a188-413b83d72e11',
          id: dealName.FLASH.name,
          type: 'DEAL',
          text: 'Flash'));
      cList.add(GenericTab(
          image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
          id: dealName.SUPER_DEAL.name,
          type: 'DEAL',
          text: 'Hot'));
      cList.add(GenericTab(
          image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
          id: dealName.EXCLUSIVE_DEAL.name,
          type: 'DEAL',
          text: 'Exclusive'));
      cList.add(GenericTab(
          image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
          id: dealName.WEEKLY_DEAL.name,
          type: 'DEAL',
          text: 'Weekly'));
      cList.add(GenericTab(
          image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
          id: dealName.ONLY_COIN_DEAL.name,
          type: 'DEAL',
          text: 'Coin'));
      cList.add(GenericTab(
          image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
          id: dealName.MEMBER_DEAL.name,
          type: 'DEAL',
          text: 'Member'));
      cList.add(GenericTab(
          image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
          id: dealName.PRIME_MEMBER_DEAL.name,
          type: 'DEAL',
          text: 'Prime'));
      cList.add(GenericTab(
          image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
          id: dealName.CUSTOM_RULE_DEAL.name,
          type: 'DEAL',
          text: 'Custom'));
      cList.add(GenericTab(
          image: '7e572f4e-6e21-4c0f-a8a8-44e2c7d64fd2',
          id: multiProductName.COMBO.name,
          type: 'MULTI',
          text: 'Combo'));
      ((resp as List<dynamic>?)?.map((e) {
            ProductCategory category =
                ProductCategory.fromMap(e as Map<String, dynamic>);
            cList.add(GenericTab(
                id: category.id,
                image: category.logoId,
                text: category.name!.defaultText!.text,
                type: 'CAT'));
            return;
          }).toList() ??
          []);
      mainTabs.value = cList;
      getSubMenu(mainTabs.value[0]);
      isLoading.value = false;
    }
  }

  getSubMenu(GenericTab parentTab) async {
    subMenuList.clear();
    selectedType.value = parentTab.type!;
    selectedParentTab.value = parentTab.id!;
    selectedSubMenu.value = parentTab.id!;
    subMenuList.add(GenericTab(
        text: 'All',
        id: parentTab.id,
        type: parentTab.text,
        image: parentTab.image));
    isLoading.value = true;
    if (parentTab.type == 'DEAL') {
      var resp = await ClientService.get(
          path: 'dealProduct/categorySummary', id: parentTab.id);
      ((resp.data as List<dynamic>?)?.map((e) {
            ProductCategory category =
                ProductCategory.fromMap(e as Map<String, dynamic>);
            subMenuList.add(GenericTab(
                id: category.id,
                image: category.logoId,
                text: category.name!.languageTexts![0].text,
                type: parentTab.type));
          }).toList() ??
          []);
    }
    if (parentTab.type == 'MULTI') {
      var resp = await ClientService.get(
          path: 'multiProduct/categorySummary', id: parentTab.id);
      ((resp.data as List<dynamic>?)?.map((e) {
            ProductCategory category =
                ProductCategory.fromMap(e as Map<String, dynamic>);
            subMenuList.add(GenericTab(
                id: category.id,
                image: category.logoId,
                text: category.name!.languageTexts![0].text,
                type: parentTab.type));
          }).toList() ??
          []);
    } else if (parentTab.type == 'CAT') {
      var payload = {"parentCategoryId": parentTab.id};
      var response = await ClientService.searchQuery(
          path: 'cache/productCategory/search', query: payload, lang: 'en');

      if (response.statusCode == 200) {
        ((response.data as List<dynamic>?)?.map((e) {
              ProductCategory category =
                  ProductCategory.fromMap(e as Map<String, dynamic>);
              subMenuList.add(GenericTab(
                  id: category.id,
                  image: category.logoId,
                  text: category.name!.defaultText!.text,
                  type: 'CAT'));
            }).toList() ??
            []);
      }
    }
    isLoading.value = false;
    getAllProducts(subMenuList[0], parentTab);
  }

  Future<void> getAllProducts(GenericTab subMenu, GenericTab parentTab) async {
    isLoading.value = true;
    var payload = {"": ""};
    if (parentTab.type == 'CAT') {
      if (subMenu.text != 'All') {
        payload = {
          "productCategoryId": subMenu.id!,
        };
      } else {
        payload = {
          "parentCategoryId": subMenu.id!,
        };
      }
      var response = await ClientService.searchQuery(
          path: 'cache/product/searchSummary', query: payload, lang: 'en');

      if (response.statusCode == 200) {
        List<ProductSummary> pList = ((response.data as List<dynamic>?)
                ?.map((e) => ProductSummary.fromMap(e as Map<String, dynamic>))
                .toList() ??
            []);
        productList.value = pList;
      }
      isLoading.value = false;
    } else if (parentTab.type == 'DEAL') {
      getDealProduct(subMenu, parentTab.id!);
    } else if (parentTab.type == 'MULTI') {
      getmultiProductProduct(subMenu, parentTab.id!);
    }
  }

  getmultiProductProduct(GenericTab submenu, String key) async {
    isLoading.value = true;
    var payload = {"type": key};
    if (submenu.text != 'All') {
      payload['categoryId'] = submenu.id!;
    }
    var response = await ClientService.searchQuery(
        path: 'cache/multiProduct/search', query: payload, lang: 'en');
    if (response.statusCode == 200) {
      List<Multi> dList = ((response.data as List<dynamic>?)
              ?.map((e) => Multi.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      multiProd.value = (dList);
    }
    isLoading.value = false;
  }

  getDealProduct(GenericTab submenu, String name) async {
    isLoading.value = true;
    var payload = {"type": name};
    if (submenu.text != 'All') {
      payload['categoryId'] = submenu.id!;
    }
    var response = await ClientService.searchQuery(
        path: 'cache/dealProduct/search', query: payload, lang: 'en');
    if (response.statusCode == 200) {
      List<DealProduct> dList = ((response.data as List<dynamic>?)
              ?.map((e) => DealProduct.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      dealProductList.value = (dList);
    }
    isLoading.value = false;
  }
}
