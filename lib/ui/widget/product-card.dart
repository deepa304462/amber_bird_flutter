import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductSummary product;
  ProductCard(this.product, {super.key});


  Widget _gridItemBody(ProductSummary product, BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E6E8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.network(
              '${ClientService.cdnUrl}${product!.images![0]}',
              height: 150,
              fit: BoxFit.cover),
        ),
        _gridItemFooter(product, context)
      ],
    );
  }

  Widget _gridItemHeader(ProductSummary product, int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: true,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: Colors.white),
              width: 80,
              height: 30,
              alignment: Alignment.center,
              child: const Text(
                "2hrs left",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              // color: myController.filteredProducts[index].isLiked
              //     ? Colors.redAccent
              //     : const Color(0xFFA6A3A0),
            ),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }

  Widget _gridItemFooter(ProductSummary product, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      height: 55,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Text(
              product!.name!.defaultText!.text ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text(
                // product.dealPrice!.offerPrice != null
                //     ? "\$${product.dealPrice!.actualPrice}"
                //     : "\$${product.dealPrice!.offerPrice}",
                //  style: TextStyles.bodyFont,
              // ),
              const SizedBox(width: 3),
              // Visibility(
              //   visible: product.dealPrice!.offerPrice != null ? true : false,
              //   child: Text(
              //     "\$${product.dealPrice!.offerPrice.toString()}",
              //     style: const TextStyle(
              //       decoration: TextDecoration.lineThrough,
              //       color: Colors.grey,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              Spacer(),
              Icon(Icons.add)
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}