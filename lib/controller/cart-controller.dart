import 'dart:convert';
import 'dart:developer';

import 'package:amber_bird/data/customer/customer.insight.detail.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/order/order.dart';
import 'package:amber_bird/data/order/product_order.dart';
import 'package:amber_bird/data/profile/ref.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  // RxMap<String, CartProduct> cartProducts = <String, CartProduct>{}.obs;
  // RxMap<String, Order> cartProducts = <String, Order>{}.obs;
  RxMap<String, ProductOrder> cartProducts = <String, ProductOrder>{}.obs;
  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  fetchCart() async {
    var insightDetailloc =
        await OfflineDBService.get(OfflineDBService.customerInsightDetail);
    Customer cust = Customer.fromMap(
        (jsonDecode(jsonEncode(insightDetailloc))) as Map<String, dynamic>);
    log(cust.toString());
    if (cust.cart != null) {
      cust.cart!.products!.forEach((element) {
        cartProducts[element!.ref!.id ?? ''] = element;
      });
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
      if (getData != null) {
        quantity = getData!.count!;
        quantity = quantity + addQuantity!;
        price = price * quantity;
      }
      List<ProductSummary> li = [];
      if (products != null) {
        li.addAll(products!);
      }
      inspect(product);

      ProductOrder cartRow = ProductOrder.fromMap({
        'products': (jsonDecode(li.toString())),
        'product': (jsonDecode(product!.toJson())),
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
    cartProducts.value.values.forEach((v) {
      listSumm.add((jsonDecode(v.toJson())));
    });
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
