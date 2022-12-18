import 'dart:convert';
import 'dart:developer';

import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/checkout/checkout.dart';
import 'package:amber_bird/data/checkout/order_product_availability_status.dart';
import 'package:amber_bird/data/coupon_code/coupon_code.dart';
import 'package:amber_bird/data/customer/customer.insight.detail.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/order/order.dart';
import 'package:amber_bird/data/payment/payment.dart';
import 'package:amber_bird/data/order/product_order.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  RxMap<String, ProductOrder> cartProducts = <String, ProductOrder>{}.obs;
  final checkoutData = Rxn<Checkout>();
  final paymentData = Rxn<Payment>();
  RxString OrderId = "".obs;
  Rx<Price> totalPrice = Price.fromMap({}).obs;
  Rx<Payment> calculatedPayment = Payment.fromMap({}).obs;

  var couponName = ''.obs;
  RxList<CouponCode> searchCouponList = <CouponCode>[].obs;
  Rx<CouponCode> selectedCoupon = CouponCode().obs;
  Rx<bool> searchingProduct = true.obs;
  Rx<bool> couponIncludeCondition = false.obs;

  @override
  void onInit() {
    super.onInit();
    // resetCart();
    fetchCart();
  }

  applyCoupon() {}

  checkout() async {
    List<dynamic> listSumm = [];
    // calculateTotalCost();
    for (var v in cartProducts.value.values) {
      listSumm.add((jsonDecode(v.toJson())));
    }
    var selectedAdd;
    if (Get.isRegistered<LocationController>()) {
      var locationController = Get.find<LocationController>();
      selectedAdd = locationController.addressData.value;
    }
    Ref custRef = await Helper.getCustomerRef();
    var insightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    Customer cust = Customer.fromMap(insightDetail as Map<String, dynamic>);
    var payload;
    var resp = await ClientService.post(
        path: 'order/checkout', payload: (jsonDecode((cust.cart!.toJson()))));
    if (resp.statusCode == 200) {
      // log(jsonEncode(resp.data).toString());
      Checkout data = Checkout.fromMap(resp.data);
      checkoutData.value = data;

      if (data.allAvailable == true) {
        if (selectedCoupon.value.id != null) {
          payload = {
            'status': 'CREATED',
            'customerRef': (jsonDecode(custRef.toJson())),
            'products': listSumm,
            "payment": {
              "paidBy": (jsonDecode(custRef.toJson())),
              "order": {"name": custRef.id, "_id": OrderId.value},
              "currency": "EUR",
              "paidTo": {"name": "sbazar", "_id": "sbazar"},
              "status": "OPEN",
              "description": OrderId.value,
              selectedCoupon.value != null
                  ? "appliedCouponCode"
                  : {
                      "name": selectedCoupon.value.couponCode,
                      "_id": selectedCoupon.value.id
                    }: null,
            },
            '_id': OrderId.value,
            'metaData': (jsonDecode(cust.cart!.metaData!.toJson())),
            'shipping': {
              'destination': {
                'customerAddress': (jsonDecode(selectedAdd.toJson())),
              }
            }
          };
        } else {
          payload = {
            'status': 'CREATED',
            'customerRef': (jsonDecode(custRef.toJson())),
            'products': listSumm,
            "payment": {
              "paidBy": (jsonDecode(custRef.toJson())),
              "order": {"name": custRef.id, "_id": OrderId.value},
              "currency": "EUR", //{"currencyCode": "USD"},
              "paidTo": {"name": "sbazar", "_id": "sbazar"},
              "status": "OPEN",
              "description": OrderId.value,
              "appliedCouponCode": selectedCoupon.value.couponCode != null
                  ? {
                      "name": selectedCoupon.value.couponCode,
                      "_id": selectedCoupon.value.id
                    }
                  : null,
            },
            '_id': OrderId.value,
            'metaData': (jsonDecode(cust.cart!.metaData!.toJson())),
            'shipping': {
              'destination': {
                'customerAddress': (jsonDecode(selectedAdd.toJson())),
              }
            }
          };
        }

        log(jsonEncode(payload).toString());
        var resp1;
        if (OrderId.value != '') {
          resp1 = await ClientService.Put(
              path: 'order', id: OrderId.value, payload: payload);
        } else {
          resp1 = await ClientService.post(path: 'order', payload: payload);
        }

        if (resp1.statusCode == 200) {
          if (OrderId.value == '') OrderId.value = resp1.data['_id'];

          cust.cart = Order.fromMap(resp1.data);
          calculatedPayment.value = cust.cart!.payment!;
          OfflineDBService.save(OfflineDBService.customerInsightDetail,
              (jsonDecode(cust.toJson())));
        }
      }
    }
  }

  clearCheckout() {
    checkoutData.value = null;
  }

  calculateTotalCost() {
    Price pr = Price.fromMap({'actualPrice': 0, 'offerPrice': 0});
    for (var v in cartProducts.value.values) {
      pr.actualPrice += v.price!.actualPrice;
      pr.offerPrice += v.price!.actualPrice;
    }
    if (selectedCoupon.value != null) {
      var reward = selectedCoupon.value.reward;
      if (reward?.discountUptos != null) {
        pr.offerPrice -= reward?.discountUptos;
      } else if (reward?.flatDiscount != null) {
        pr.offerPrice -= reward?.discountUptos;
      } else if (reward?.discountPercent != null) {
        var disc = (pr.offerPrice * reward?.discountPercent) / 100;
        pr.offerPrice -= disc;
      }
    }
    totalPrice.value = pr;
  }

  createPayment() async {
    double total = 0.0;
    List<dynamic> listSumm = [];
    for (var v in cartProducts.value.values) {
      total += v.price!.offerPrice;
      listSumm.add((jsonDecode(v.toJson())));
    }
    Ref custRef = await Helper.getCustomerRef();
    var insightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    Customer cust = Customer.fromMap(insightDetail as Map<String, dynamic>);
    var payload1;

    var resp1;
    // if (OrderId.value != '') {
    //   payload1 = {
    //     'status': 'CREATED',
    //     'customerRef': (jsonDecode(custRef.toJson())),
    //     'products': listSumm,
    //     '_id': OrderId.value,
    //     "payment": {
    //       "paidBy": (jsonDecode(custRef.toJson())),
    //       "order": {"name": custRef.id, "_id": OrderId.value},
    //       "currency": "EUR",
    //       "paidTo": {"name": "sbazar", "_id": "sbazar"},
    //       "status": "OPEN",
    //       "description": "",
    //       "appliedCouponCode": selectedCoupon.value.couponCode != null
    //           ? {
    //               "name": selectedCoupon.value.couponCode,
    //               "_id": selectedCoupon.value.id
    //             }
    //           : null,
    //     },
    //     'metaData': (jsonDecode(cust.cart!.metaData!.toJson()))
    //   };
    //   log(jsonEncode(payload1).toString());
    //   resp1 = await ClientService.Put(
    //       path: 'order', id: OrderId.value, payload: payload1);
    // } else {
    //   payload1 = {
    //     'status': 'CREATED',
    //     'customerRef': (jsonDecode(custRef.toJson())),
    //     'products': listSumm,
    //     "payment": {
    //       "paidBy": (jsonDecode(custRef.toJson())),
    //       "order": {"name": custRef.id, "_id": OrderId.value},
    //       "currency": "EUR",
    //       "paidTo": {"name": "sbazar", "_id": "sbazar"},
    //       "status": "OPEN",
    //       "description": "",
    //       "appliedCouponCode": selectedCoupon.value.couponCode != null
    //           ? {
    //               "name": selectedCoupon.value.couponCode,
    //               "_id": selectedCoupon.value.id
    //             }
    //           : null,
    //     },
    //   };
    //   log(jsonEncode(payload1).toString());
    //   resp1 = await ClientService.post(path: 'order', payload: payload1);
    // }
    // if (resp1.statusCode == 200) {
    var payload;
    var resp = await ClientService.post(
        path: 'order/checkout', payload: (jsonDecode((cust.cart!.toJson()))));
    if (resp.statusCode == 200) {
      // log(jsonEncode(resp.data).toString());
      Checkout data = Checkout.fromMap(resp.data);
      checkoutData.value = data;

      if (data.allAvailable == true) {
        var resp = await ClientService.post(
            path: 'payment/search', payload: {"orderId": OrderId.value});
        if (resp.statusCode == 200) {
          // log(jsonEncode(resp.data).toString());
          if (resp.data[0]) {
            paymentData.value =
                Payment.fromMap(resp.data[0] as Map<String, dynamic>);
            return ({'error': false, 'data': resp.data[0]['checkoutUrl']});
          } else {
            return ({'error': true, 'msg': 'Please try again in some time'});
          }
        } else {
          return ({'error': true, 'data': '', 'msg': 'Something went wrong!!'});
        }
      }
    }
  }

  paymentStatusCheck() async {
    var resp = await ClientService.get(
        path: 'payment/mollie/getPayment', id: paymentData.value!.id);
    if (resp.statusCode == 200) {
      paymentData.value = Payment.fromMap(resp.data as Map<String, dynamic>);
      // log(resp.data.toString());
      // resetCart();
      // resetCart();
      resetetCustomerDetail();
      return ({'error': false, 'data': resp.data});
    } else {
      return ({'error': true, 'data': ''});
    }
  }

  resetetCustomerDetail() async {
    if (Get.isRegistered<Controller>()) {
      var controller = Get.find<Controller>();
      var customerInsightDetail = await ClientService.post(
          path: 'customerInsight/detail',
          payload: {},
          payloadAsString: controller.tokenManagerEntityId.value);
      if (customerInsightDetail.statusCode == 200) {
        OfflineDBService.save(
            OfflineDBService.customerInsightDetail, customerInsightDetail.data);
      }
    }
  }

  removeProduct(currentKey) async {
    cartProducts.remove(currentKey);
    await createOrder();
  }

  resetCart() async {
    cartProducts.clear();
    var insightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    // log(insightDetail.toString());
    Customer cust = Customer.fromMap(insightDetail as Map<String, dynamic>);
    cust.cart = null;
    // log(cust.toString());
    await createOrder();
    OfflineDBService.save(
        OfflineDBService.customerInsightDetail, (jsonDecode(cust.toJson())));
  }

  fetchCart() async {
    var insightDetailloc =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    if (insightDetailloc != null) {
      Customer cust = Customer.fromMap(
          (jsonDecode(jsonEncode(insightDetailloc))) as Map<String, dynamic>);
      // log(cust.toString());
      if (cust.cart != null) {
        calculatedPayment.value =
            cust.cart!.payment != null ? cust.cart!.payment! : Payment();
        OrderId.value = cust.cart!.id ?? '';
        for (var element in cust.cart!.products!) {
          cartProducts[element.ref!.id ?? ''] = element;
        }
      }
    } else {
      cartProducts.value = Map();
    }
  }

  Future<void> addToCart(
    String refId,
    String addedFrom,
    int? addQuantity,
    Price? priceInfo,
    ProductSummary? product,
    List<ProductSummary>? products,
  ) async {
    var customerInsightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    if (customerInsightDetail['_id'] == null) {
      var getData = cartProducts[refId];
      int quantity = 0 + addQuantity!;
      double price = (priceInfo!.offerPrice).toDouble();
      List li = [];
      if (products != null) {
        price = 0;
        for (var element in products) {
          li.add(element.toJson());
          if (getData != null) {
            quantity = getData.count!;
            quantity = quantity + addQuantity;
            // price = price + element.varient!.price!.offerPrice * quantity;
            price = price + element.varient!.price!.offerPrice;
          } else {
            // price = price + element.varient!.price!.offerPrice * quantity;
            price = price + element.varient!.price!.offerPrice;
          }
        }
      } else {
        if (getData != null) {
          quantity = getData.count!;
          quantity = quantity + addQuantity;
          // price = price * quantity;
        }
      }
      // log(li.toString());
      ProductOrder cartRow = ProductOrder.fromMap({
        'products': li.isNotEmpty
            ? (jsonDecode(li.toString()))
            : (jsonDecode(li.toString())),
        'product': product != null ? (jsonDecode(product.toJson())) : null,
        'count': quantity,
        'ref': {'_id': refId, 'name': addedFrom},
        'productType': li.isNotEmpty ? null : product!.type,
        'price': {
          'actualPrice': price,
          'memberCoin': 0,
          'primeMemberCoin': 0,
          'goldMemberCoin': 0,
          'silverMemberCoin': 0,
          'offerPrice': price
        }
      });
      cartProducts[refId] = cartRow;
    } else {}
    await createOrder();
  }

  createOrder() async {
    List<dynamic> listSumm = [];
    var insightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    Customer cust = Customer.fromMap(insightDetail as Map<String, dynamic>);
    for (var v in cartProducts.value.values) {
      listSumm.add((jsonDecode(v.toJson())));
    }
    Ref custRef = await Helper.getCustomerRef();
    var payload;
    // = {
    //   'status': 'TEMPORARY_OR_CART',
    //   'customerRef': (jsonDecode(custRef.toJson())),
    //   'products': listSumm
    // };

    var resp; //= await ClientService.post(path: 'order', payload: payload);
    if (OrderId.value != '') {
      payload = {
        'status': 'TEMPORARY_OR_CART',
        'customerRef': (jsonDecode(custRef.toJson())),
        'products': listSumm,
        '_id': OrderId.value,
        'metaData': (jsonDecode(cust.cart!.metaData!.toJson())),
        "payment": {
          "paidBy": (jsonDecode(custRef.toJson())),
          "order": {"name": custRef.id, "_id": OrderId.value},
          "currency": "EUR",
          "paidTo": {"name": "sbazar", "_id": "sbazar"},
          "status": "OPEN",
          "description": OrderId.value,
        },
      };
      log(jsonEncode(payload).toString());
      resp = await ClientService.Put(
          path: 'order', id: OrderId.value, payload: payload);
    } else {
      payload = {
        'status': 'TEMPORARY_OR_CART',
        'customerRef': (jsonDecode(custRef.toJson())),
        'products': listSumm,
        "payment": {
          "paidBy": (jsonDecode(custRef.toJson())),
          "order": {"name": custRef.id, "_id": OrderId.value},
          "currency": "EUR",
          "paidTo": {"name": "sbazar", "_id": "sbazar"},
          "status": "OPEN",
          "description": OrderId.value,
        },
      };
      log(jsonEncode(payload).toString());
      resp = await ClientService.post(path: 'order', payload: payload);
    }
    if (resp.statusCode == 200) {
      if (OrderId.value == '') OrderId.value = resp.data['_id'];
      // log(resp.data.toString());
      //  update Cart
      // totalPrice.value.offerPrice = resp.data['payment']['paidAmount'];
      // totalPrice.value.actualPrice = resp.data['payment']['totalAmount'];

      cust.cart = Order.fromMap(resp.data);
      calculatedPayment.value = cust.cart!.payment!;
      // calculateTotalCost();
      // log(cust.toString());
      OfflineDBService.save(
          OfflineDBService.customerInsightDetail, (jsonDecode(cust.toJson())));
    } else {
      print('TODO');
    }
  }

  bool checkProductInCart(key) {
    if (cartProducts[key] != null) {
      return true;
    } else {
      return false;
    }
  }

  int getCurrentQuantity(key) {
    if (cartProducts[key] != null) {
      return cartProducts[key]!.count!;
    } else {
      return 0;
    }
  }

  checktOrderRefAvailable(Ref? ref) {
    bool available = true;
    print(checkoutData.value);
    if (checkoutData.value!.orderProductAvailabilityStatus!.isNotEmpty) {
      // for()
      checkoutData.value!.orderProductAvailabilityStatus!.forEach((elem) {
        var data = elem;
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
        // var data = elem;
        // arr.add({'label': data['label'], 'value': data['value']});
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
    var payload = {'keywords': query};
    var response =
        await ClientService.post(path: 'couponCode/search', payload: payload);

    if (response.statusCode == 200) {
      List<CouponCode> cList = ((response.data as List<dynamic>?)
              ?.map((e) => CouponCode.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      searchCouponList.value = (cList);

      // print(categoryList);
    }
  }

  isApplicableCoupun(CouponCode coupon) async {
    bool valid = true;
    if (Get.isRegistered<CartController>()) {
      var cartController = Get.find<CartController>();
      if (coupon.condition!.expireAtTime != null && valid) {
        String expire = coupon.condition!.expireAtTime ?? '';
        var newDate = DateTime.now().toUtc();
        var difference = DateTime.parse(expire).difference(newDate);
        if (difference.isNegative) {
          valid = false;
        }
      }
      if (coupon.condition!.maxCartAmount != null && valid) {
        if (cartController.calculatedPayment.value.totalAmount <=
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
        Ref custRef = await Helper.getCustomerRef();
        var customerInsightDetail =
            await OfflineDBService.get(OfflineDBService.customerInsightDetail);
        if (coupon.condition!.firstTimePurchase == true &&
            customerInsightDetail['orders'] != null &&
            customerInsightDetail['orders'].length != null) {
          valid = false;
        }
      }
      // else if (coupon.condition!.applicableForProfileRef != null) {
      //   if (Get.isRegistered<Controller>()) {
      //     var controller = Get.find<Controller>();
      //   }
      // }
      if (coupon.reward!.discountUptos != null && valid) {
        if (coupon.reward!.discountUptos <=
            cartController.calculatedPayment.value.totalAmount) {
          valid = false;
        }
      }
    }
    return valid;
  }
}
