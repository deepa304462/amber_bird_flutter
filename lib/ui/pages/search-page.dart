import 'package:flutter/material.dart';

import '../widget/cart/cart-widget.dart';

class SearchPage extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    print('arrrrrrrrrrrrrrrrr${args}');
    return Column(children: [Text('')]);
  }
}
