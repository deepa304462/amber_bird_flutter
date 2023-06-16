import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/data/product/product.tag.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

import '../data/product_availability_resp.dart';

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
    List<GenericTab> cList = [];

    var payload = {'onlyParentCategories': true};
    var response = await ClientService.searchQuery(
        path: 'cache/productCategory/search', query: payload, lang: 'en');
    var resp;
    print(payload);
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

      cList.add(GenericTab(
          image: '34038fcf-20e1-4840-a188-413b83d72e11',
          // image: '441a4502-d2a0-44fc-9ade-56af13a2f7f0',
          id: 'DEAL',
          type: 'DEAL',
          text: 'Deal'));
      cList.add(GenericTab(
          image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
          id: 'TAGS_PRODUCT',
          type: 'TAGS_PRODUCT',
          text: 'Hot'));
      // cList.add(GenericTab(
      //     image: '34038fcf-20e1-4840-a188-413b83d72e11',
      //     id: dealName.FLASH.name,
      //     type: 'DEAL',
      //     text: 'Flash'));

      // cList.add(GenericTab(
      //     image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
      //     id: dealName.EXCLUSIVE_DEAL.name,
      //     type: 'DEAL',
      //     text: 'Exclusive'));
      // cList.add(GenericTab(
      //     image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
      //     id: dealName.WEEKLY_DEAL.name,
      //     type: 'DEAL',
      //     text: 'Weekly'));
      cList.add(GenericTab(
          image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
          id: dealName.ONLY_COIN_DEAL.name,
          type: 'SCOIN',
          text: 'Redeem'));

      // if (Get.isRegistered<Controller>()) {
      // var stateController = Get.find<Controller>();
      // var userType = stateController.userType.value;
      // if (userType != '') {
      // if (userType != '' && userType != memberShipType.No_Membership.name) {
      cList.add(GenericTab(
          image: '441a4502-d2a0-44fc-9ade-56af13a2f7f0',
          id: 'MSD',
          type: 'MSD',
          text: 'MSD'));
      // }
      // }

      // cList.add(GenericTab(
      //     image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
      //     id: dealName.MEMBER_DEAL.name,
      //     type: 'DEAL',
      //     text: 'Member'));
      // cList.add(GenericTab(
      //     image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
      //     id: dealName.PRIME_MEMBER_DEAL.name,
      //     type: 'DEAL',
      //     text: 'Prime'));
      // cList.add(GenericTab(
      //     image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
      //     id: dealName.CUSTOM_RULE_DEAL.name,
      //     type: 'DEAL',
      //     text: 'Custom'));
      // cList.add(GenericTab(
      //     image: '7e572f4e-6e21-4c0f-a8a8-44e2c7d64fd2',
      //     id: multiProductName.COMBO.name,
      //     type: 'MULTI',
      //     text: 'Combo'));
      cList.add(GenericTab(
          image: '7e572f4e-6e21-4c0f-a8a8-44e2c7d64fd2',
          id: 'MULTI',
          type: 'MULTI',
          text: 'Multi'));
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
      // }
    }
  }

  getSubMenu(GenericTab parentTab) async {
    subMenuList.clear();
    selectedType.value = parentTab.type!;
    selectedParentTab.value = parentTab.id!;
    selectedSubMenu.value = parentTab.id!;
    if (parentTab.type != 'TAGS_PRODUCT') {
      subMenuList.add(GenericTab(
          text: 'All',
          id: parentTab.id,
          type: parentTab.text,
          image: parentTab.image));
    }
    isLoading.value = true;
    if (parentTab.type == 'DEAL') {
      var responseDeal = await ClientService.get(
          path:
              'dealProduct/getDealsAndMultiProductsTypesWithProductsAvailable');

      if (responseDeal.statusCode == 200) {
        ProductAvailabilityResp data =
            ProductAvailabilityResp.fromMap(responseDeal.data);

        data.productsAvailableInDealTypes!.forEach((element) {
          var detail = Helper.getCatDealName(element);
          subMenuList.add(GenericTab(
              image: detail['imageId'],
              id: element,
              type: 'DEAL',
              text: detail['name']));
        });
        subMenuList.add(
            GenericTab(image: '', id: 'CENTS', type: 'DEAL', text: 'Cents'));
        subMenuList.add(GenericTab(
            image: '', id: 'RESTOCKED', type: 'DEAL', text: 'Re-Stocked'));
      }
      // var resp = await ClientService.get(
      //     path: 'dealProduct/categorySummary', id: parentTab.id);
      // ((resp.data as List<dynamic>?)?.map((e) {
      //       ProductCategory category =
      //           ProductCategory.fromMap(e as Map<String, dynamic>);
      //       subMenuList.add(GenericTab(
      //           id: category.id,
      //           image: category.logoId,
      //           text: category.name!.languageTexts![0].text,
      //           type: parentTab.type));
      //     }).toList() ??
      //     []);
    }
    if (parentTab.type == 'MULTI') {
      var responseDeal = await ClientService.get(
          path:
              'dealProduct/getDealsAndMultiProductsTypesWithProductsAvailable');

      if (responseDeal.statusCode == 200) {
        // subMenuList.add(GenericTab(
        // image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
        // id: 'collection_view',
        // type: 'MULTI',
        // text: 'Collection'));
        ProductAvailabilityResp data =
            ProductAvailabilityResp.fromMap(responseDeal.data);

        data.productsAvailableInMultiTypes!.forEach((element) {
          var detail = Helper.getCatMultiName(element);
          subMenuList.add(GenericTab(
              image: detail['imageId'],
              id: element,
              type: 'MULTI',
              text: detail['name']));
        });
      }
      // var resp = await ClientService.get(
      //     path: 'multiProduct/categorySummary', id: parentTab.id);
      // ((resp.data as List<dynamic>?)?.map((e) {
      //       ProductCategory category =
      //           ProductCategory.fromMap(e as Map<String, dynamic>);
      //       subMenuList.add(GenericTab(
      //           id: category.id,
      //           image: category.logoId,
      //           text: category.name!.languageTexts![0].text,
      //           type: parentTab.type));
      //     }).toList() ??
      //     []);
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
    } else if (parentTab.type == 'TAGS_PRODUCT') {
      var response =
          await ClientService.post(path: 'productTag/search', payload: {});
      if (response.statusCode == 200) {
        List<ProductTag> tagList = ((response.data as List<dynamic>?)
                ?.map((e) => ProductTag.fromMap(e as Map<String, dynamic>))
                .toList() ??
            []);
        if (tagList.length > 0) {
          selectedSubMenu.value = tagList[0].id ?? '';
        }
        tagList.forEach((element) {
          var detail =
              '${element.title!.defaultText != null ? element.title!.defaultText!.text : element.title!.languageTexts![0].text}';
          subMenuList.add(GenericTab(
              image: '', id: element.id, type: 'DEAL', text: detail));
        });
      }
    }
    isLoading.value = false;
    getAllProducts(subMenuList[0], parentTab);
  }

  Future<void> getAllProducts(GenericTab subMenu, GenericTab parentTab) async {
    Controller stateController =
        ControllerGenerator.create(Controller(), tag: 'Controller');
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
        List<ProductSummary> dList2 = pList
            .where((i) =>
                stateController.dealsProductsIdList.indexOf(i.id ?? '') < 0)
            .toList();
        productList.value = dList2;
      }
      isLoading.value = false;
    } else if (parentTab.type == 'SCOIN') {
      var payload = {"onlyAvailableViaSCoins": true};
      var response = await ClientService.searchQuery(
          path: 'product/searchSummary', query: payload, lang: 'en');
      if (response.statusCode == 200) {
        List<ProductSummary> dList =
            ((response.data as List<dynamic>?)?.map((e) {
                  ProductSummary productSummary =
                      ProductSummary.fromMap(e as Map<String, dynamic>);
                  var list = productSummary.varients!
                      .where((i) => i.scoinPurchaseEnable!)
                      .toList();
                  productSummary.varient = list[0];
                  productSummary.varients = list;
                  return productSummary;
                }).toList() ??
                []);
        List<ProductSummary> dList2 = dList
            .where((i) =>
                stateController.dealsProductsIdList.indexOf(i.id ?? '') < 0)
            .toList();
        productList.value = dList2;
        isLoading.value = false;
      }
    } else if (parentTab.type == 'TAGS_PRODUCT') {
      var payload = {"tagId": selectedSubMenu.value};
      var response = await ClientService.searchQuery(
          path: 'product/searchSummary', query: payload, lang: 'en');
      if (response.statusCode == 200) {
        List<ProductSummary> dList =
            ((response.data as List<dynamic>?)?.map((e) {
                  ProductSummary productSummary =
                      ProductSummary.fromMap(e as Map<String, dynamic>);
                  return productSummary;
                }).toList() ??
                []);

        List<ProductSummary> dList2 = dList
            .where((i) =>
                stateController.dealsProductsIdList.indexOf(i.id ?? '') < 0)
            .toList();
        productList.value = dList2;
      }
      isLoading.value = false;
    } else if (parentTab.type == 'MSD') {
      var payload = {"onlyMSDProducts": true};
      var response = await ClientService.searchQuery(
          path: 'product/searchSummary', query: payload, lang: 'en');
      if (response.statusCode == 200) {
        var userType = '';
        if (Get.isRegistered<Controller>()) {
          var stateController = Get.find<Controller>();
          userType = stateController.userType.value;
        }
        List<ProductSummary> dList =
            ((response.data as List<dynamic>?)?.map((e) {
                  ProductSummary productSummary =
                      ProductSummary.fromMap(e as Map<String, dynamic>);
                  var list = productSummary.varients!.where((i) {
                    var valid = true;
                    if (i.price!.membersSpecialPrice!.onlyForGoldMember! ||
                        i.price!.membersSpecialPrice!.onlyForPlatinumMember! ||
                        i.price!.membersSpecialPrice!.onlyForSilverMember!) {
                      if ((i.price!.membersSpecialPrice!.onlyForGoldMember!) &&
                          userType == memberShipType.Gold.name) {
                        valid = true;
                      } else if ((i.price!.membersSpecialPrice!
                              .onlyForPlatinumMember!) &&
                          userType == memberShipType.Platinum.name) {
                        valid = true;
                      } else if ((i.price!.membersSpecialPrice!
                              .onlyForSilverMember!) &&
                          userType == memberShipType.Silver.name) {
                        valid = true;
                      }
                    }
                    return i.msdApplicableProduct! && valid;
                  }).toList();
                  if (list.length > 0) {
                    productSummary.varient = list[0];
                    productSummary.varients = list;
                    return productSummary;
                  } else {
                    return ProductSummary();
                  }
                }).toList() ??
                []);

        List<ProductSummary> dList2 = dList
            .where((i) => (i.id != null &&
                stateController.dealsProductsIdList.indexOf(i.id ?? '') < 0))
            .toList();
        productList.value = dList2;
      }
      isLoading.value = false;
    } else if (parentTab.type == 'DEAL') {
      // getDealProduct(subMenu, parentTab.id!);
      getDealProduct(subMenu, subMenu.id!);
    } else if (parentTab.type == 'MULTI') {
      getmultiProductProduct(subMenu, subMenu.id!);
      // getmultiProductProduct(subMenu, parentTab.id!);
    }
  }

  getmultiProductProduct(GenericTab submenu, String key) async {
    isLoading.value = true;
    var payload = {"type": key};
    // if (submenu.text != 'All') {
    //   payload['categoryId'] = submenu.id!;
    // }
    print(submenu);
    print(key);
    // collection_view
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
    if (name == 'CENTS') {
      var payload = {'lessThanOneEuroProducts': true};

      var response = await ClientService.searchQuery(
          path: 'product/searchSummary', query: payload, lang: 'en');
      if (response.statusCode == 200) {
        List<ProductSummary> summaryProdList =
            ((response.data as List<dynamic>?)?.map((e) {
                  ProductSummary productSummary =
                      ProductSummary.fromMap(e as Map<String, dynamic>);
                  var list = productSummary.varients!.where((i) {
                    if (i.price!.offerPrice! < 1.00) {
                      return true;
                    }
                    return false;
                  }).toList();
                  if (list.length > 0) {
                    productSummary.varient = list[0];
                    productSummary.varients = [list[0]];
                    //list;
                    return productSummary;
                  } else {
                    return ProductSummary();
                  }
                }).toList() ??
                []);

        productList.value = summaryProdList;
        isLoading.value = false;
      }
    } else if (name == 'RESTOCKED') {
      var payload = {'backInStock': true};

      var response = await ClientService.searchQuery(
          path: 'product/searchSummary', query: payload, lang: 'en');
      if (response.statusCode == 200) {
        List<ProductSummary> summaryProdList =
            ((response.data as List<dynamic>?)?.map((e) {
                  ProductSummary productSummary =
                      ProductSummary.fromMap(e as Map<String, dynamic>);
                  var list = productSummary.varients!.where((i) {
                    if (i.price!.offerPrice! < 1.00) {
                      return true;
                    }
                    return false;
                  }).toList();
                  if (list.length > 0) {
                    productSummary.varient = list[0];
                    productSummary.varients = [list[0]];
                    //list;
                    return productSummary;
                  } else {
                    return ProductSummary();
                  }
                }).toList() ??
                []);

        productList.value = summaryProdList;
        isLoading.value = false;
      }
    } else {
      isLoading.value = true;
      var payload = {"type": name};
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
}
