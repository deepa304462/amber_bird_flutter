import 'package:amber_bird/ui/pages/product_detail_screen.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final String productId;
  bool search = false;
  ProductPage(
    this.productId, {
    Key? key,
    required bool search,
  });

  @override
  Widget build(BuildContext context) {
    return ProductDetailScreen(productId, productId, 'SEARCH');
  }
}
