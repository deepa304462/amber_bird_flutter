import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/checkout/checkout.dart';
import 'package:amber_bird/data/checkout/order_product_availability_status.dart';
import 'package:amber_bird/data/coupon_code/coupon_code.dart';
import 'package:amber_bird/data/customer/customer.insight.detail.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/data/order/order.dart';
import 'package:amber_bird/data/payment/payment.dart';
import 'package:amber_bird/data/order/product_order.dart';
import 'package:amber_bird/data/price/price.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  RxMap<String, ProductOrder> cartProducts = <String, ProductOrder>{}.obs;
  RxMap<String, ProductOrder> cartProductsScoins = <String, ProductOrder>{}.obs;
  RxMap<String, ProductOrder> saveLaterProducts = <String, ProductOrder>{}.obs;
  RxMap<String, ProductOrder> msdProducts = <String, ProductOrder>{}.obs;
  final checkoutData = Rxn<Checkout>();
  final paymentData = Rxn<Payment>();
  final scoinCheckoutData = Rxn<Checkout>();
  final scoinPaymentData = Rxn<Payment>();
  final scoinOrderData = Rxn<Order>();
  RxString selectedPaymentMethod = "MOLLIE".obs;
  RxString orderId = "".obs;
  RxString saveLaterId = "".obs;
  Rx<Price> totalPrice = Price.fromMap({}).obs;
  Rx<Payment> calculatedPayment = Payment.fromMap({}).obs;
  var couponName = ''.obs;
  RxList<CouponCode> searchCouponList = <CouponCode>[].obs;
  Rx<CouponCode> selectedCoupon = CouponCode().obs;
  Rx<bool> searchingProduct = true.obs;
  Rx<bool> couponIncludeCondition = false.obs;
  RxList<SliverList> innerLists = <SliverList>[].obs;
  String uniqueId = Random().nextInt(34342).toString();

  @override
  void onInit() {
    fetchCart();
    // print('${getCurrentTag()} controller __________________');

    super.onInit();
  }

  applyCoupon() {}

  checkout() async {
    List<dynamic> listSumm = [];
    List<dynamic> listScoins = [];
    List<dynamic> listMsd = [];
    for (var v in cartProducts.values) {
      listSumm.add((jsonDecode(v.toJson())));
    }
    for (var v in cartProductsScoins.values) {
      listScoins.add((jsonDecode(v.toJson())));
    }
    for (var v in msdProducts.values) {
      listMsd.add((jsonDecode(v.toJson())));
    }
    if (listScoins.length > 0 && listSumm.length > 0) {
      selectedPaymentMethod.value = 'MOLLIE_PLUS_SCOINS';
    } else if (listScoins.length > 0) {
      selectedPaymentMethod.value = 'SCOINS ';
    } else if (listSumm.length > 0) {
      selectedPaymentMethod.value = 'MOLLIE';
    }
    var selectedAdd;
    if (Get.isRegistered<LocationController>()) {
      var locationController = Get.find<LocationController>();
      selectedAdd = locationController.addressData.value;
    }
    Ref custRef = await Helper.getCustomerRef();
    var insightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    var referredbyId = await SharedData.read('referredById');
    Customer cust = Customer.fromMap(insightDetail as Map<String, dynamic>);
    var payload;
    if (selectedAdd != null && selectedAdd.name != null) {
      var resp = await ClientService.post(
          path: 'order/checkout', payload: (jsonDecode((cust.cart!.toJson()))));
      if (resp.statusCode == 200) {
        Checkout data = Checkout.fromMap(resp.data);
        checkoutData.value = data;
        if (data.allAvailable == true) {
          var resp1;
          if (cust.cart != null && cust.cart!.id != '') {
            payload = {
              'status': 'INIT',
              'customerRef': (jsonDecode(custRef.toJson())),
              'products': listSumm,
              'productsViaSCoins': listScoins,
              'msdApplicableProducts': listMsd,
              "payment": {
                "paidBy": (jsonDecode(custRef.toJson())),
                "order": orderId.value != ''
                    ? {"name": custRef.id, "_id": orderId.value}
                    : null,
                "currency": "EUR", //{"currencyCode": "USD"},
                "paidTo": {"name": "sbazar", "_id": "sbazar"},
                "status": "OPEN",
                "description": "order created",
                "paymentGateWayDetail": {
                  "usedPaymentGateWay": selectedPaymentMethod.value,
                },
                "appliedCouponCode": selectedCoupon.value.couponCode != null
                    ? {
                        "name": selectedCoupon.value.couponCode,
                        "_id": selectedCoupon.value.id
                      }
                    : null,
              },
              '_id': cust.cart!.id,
              'metaData': (jsonDecode(cust.cart!.metaData!.toJson())),
              'shipping': {
                'orderRef': orderId.value != ''
                    ? {"name": custRef.id, "_id": cust.cart!.id}
                    : null,
                'destination': {
                  'customerAddress': (jsonDecode(selectedAdd.toJson())),
                }
              },
              'referredById': referredbyId != null ? referredbyId : null,
            };
            resp1 = await ClientService.Put(
                path: 'order', id: cust.cart!.id!, payload: payload);
          } else {
            payload = {
              'status': 'INIT',
              'customerRef': (jsonDecode(custRef.toJson())),
              'products': listSumm,
              'productsViaSCoins': listScoins,
              'msdApplicableProducts': listMsd,
              "payment": {
                "paidBy": (jsonDecode(custRef.toJson())),
                "currency": "EUR", //{"currencyCode": "USD"},
                "paidTo": {"name": "sbazar", "_id": "sbazar"},
                "status": "OPEN",
                "description": "order created",
                "paymentGateWayDetail": {
                  "usedPaymentGateWay": selectedPaymentMethod.value,
                },
                "appliedCouponCode": selectedCoupon.value.couponCode != null
                    ? {
                        "name": selectedCoupon.value.couponCode,
                        "_id": selectedCoupon.value.id
                      }
                    : null,
              },
              'referredById': referredbyId,
              'shipping': {
                'destination': {
                  'customerAddress': (jsonDecode(selectedAdd.toJson())),
                }
              }
            };
            resp1 = await ClientService.post(path: 'order', payload: payload);
          }
          // dev.log(jsonEncode(resp1.data).toString());
          if (resp1.statusCode == 200) {
            if (orderId.value == '') orderId.value = resp1.data['_id'];
            // var ord = Order.fromMap(resp1.data);
            cust.cart = Order.fromMap(resp1.data);
            calculatedPayment.value = cust.cart!.payment!;
            OfflineDBService.save(OfflineDBService.customerInsightDetail,
                (jsonDecode(cust.toJson())));
            return ({'error': false, 'data': '', 'msg': ''});
          } else {
            return ({
              'error': false,
              'data': '',
              'msg': 'Something went wrong!!'
            });
          }
        } else {
          return ({
            'error': true,
            'data': '',
            'msg': 'All products not available!!'
          });
        }
      } else {
        return ({'error': true, 'data': '', 'msg': 'Something went wrong!!'});
      }
    } else {
      return ({'error': true, 'data': '', 'msg': 'Address can not be empty!!'});
    }
  }

  clearCheckout() {
    checkoutData.value = null;
  }

  calculateTotalCost() {
    Price pr = Price.fromMap({'actualPrice': 0.0, 'offerPrice': 0.0});
    for (var v in cartProducts.value.values) {
      pr.actualPrice = pr.actualPrice! + v.price!.actualPrice!;
      pr.offerPrice = pr.offerPrice! + v.price!.actualPrice!;
    }
    if (selectedCoupon.value != null) {
      var reward = selectedCoupon.value.reward;
      if (reward?.discountUptos != null) {
        pr.offerPrice = pr.offerPrice! - reward?.discountUptos;
      } else if (reward?.flatDiscount != null) {
        pr.offerPrice = pr.offerPrice! - reward?.discountUptos;
      } else if (reward?.discountPercent != null) {
        var disc = (pr.offerPrice! * reward?.discountPercent) / 100;
        pr.offerPrice = pr.offerPrice! - disc;
      }
    }
    totalPrice.value = pr;
  }

  createPayment() async {
    // double total = 0.0;
    List<dynamic> listSumm = [];
    List<dynamic> listScoins = [];
    List<dynamic> listMsd = [];
    for (var v in cartProducts.values) {
      listSumm.add((jsonDecode(v.toJson())));
    }
    for (var v in cartProductsScoins.values) {
      listScoins.add((jsonDecode(v.toJson())));
    }
    for (var v in msdProducts.values) {
      listMsd.add((jsonDecode(v.toJson())));
    }
    if (listScoins.length > 0 && listSumm.length > 0) {
      selectedPaymentMethod.value = 'MOLLIE_PLUS_SCOINS';
    } else if (listScoins.length > 0) {
      selectedPaymentMethod.value = 'SCOINS ';
    } else if (listSumm.length > 0) {
      selectedPaymentMethod.value = 'MOLLIE';
    }
    var selectedAdd;
    if (Get.isRegistered<LocationController>()) {
      var locationController = Get.find<LocationController>();
      selectedAdd = locationController.addressData.value;
    }
    Ref custRef = await Helper.getCustomerRef();
    var insightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    var referredbyId = await SharedData.read('referredById');
    Customer cust = Customer.fromMap(insightDetail as Map<String, dynamic>);
    if (selectedAdd != null && selectedAdd.name != null) {
      var payload;

      var resp = await ClientService.post(
          path: 'order/checkout', payload: (jsonDecode((cust.cart!.toJson()))));
      if (resp.statusCode == 200) {
        Checkout data = Checkout.fromMap(resp.data);
        checkoutData.value = data;
        if (data.allAvailable == true) {
          var resp1;
          if (cust.cart != null && cust.cart!.id != '') {
            payload = {
              'status': 'INIT',
              'customerRef': (jsonDecode(custRef.toJson())),
              'products': listSumm,
              'productsViaSCoins': listScoins,
              'msdApplicableProducts': listMsd,
              "payment": {
                "paidBy": (jsonDecode(custRef.toJson())),
                "order": orderId.value != ''
                    ? {"name": custRef.id, "_id": orderId.value}
                    : null,
                "currency": "EUR", //{"currencyCode": "USD"},
                "paidTo": {"name": "sbazar", "_id": "sbazar"},
                "status": "OPEN",
                "description": "order created",
                "paymentGateWayDetail": {
                  "usedPaymentGateWay": selectedPaymentMethod.value,
                },
                "appliedCouponCode": selectedCoupon.value.couponCode != null
                    ? {
                        "name": selectedCoupon.value.couponCode,
                        "_id": selectedCoupon.value.id
                      }
                    : null,
              },
              '_id': cust.cart!.id,
              'metaData': (jsonDecode(cust.cart!.metaData!.toJson())),
              'shipping': {
                'orderRef': orderId.value != ''
                    ? {"name": custRef.id, "_id": cust.cart!.id}
                    : null,
                'destination': {
                  'customerAddress': (jsonDecode(selectedAdd.toJson())),
                }
              },
              'referredById': referredbyId != null ? referredbyId : null,
            };
            resp1 = await ClientService.Put(
                path: 'order', id: cust.cart!.id!, payload: payload);
          } else {
            payload = {
              'status': 'INIT',
              'customerRef': (jsonDecode(custRef.toJson())),
              'products': listSumm,
              'productsViaSCoins': listScoins,
              'msdApplicableProducts': listMsd,
              "payment": {
                "paidBy": (jsonDecode(custRef.toJson())),
                "currency": "EUR", //{"currencyCode": "USD"},
                "paidTo": {"name": "sbazar", "_id": "sbazar"},
                "status": "OPEN",
                "description": "order created",
                "paymentGateWayDetail": {
                  "usedPaymentGateWay": selectedPaymentMethod.value,
                },
                "appliedCouponCode": selectedCoupon.value.couponCode != null
                    ? {
                        "name": selectedCoupon.value.couponCode,
                        "_id": selectedCoupon.value.id
                      }
                    : null,
              },
              'referredById': referredbyId,
              'shipping': {
                'destination': {
                  'customerAddress': (jsonDecode(selectedAdd.toJson())),
                }
              }
            };
            resp1 = await ClientService.post(path: 'order', payload: payload);
          }
          // dev.log(jsonEncode(resp1.data).toString());
          if (resp1.statusCode == 200) {
            if (orderId.value == '') orderId.value = resp1.data['_id'];
            // var ord = Order.fromMap(resp1.data);
            cust.cart = Order.fromMap(resp1.data);
            calculatedPayment.value = cust.cart!.payment!;
            OfflineDBService.save(OfflineDBService.customerInsightDetail,
                (jsonDecode(cust.toJson())));
            return ({'error': false, 'data': '', 'msg': ''});

            // });
          } else {
            return ({
              'error': true,
              'data': '',
              'msg': 'All products not available!!'
            });
          }
        } else {
          return ({'error': true, 'data': '', 'msg': 'Something went wrong!!'});
        }
      } else {
        return ({'error': true, 'data': '', 'msg': 'Something went wrong!!'});
      }
    } else {
      return ({'error': true, 'data': '', 'msg': 'Address can not be empty!!'});
    }
  }

  searchPayment() async {
    var respPayment = await ClientService.post(
        path: 'payment/search',
        payload: {"orderId": orderId.value, "status": "OPEN"});
    if (respPayment.statusCode == 200) {
      if (respPayment.data.length > 0 &&
          respPayment.data[respPayment.data.length - 1] != null) {
        paymentData.value = Payment.fromMap(respPayment
            .data[respPayment.data.length - 1] as Map<String, dynamic>);
        if (paymentData.value!.checkoutUrl != null) {
          return ({'error': false, 'data': paymentData.value!.checkoutUrl});
        } else {
          return ({'error': true, 'msg': 'Please try again in some time'});
        }
      } else {
        return ({'error': true, 'msg': 'Please try again in some time'});
      }
    } else {
      return ({'error': true, 'data': '', 'msg': 'Something went wrong!!'});
    }
  }

  paymentStatusCheck() async {
    var resp = await ClientService.get(
        path: 'payment/mollie/getPayment', id: paymentData.value!.id);
    if (resp.statusCode == 200) {
      paymentData.value = Payment.fromMap(resp.data as Map<String, dynamic>);
      resetCustomerDetail();
      return ({'error': false, 'data': resp.data});
    } else {
      return ({'error': true, 'data': ''});
    }
  }

  resetCustomerDetail() async {
    if (Get.isRegistered<Controller>()) {
      var controller = Get.find<Controller>();
      var customerInsightDetail = await ClientService.post(
          path: 'customerInsight/detail',
          payload: {},
          payloadAsString: controller.loggedInPRofileId.value);
      if (customerInsightDetail.statusCode == 200) {
        OfflineDBService.save(
            OfflineDBService.customerInsightDetail, customerInsightDetail.data);
        // resetCart();
        fetchCart();
      }
    }
  }

  removeProduct(currentKey, key) async {
    if (key == 'SCOIN') {
      cartProductsScoins.remove(currentKey);
    } else if (key == 'MSD') {
      msdProducts.remove(currentKey);
    } else {
      cartProducts.remove(currentKey);
    }

    await createOrder();
  }

  removeSaveLater(currentKey) async {
    saveLaterProducts.remove(currentKey);
    await saveLaterCall();
  }

  addTocartSaveLater(key) async {
    cartProducts[key] = saveLaterProducts.value[key] ?? ProductOrder();
    await createOrder();
    await removeSaveLater(key);
    // saveLaterProducts.remove(key);
    // await saveLaterCall();
  }

  resetCart() async {
    cartProducts.clear();
    cartProductsScoins.clear();
    msdProducts.clear();
    calculatedPayment.value = Payment();
    var insightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    Customer cust = Customer.fromMap(insightDetail as Map<String, dynamic>);
    cust.cart = null;
    await createOrder();
    OfflineDBService.save(
        OfflineDBService.customerInsightDetail, (jsonDecode(cust.toJson())));
  }

  fetchCart() async {
    cartProducts.clear();
    cartProductsScoins.clear();
    msdProducts.clear();
    calculatedPayment.value = Payment();
    var insightDetailloc =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    if (insightDetailloc != null) {
      Customer cust = Customer.fromMap(
          (jsonDecode(jsonEncode(insightDetailloc))) as Map<String, dynamic>);
      if (cust.cart != null) {
        calculatedPayment.value =
            cust.cart!.payment != null ? cust.cart!.payment! : Payment();
        orderId.value = cust.cart!.id ?? '';
        for (var element in cust.cart!.products!) {
          cartProducts[element.ref!.id ?? ''] = element;
        }
        for (var element in cust.cart!.productsViaSCoins!) {
          cartProductsScoins[element.ref!.id ?? ''] = element;
        }
        for (var element in cust.cart!.msdApplicableProducts!) {
          msdProducts[element.ref!.id ?? ''] = element;
        }
      } else {
        cartProducts.clear();
        cartProductsScoins.clear();
        msdProducts.clear();
        calculatedPayment.value = Payment();
      }
      if (cust.saveLater != null) {
        saveLaterId.value = cust.saveLater!.id ?? '';
        for (var element in cust.saveLater!.products!) {
          saveLaterProducts[element.ref!.id ?? ''] = element;
        }
      } else {
        saveLaterProducts.clear();
        saveLaterId.value = '';
      }
    } else {
      cartProducts.clear();
      cartProductsScoins.clear();
      msdProducts.clear();
      calculatedPayment.value = Payment();
      saveLaterProducts.clear();
      saveLaterId.value = '';
    }
  }

  Future<void> addToCart(
      String refId,
      String addedFrom,
      int? addQuantity,
      Price? priceInfo,
      ProductSummary? product,
      List<ProductSummary>? products,
      RuleConfig? ruleConfig,
      Constraint? constraint,
      Varient? varient,
      {String? mutliProductName}) async {
    // bool createOrderRequired = true;
    clearCheckout();
    var customerInsightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    if (customerInsightDetail['_id'] == null) {
      var getData = cartProducts[refId];
      int quantity = 0 + addQuantity!;
      double price = (priceInfo!.offerPrice!).toDouble();
      List li = [];
      if (products != null) {
        for (var element in products) {
          li.add(element.toJson());
          if (priceInfo == null) {
            price = price + element.varient!.price!.offerPrice!;
          }
          if (getData != null) {
            quantity = getData.count!;
            quantity = quantity + addQuantity;
          } else {}
        }
      } else {
        if (getData != null) {
          quantity = getData.count!;
          quantity = quantity + addQuantity;
        }
        product!.varient = varient;
      }
      if (quantity > 0) {
        ProductOrder cartRow = ProductOrder.fromMap({
          'products': li.isNotEmpty
              ? (jsonDecode(li.toString()))
              : (jsonDecode(li.toString())),
          'product': product != null ? (jsonDecode(product.toJson())) : null,
          'count': quantity,
          'ref': {'_id': refId, 'name': addedFrom},
          'ruleConfig': (jsonDecode(ruleConfig?.toJson() ?? "{}")),
          'constraint': (jsonDecode(constraint?.toJson() ?? "{}")),
          'productType': li.isNotEmpty ? null : product!.type,
          'name': mutliProductName ?? '',
          'price': {
            'actualPrice': price,
            'noMemberCoin': 0,
            'platinumMemberCoin': 0,
            'goldMemberCoin': 0,
            'silverMemberCoin': 0,
            'paidMemberCoin': 0,
            'offerPrice': price,
            'membersSpecialPrice': {
              'onlyForPlatinumMember':
                  priceInfo.membersSpecialPrice!.onlyForPlatinumMember,
              'onlyForSilverMember':
                  priceInfo.membersSpecialPrice!.onlyForSilverMember,
              'onlyForGoldMember':
                  priceInfo.membersSpecialPrice!.onlyForGoldMember,
              'forSilverMember': priceInfo.membersSpecialPrice!.forSilverMember,
              'forGoldMember': priceInfo.membersSpecialPrice!.forGoldMember,
              'forPlatinumMember':
                  priceInfo.membersSpecialPrice!.forPlatinumMember,
            }
          }
        });
        cartProducts[refId] = cartRow;
      } else {
        removeProduct(refId, '');
        return;
      }
    } else {}
    await createOrder();
  }

  Future<void> addToCartMSD(
      String refId,
      String addedFrom,
      int? addQuantity,
      Price? priceInfo,
      ProductSummary? product,
      List<ProductSummary>? products,
      RuleConfig? ruleConfig,
      Constraint? constraint,
      Varient? varient,
      {String? mutliProductName}) async {
    clearCheckout();
    var customerInsightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    if (customerInsightDetail['_id'] == null) {
      var getData = msdProducts[refId];
      int quantity = 0 + addQuantity!;
      double price = (priceInfo!.offerPrice!);
      List li = [];
      if (products != null) {
        for (var element in products) {
          li.add(element.toJson());
          if (priceInfo == null) {
            price = price + element.varient!.price!.offerPrice!;
          }
          if (getData != null) {
            quantity = getData.count!;
            quantity = quantity + addQuantity;
          } else {}
        }
      } else {
        if (getData != null) {
          quantity = getData.count!;
          quantity = quantity + addQuantity;
        }
        product!.varient = varient;
      }
      if (quantity > 0) {
        ProductOrder cartRow = ProductOrder.fromMap({
          'products': li.isNotEmpty
              ? (jsonDecode(li.toString()))
              : (jsonDecode(li.toString())),
          'product': product != null ? (jsonDecode(product.toJson())) : null,
          'count': quantity,
          'ref': {'_id': refId, 'name': addedFrom},
          'ruleConfig': (jsonDecode(ruleConfig?.toJson() ?? "{}")),
          'constraint': (jsonDecode(constraint?.toJson() ?? "{}")),
          'productType': li.isNotEmpty ? null : product!.type,
          'name': mutliProductName ?? '',
          'price': (jsonDecode(priceInfo.toJson() ?? "{}"))
        });
        msdProducts[refId] = cartRow;
      } else {
        removeProduct(refId, '');
        return;
      }
    } else {}
    await createOrder();
  }

  Future<void> addToCartScoins(
      String refId,
      String addedFrom,
      int? addQuantity,
      Price? priceInfo,
      ProductSummary? product,
      List<ProductSummary>? products,
      RuleConfig? ruleConfig,
      Constraint? constraint,
      Varient? varient) async {
    clearCheckout();
    var customerInsightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    if (customerInsightDetail['_id'] == null) {
      var getData = cartProductsScoins[refId];
      int quantity = 0 + addQuantity!;
      List li = [];
      // var userType = null;
      // var priceObj = {
      //   'actualPrice': 0.0,
      //   'offerPrice':  0.0,
      //   'noMemberCoin':  0.0,
      //   'platinumMemberCoin':  0.0,
      //   'goldMemberCoin':  0.0,
      //   'silverMemberCoin':  0.0,
      //   'paidMemberCoin':  0.0,
      // };
      // if (Get.isRegistered<Controller>()) {
      //   var stateController = Get.find<Controller>();
      //   userType = stateController.userType.value;
      // }
      if (getData != null) {
        quantity = getData.count!;
        quantity = quantity + addQuantity;
      }

      // if (userType != null) {
      //   if (userType == memberShipType.Gold.name) {
      //     priceObj['goldMemberCoin'] = priceInfo!.goldMemberCoin!;
      //   } else if (userType == memberShipType.Platinum.name) {
      //     priceObj['platinumMemberCoin'] = priceInfo!.platinumMemberCoin!;
      //   } else if (userType == memberShipType.Silver.name) {
      //     priceObj['silverMemberCoin'] = priceInfo!.silverMemberCoin!;
      //   } else if (userType == memberShipType.Paid.name) {
      //     priceObj['paidMemberCoin'] = priceInfo!.paidMemberCoin!;
      //   } else {
      //     priceObj['noMemberCoin'] = priceInfo!.noMemberCoin!;
      //   }
      // } else {
      //   priceObj['noMemberCoin'] = priceInfo!.noMemberCoin!;
      // }

      product!.varient = varient;
      // }
      if (quantity > 0) {
        ProductOrder cartRow = ProductOrder.fromMap({
          'products': li.isNotEmpty
              ? (jsonDecode(li.toString()))
              : (jsonDecode(li.toString())),
          'product': product != null ? (jsonDecode(product.toJson())) : null,
          'count': quantity,
          'ref': {'_id': refId, 'name': addedFrom},
          'ruleConfig': (jsonDecode(ruleConfig?.toJson() ?? "{}")),
          'constraint': (jsonDecode(constraint?.toJson() ?? "{}")),
          'productType': li.isNotEmpty ? null : product.type,
          'price': (jsonDecode(priceInfo!.toJson()) ?? "{}")
        });
        cartProductsScoins[refId] = cartRow;
      } else {
        removeProduct(refId, 'SCOIN');
        return;
      }
    } else {}
    await createOrder();
  }

  saveLaterCall() async {
    var customerInsightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    Customer cust =
        Customer.fromMap(customerInsightDetail as Map<String, dynamic>);
    List<dynamic> listSumm = [];
    for (var v in saveLaterProducts.values) {
      listSumm.add((jsonDecode(v.toJson())));
    }
    Ref custRef = await Helper.getCustomerRef();
    var payload;
    var resp;
    if (saveLaterId.value != '') {
      payload = {
        'customerRef': (jsonDecode(custRef.toJson())),
        'products': listSumm,
        '_id': saveLaterId.value,
        'metaData': (jsonDecode(cust.saveLater!.metaData!.toJson())),
      };
      // log(jsonEncode(payload).toString());
      resp = await ClientService.Put(
          path: 'saveLater', id: saveLaterId.value, payload: payload);
    } else {
      payload = {
        'customerRef': (jsonDecode(custRef.toJson())),
        'products': listSumm,
      };
      resp = await ClientService.post(path: 'saveLater', payload: payload);
    }
    if (resp.statusCode == 200) {
      if (saveLaterId.value == '') saveLaterId.value = resp.data['_id'];
      cust.saveLater = Order.fromMap(resp.data);
      OfflineDBService.save(
          OfflineDBService.customerInsightDetail, (jsonDecode(cust.toJson())));
    } else {
      print('TODO');
    }
  }

  createSaveLater(cartRow, refId) async {
    var customerInsightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    if (customerInsightDetail['_id'] == null) {
      // var getData = cartProducts[refId];
      saveLaterProducts[refId] = cartRow;
    } else {}
    await saveLaterCall();
    await removeProduct(refId, '');
  }

  createOrder() async {
    List<dynamic> listSumm = [];
    List<dynamic> listScoins = [];
    List<dynamic> listMsd = [];
    var insightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    Customer cust = Customer.fromMap(insightDetail as Map<String, dynamic>);
    for (var v in cartProducts.values) {
      listSumm.add((jsonDecode(v.toJson())));
    }
    for (var v in cartProductsScoins.values) {
      listScoins.add((jsonDecode(v.toJson())));
    }
    for (var v in msdProducts.values) {
      listMsd.add((jsonDecode(v.toJson())));
    }
    if (listScoins.length > 0 && listSumm.length > 0) {
      selectedPaymentMethod.value = 'MOLLIE_PLUS_SCOINS';
    } else if (listScoins.length > 0) {
      selectedPaymentMethod.value = 'SCOINS';
    } else if (listSumm.length > 0) {
      selectedPaymentMethod.value = 'MOLLIE';
    }
    Ref custRef = await Helper.getCustomerRef();
    var payload;
    var resp;
    if (cust.cart != null && cust.cart!.id != null) {
      payload = {
        'status': 'TEMPORARY_OR_CART',
        'customerRef': (jsonDecode(custRef.toJson())),
        'products': listSumm,
        'productsViaSCoins': listScoins,
        'msdApplicableProducts': listMsd,
        '_id': cust.cart!.id!,
        'metaData': (jsonDecode(cust.cart!.metaData!.toJson())),
        "payment": {
          "paidBy": (jsonDecode(custRef.toJson())),
          "order": {"name": custRef.id, "_id": cust.cart!.id!},
          "currency": "EUR",
          "paidTo": {"name": "sbazar", "_id": "sbazar"},
          "status": "OPEN",
          "description": cust.cart!.id!,
          "paymentGateWayDetail": {
            "usedPaymentGateWay": selectedPaymentMethod.value,
          },
          "appliedCouponCode": selectedCoupon.value.couponCode != null
              ? {
                  "name": selectedCoupon.value.couponCode,
                  "_id": selectedCoupon.value.id
                }
              : null,
        },
      };
      resp = await ClientService.Put(
          path: 'order', id: cust.cart!.id!, payload: payload);
    } else {
      payload = {
        'status': 'TEMPORARY_OR_CART',
        'customerRef': (jsonDecode(custRef.toJson())),
        'products': listSumm,
        'productsViaSCoins': listScoins,
        'msdApplicableProducts': listMsd,
        "payment": {
          "paidBy": (jsonDecode(custRef.toJson())),
          "order": {"name": custRef.id, "_id": orderId.value},
          "currency": "EUR",
          "paidTo": {"name": "sbazar", "_id": "sbazar"},
          "status": "OPEN",
          "description": orderId.value,
          "paymentGateWayDetail": {
            "usedPaymentGateWay": selectedPaymentMethod.value,
          },
          "appliedCouponCode": selectedCoupon.value.couponCode != null
              ? {
                  "name": selectedCoupon.value.couponCode,
                  "_id": selectedCoupon.value.id
                }
              : null,
        },
      };
      resp = await ClientService.post(path: 'order', payload: payload);
    }
    // dev.log(jsonEncode(resp.data).toString());
    if (resp.statusCode == 200) {
      if (orderId.value == '') orderId.value = resp.data['_id'];
      cust.cart = Order.fromMap(resp.data);
      calculatedPayment.value = cust.cart!.payment!;
      OfflineDBService.save(
          OfflineDBService.customerInsightDetail, (jsonDecode(cust.toJson())));
    } else {
      print('TODO');
    }
  }

  bool checkProductInCart(key, type) {
    if (type == 'SCOIN') {
      if (cartProductsScoins[key] != null) {
        return true;
      } else {
        return false;
      }
    }
    if (type == 'MSD') {
      if (msdProducts[key] != null) {
        return true;
      } else {
        return false;
      }
    } else {
      if (cartProducts[key] != null) {
        return true;
      } else {
        return false;
      }
    }
  }

  int getCurrentQuantity(key, type) {
    if (type == 'SCOIN') {
      if (cartProductsScoins[key] != null) {
        return cartProductsScoins[key]!.count!;
      } else {
        return 0;
      }
    } else if (type == 'MSD') {
      if (msdProducts[key] != null) {
        return msdProducts[key]!.count!;
      } else {
        return 0;
      }
    } else {
      if (cartProducts[key] != null) {
        return cartProducts[key]!.count!;
      } else {
        return 0;
      }
    }
  }

  checktOrderRefAvailable(Ref? ref) {
    bool available = true;
    print(checkoutData.value);
    if (checkoutData.value != null &&
        checkoutData.value!.orderProductAvailabilityStatus!.isNotEmpty) {
      checkoutData.value!.orderProductAvailabilityStatus!.forEach((elem) {
        // var data = elem;
        if (elem.ref!.id == ref!.id) {
          if (elem.productAvailabilityStatus != null) {
            available = elem.productAvailabilityStatus!.available ?? true;
          } else if (elem.productsAvailabilityStatus!.isNotEmpty) {
            for (var element in elem.productsAvailabilityStatus!) {
              if (available) {
                available = element.available ?? true;
              }
            }
          }
        }
      });
    }
    return available;
  }

  OrderProductAvailabilityStatus getRecommendedProd(Ref? ref) {
    var data = OrderProductAvailabilityStatus();
    if (checkoutData.value != null) {
      for (var elem in checkoutData.value!.orderProductAvailabilityStatus!) {
        if (elem.ref!.id == ref!.id) {
          data = elem;
        }
      }
    }
    return data;
  }

  setSearchVal(val) {
    couponName.value = (val);
  }

  getsearchData(query) async {
    var payload = {'keywords': query, "active": true};
    var response =
        await ClientService.post(path: 'couponCode/search', payload: payload);
    if (response.statusCode == 200) {
      List<CouponCode> cList = ((response.data as List<dynamic>?)
              ?.map((e) => CouponCode.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      searchCouponList.value = (cList);
    }
  }

  searchCoupon(String name) {
    return null;
  }

  isApplicableCoupun(CouponCode coupon) async {
    bool valid = true;
    // if (Get.isRegistered<CartController>()) {
    //   var cartController =
    //       ControllerGenerator.create(CartController(), tag: 'cartController');

    if (coupon.condition!.expireAtTime != null && valid) {
      String expire = coupon.condition!.expireAtTime ?? '';
      var newDate = DateTime.now().toUtc();
      var difference = DateTime.parse(expire).difference(newDate);
      if (difference.isNegative) {
        valid = false;
      }
    }
    if (coupon.condition!.maxCartAmount != null && valid) {
      if (calculatedPayment.value.totalAmount <=
          coupon.condition!.maxCartAmount) {
        valid = false;
      }
    }
    if (coupon.condition!.applicableForProfileRef != null) {
      Ref custRef = await Helper.getCustomerRef();
      if (coupon.condition!.applicableForProfileRef?.id != custRef.id) {
        valid = false;
      }
    }
    if (coupon.condition!.firstTimePurchase != null && valid) {
      // Ref custRef = await Helper.getCustomerRef();
      var customerInsightDetail =
          await OfflineDBService.get(OfflineDBService.customerInsightDetail);
      if (coupon.condition!.firstTimePurchase == true &&
          customerInsightDetail['orders'] != null &&
          customerInsightDetail['orders'].length != null) {
        valid = false;
      }
    }
    if (coupon.reward!.discountUptos != null && valid) {
      if (coupon.reward!.discountUptos <= calculatedPayment.value.totalAmount) {
        valid = false;
      }
    }

    return valid;
  }
}
