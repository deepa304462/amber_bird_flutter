import 'package:flutter/material.dart';

import '../widget/cart/cart-widget.dart';

class CartPage extends StatelessWidget {
//   CartPage({Key? key}) : super(key: key);

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [CartWidget()]);
  }
}
