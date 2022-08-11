import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  String word = '';
  bool search = false;
  ProductPage({Key? key, required bool search, required word})
      : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    print('hiiiiiiiiii${widget.word}');
    if (widget.word.isNotEmpty) {
      getProduct();
    }
    super.initState();
  }

  getProduct() {}

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    print('arrrrrrrrrrrrrrrrr${args}');
    return Container(
      child: Text('Product page'),
    );
  }
}
