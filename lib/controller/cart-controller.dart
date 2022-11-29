import 'dart:convert';
import 'dart:developer';

import 'package:amber_bird/data/checkout/checkout.dart';
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

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  applyCoupon() {}

  checkout() async {
    List<dynamic> listSumm = [];
    Price pr = Price.fromMap({'actualPrice': 0, 'offerPrice': 0});
    for (var v in cartProducts.value.values) {
      pr.actualPrice += v.price!.actualPrice;
      pr.offerPrice += v.price!.actualPrice;
      listSumm.add((jsonDecode(v.toJson())));
    }
    totalPrice.value = pr;
    Ref custRef = await Helper.getCustomerRef();

    var payload = {
      'status': 'CREATED',
      'customerRef': (jsonDecode(custRef.toJson())),
      'products': listSumm
    };
    var resp1 = await ClientService.post(path: 'order', payload: payload);
    if (resp1.statusCode == 200) {
      OrderId.value = resp1.data['_id'];
      log(jsonEncode(resp1.data).toString());
      var resp =
          await ClientService.post(path: 'order/checkout', payload: resp1.data);
      log(jsonEncode(resp.data).toString());
      if (resp.statusCode == 200) {
        log(resp.data.toString());
        Checkout data = Checkout.fromMap(resp.data);
        checkoutData.value = data;
      }
    }
  }

  clearCheckout() {
    checkoutData.value = null;
  }

  createPayment() async {
    double total = 0.0;
    List<dynamic> listSumm = [];
    for (var v in cartProducts.value.values) {
      total += v.price!.offerPrice;
      listSumm.add((jsonDecode(v.toJson())));
    }
    Ref custRef = await Helper.getCustomerRef();

    var payload1 = {
      'status': 'CREATED',
      'customerRef': (jsonDecode(custRef.toJson())),
      'products': listSumm
    };
    var resp1 = await ClientService.post(path: 'order', payload: payload1);
    if (resp1.statusCode == 200) {
      OrderId.value = resp1.data['_id'];
      var payload = {
        "paidBy": (jsonDecode(custRef.toJson())),
        "order": {"name": "md", "_id": resp1.data['_id']},
        // "appliedCouponCode": {"name": "string", "_id": "string"},
        "discountAmount": 0,
        "totalAmount": total,
        "paidAmount": total,
        "currency": "USD",
        // "currency": {"currencyCode": "USD"},
        "status": "OPEN",
        "appliedTaxAmount": 0,
        "description": resp1.data['_id']
      };
      log(payload.toString());

      var resp = await ClientService.post(path: 'payment', payload: payload);
      if (resp.statusCode == 200) {
        paymentData.value = Payment.fromMap(resp.data as Map<String, dynamic>);
        log(resp.data.toString());
        return ({'error': false, 'data': resp.data['checkoutUrl']});
      } else {
        return ({'error': true, 'data': ''});
      }
    }
  }

  paymentStatusCheck() async {
    var resp = await ClientService.get(
        path: 'payment/mollie/getPayment', id: paymentData.value!.id);
    if (resp.statusCode == 200) {
      paymentData.value = Payment.fromMap(resp.data as Map<String, dynamic>);
      log(resp.data.toString());
      resetCart();
      // resetCart();
      return ({'error': false, 'data': resp.data});
    } else {
      return ({'error': true, 'data': ''});
    }
  }

  removeProduct(currentKey) async {
    cartProducts.remove(currentKey);
    //  var insightDetail =
    //       await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    //   log(insightDetail.toString());
    //   Customer cust = Customer.fromMap(insightDetail as Map<String, dynamic>);
    //   cust.cart = Order.fromMap(resp.data);
    //   log(cust.toString());
    //   OfflineDBService.save(
    //       OfflineDBService.customerInsightDetail, (jsonDecode(cust.toJson())));
    createOrder();
  }

  resetCart() async {
    cartProducts.clear();
    var insightDetail =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    log(insightDetail.toString());
    Customer cust = Customer.fromMap(insightDetail as Map<String, dynamic>);
    cust.cart = null;
    log(cust.toString());
    OfflineDBService.save(
        OfflineDBService.customerInsightDetail, (jsonDecode(cust.toJson())));
  }

  fetchCart() async {
    var insightDetailloc =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    if (insightDetailloc != null) {
      Customer cust = Customer.fromMap(
          (jsonDecode(jsonEncode(insightDetailloc))) as Map<String, dynamic>);
      log(cust.toString());
      if (cust.cart != null) {
        Price pr = Price.fromMap({'actualPrice': 0, 'offerPrice': 0});
        for (var element in cust.cart!.products!) {
          cartProducts[element.ref!.id ?? ''] = element;
          pr.actualPrice += element.price!.actualPrice;
          pr.offerPrice += element.price!.actualPrice;
        }

        totalPrice.value = pr;
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
            price = price + element.varient!.price!.offerPrice * quantity;
          } else {
            price = price + element.varient!.price!.offerPrice * quantity;
          }
        }
      } else {
        if (getData != null) {
          quantity = getData.count!;
          quantity = quantity + addQuantity;
          price = price * quantity;
        }
      }
      log(li.toString());
      ProductOrder cartRow = ProductOrder.fromMap({
        'products': li.isNotEmpty
            ? (jsonDecode(li.toString()))
            : (jsonDecode(li.toString())),
        'product': product != null ? (jsonDecode(product.toJson())) : null,
        'count': quantity,
        'ref': {'_id': refId, 'name': null},
        'productType': addedFrom,
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
    createOrder();
  }

  createOrder() async {
    List<dynamic> listSumm = [];
    for (var v in cartProducts.value.values) {
      listSumm.add((jsonDecode(v.toJson())));
    }
    Ref custRef = await Helper.getCustomerRef();
    var payload = {
      'status': 'TEMPORARY_OR_CART',
      'customerRef': (jsonDecode(custRef.toJson())),
      'products': listSumm
    };
    //(jsonDecode(cart.toJson()));
    log(payload.toString());
    var resp = await ClientService.post(path: 'order', payload: payload);
    if (resp.statusCode == 200) {
      OrderId.value = resp.data['_id'];
      log(resp.data.toString());
      //  update Cart
      var insightDetail =
          await OfflineDBService.get(OfflineDBService.customerInsightDetail);
      log(insightDetail.toString());
      Customer cust = Customer.fromMap(insightDetail as Map<String, dynamic>);
      cust.cart = Order.fromMap(resp.data);
      log(cust.toString());
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
}
