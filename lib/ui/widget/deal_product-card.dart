import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/open_container_wrapper.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DealProductCard extends StatefulWidget {
  DealProductCard({Key? key}) : super(key: key);

  @override
  State<DealProductCard> createState() => _DealProductCardState();
}

class _DealProductCardState extends State<DealProductCard> {
  final Controller myController = Get.put(Controller(), tag: 'mycontroller');
  Widget _gridItemBody(DealProduct product) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(15,15,15,0),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E6E8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.network(
              '${ClientService.cdnUrl}${product.product!.images![0]}',
              // width: 80,
              // height: 80,
              fit: BoxFit.cover
              // scale: 3,
              ),
          // Image.asset(
          //   product.product!.images![0],
          //   scale: 3,
          // ),
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
    return Padding(
      padding: const EdgeInsets.only(left: 15,right: 15),
      child: Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
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
            const SizedBox(height: 5),
            Row(
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
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: GridView.builder(
            itemCount: myController.dealProd.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 10 / 12,
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            itemBuilder: (_, index) {
              DealProduct dProduct = myController.dealProd[index];
              return Container(
                // height: 100,
                // width: 100,
                child: OpenContainerWrapper(
                    child: GridTile(
                      header: _gridItemHeader(dProduct, index),
                      // footer: _gridItemFooter(dProduct, context),
                      child: _gridItemBody(dProduct),
                    ),
                    product: myController.dealProd[index].product),
              );
            },
          ),
        );
      },
    );
  }
}
