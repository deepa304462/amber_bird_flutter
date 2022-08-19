import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/deal-controller.dart';
import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/open_container_wrapper.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DealProductCard extends StatelessWidget {
    final CartController cartController = Get.find();

  final DealController con;
  DealProductCard(this.con, {super.key});
  Widget _gridItemBody(DealProduct product, BuildContext context) {
    return Column(
      children: [
        OpenContainerWrapper(
          product: product.product,
          child: Image.network(
              '${ClientService.cdnUrl}${product.product!.images![0]}',
               
              fit: BoxFit.fill
              ),
        ),
        _gridItemFooter(product, context)
      ],
    );
  }

  Widget _gridItemHeader(DealProduct product, int index) {
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

  Widget _gridItemFooter(DealProduct product, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      // margin: const EdgeInsets.only(left: 3, right: 3),
      height: 55,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10),
              bottomRight: Radius.circular(10))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Text(
              product.product!.name!.defaultText!.text ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.dealPrice!.offerPrice != null
                    ? "\$${product.dealPrice!.actualPrice}"
                    : "\$${product.dealPrice!.offerPrice}",
                style: TextStyles.bodyFont,
              ),
              const SizedBox(width: 3),
              Visibility(
                visible: product.dealPrice!.offerPrice != null ? true : false,
                child: Text(
                  "\$${product.dealPrice!.offerPrice.toString()}",
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Spacer(),
              IconButton(
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
                onPressed: () {
                  cartController.addToCart(product!.product);
                },
                icon: const Icon(Icons.add, color: Colors.black),
              ), 
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: con.dealProd.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 14.5 / 11,
              crossAxisSpacing: 10),
          itemBuilder: (_, index) {
            DealProduct dProduct = con.dealProd[index];
            return Padding(
              padding: const EdgeInsetsDirectional.all(5),
              child: ClipRRect(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                borderRadius: BorderRadius.circular(15.0),
                child: GridTile(
                  header: _gridItemHeader(dProduct, index),
                  child: _gridItemBody(dProduct, context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
