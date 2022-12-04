import 'package:amber_bird/controller/multi-product-controller.dart';
import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/bootom-drawer/deal-bottom-drawer.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiProductRow extends StatelessWidget {
  bool isLoading = false;
  final currenttypeName;

  MultiProductRow(this.currenttypeName, {super.key});

  @override
  Widget build(BuildContext context) {
    final MultiProductController multiprodController = Get.put(
        MultiProductController(currenttypeName),
        tag: currenttypeName.toString());
    // if (dealController.dealProd.isNotEmpty) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    multiprodController.getProductName(currenttypeName),
                    style: TextStyles.titleLargeBold,
                  ),
                  Text(
                    'More >',
                    style: TextStyles.headingFontBlue,
                  ),
                ],
              ),
            ),
          ),
          childListing(multiprodController, context)
        ],
      ),
    );
  }

  Widget childListing(
      MultiProductController multiprodController, BuildContext context) {
    if (currenttypeName == multiProductName.COMBO) {
      return twoProductListing(multiprodController, context);
    } else if (currenttypeName == multiProductName.COLLECTION ||
        currenttypeName == multiProductName.BUNDLE) {
      return multiProductListing(multiprodController, context);
    } else {
      return const Text('No implemented');
    }
  }

  Widget twoProductListing(
      MultiProductController multiprodController, BuildContext context) {
    return SizedBox(
      height: 340,
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: multiprodController.multiProd.length,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              Multi mProduct = multiprodController.multiProd[index];
              return Card(
                child: Column(
                  children: [
                    Image.network(
                      '${ClientService.cdnUrl}${mProduct.displayImageId}',
                      height: 80,
                    ),
                    Container(
                      margin: const EdgeInsets.all(5.0),
                      height: 160,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            for (var i = 0;
                                i < mProduct.products!.length;
                                i++) ...[
                              SizedBox(
                                width: 150,
                                child: ProductCard(
                                    mProduct.products![i],
                                    mProduct.products![i].id,
                                    'MULTIPRODUCT',
                                    mProduct.products![i].varient!.price!,
                                    null),
                              ),
                            ],
                          ]),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mProduct.name!.defaultText!.text ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: Row(
                                children: [
                                  PriceTag(
                                      mProduct.price!.offerPrice.toString(),
                                      mProduct.price!.actualPrice.toString()),
                                  const Spacer(),
                                  CircleAvatar(
                                    backgroundColor: Colors.red.shade900,
                                    radius: 20,
                                    child: IconButton(
                                      padding: const EdgeInsets.all(1),
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        showModalBottomSheet<void>(
                                          // context and builder are
                                          // required properties in this widget
                                          context: context,
                                          useRootNavigator: true,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13)),
                                          backgroundColor: Colors.white,
                                          isScrollControlled: true,
                                          elevation: 3,
                                          builder: (context) {
                                            return DealBottomDrawer(
                                                mProduct.products,
                                                mProduct.id,
                                                'MULTIPRODUCT',
                                                mProduct.price,
                                                mProduct.name);
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget multiProductListing(
      MultiProductController multiprodController, BuildContext context) {
    return SizedBox(
        height: 120,
        child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: multiprodController.multiProd.length,
            itemBuilder: (_, index) {
              return multiProductTile(
                  multiprodController.multiProd[index], context);
            })));
  }

  Widget multiProductTile(Multi multiProd, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                '${ClientService.cdnUrl}${multiProd.displayImageId}',
                fit: BoxFit.fill,
                height: 100,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${multiProd.name!.defaultText!.text}',
                      style: TextStyles.bodyPrimaryLarge),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PriceTag(multiProd.price!.offerPrice.toString(),
                          multiProd.price!.actualPrice.toString()),
                      const SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: AppColors.primeColor,
                        child: Text('BUY', style: TextStyles.bodyWhiteLarge),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
