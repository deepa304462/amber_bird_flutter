import 'package:amber_bird/data/deal_product/deal_price.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../pages/product_detail_screen.dart';

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper(
      {Key? key,
      required this.child,
      required this.product,
      this.refId,
      this.addedFrom,
      this.dealPrice})
      : super(key: key);

  final Widget child;
  final ProductSummary? product;
  final String? refId;
  final String? addedFrom;
  final Price? dealPrice;

  @override
  Widget build(BuildContext context) {
    if (addedFrom == 'DEAL') {
      // product!.varient!.price = dealPrice;
    }
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
        return ProductDetailScreen(product!.id!, refId!, addedFrom!);
      },
    );
  }
}
