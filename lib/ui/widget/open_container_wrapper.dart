import 'package:amber_bird/data/deal_product/product.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../pages/product_detail_screen.dart';

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper(
      {Key? key, required this.child, required this.product})
      : super(key: key);

  final Widget child;
  final ProductSummary? product;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))),
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 850),
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return InkWell(
          onTap: openContainer,
          child: child,
        );
      },
      openBuilder: (BuildContext context, VoidCallback _) {
        return ProductDetailScreen(product);
      },
    );
  }
}
