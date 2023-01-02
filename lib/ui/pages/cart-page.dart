import 'package:amber_bird/ui/widget/cart/save-later-widget.dart';
import 'package:flutter/material.dart';

import '../widget/cart/cart-widget.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .7,
        child: Column(children: [CartWidget(), SaveLater()]),
      ),
    );
  }
}
