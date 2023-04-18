import 'package:amber_bird/data/price/price.dart';
import 'package:amber_bird/data/product/product.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class OpenContainerProduct extends StatelessWidget {
  const OpenContainerProduct(
      {Key? key,
      required this.child,
      required this.product,
      this.refId,
      this.addedFrom,
      this.dealPrice})
      : super(key: key);

  final Widget child;
  final Product? product;
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
        return const SizedBox();
        // ProductDetailScreen(product, refId!, addedFrom!);
      },
    );
  }
}
