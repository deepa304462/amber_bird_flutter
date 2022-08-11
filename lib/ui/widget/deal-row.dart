import 'dart:developer';

import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/deal_product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class DealRow extends StatefulWidget {
  String CurrentdealName = '';

  DealRow(dealName CurrentdealName, {Key? key}) : super(key: key);

  @override
  State<DealRow> createState() => _DealRowState();
}

class _DealRowState extends State<DealRow> {
  bool isLoading = false;
  RxList<DealProduct> dealProd = <DealProduct>[].obs;
  final Controller myController = Get.put(Controller(), tag: 'mycontroller');
  @override
  initState() {
    getDealList();
    super.initState();
  }

  getDealList() async {
    // if (widget.CurrentdealName.isNotEmpty) {
    setState(() {
      isLoading = true;
    });

    var payload = {"type": widget.CurrentdealName};
    var response = await ClientService.searchQuery(
        path: 'cache/dealProduct/search', query: payload, lang: 'en');

    if (response.statusCode == 200) {
      print(response.data);
      dealProd = RxList((response.data as List<dynamic>?)
              ?.map((e) => DealProduct.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      myController.setDealProd(dealProd);
    } else {
      inspect(response);
    }

    setState(() {
      isLoading = false;
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return dealProd.isNotEmpty
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.CurrentdealName,
                      style: TextStyles.headingFont,
                    ),
                    TextButton(
                      onPressed: () {
                        // Modular.to.navigate('/category');
                        setState(() {
                          dealProd = dealProd;
                        });
                      },
                      child: Text(
                        "SEE ALL",
                        style: TextStyles.subHeadingFont,
                      ),
                    )
                  ],
                ),
              ),
              // GetX<Controller>(
              //   init: myController,
              //   //initState: (state) =>state.controller!.reviewIds = resultModel.reviews,
              //   builder: (mController) {
              //     if (dealProd.isNotEmpty) {
              //       return ListView.builder(
              //         padding: const EdgeInsets.symmetric(vertical: 10),
              //         shrinkWrap: true,
              //         scrollDirection: Axis.horizontal,
              //         itemCount: dealProd.length,
              //         itemBuilder: (_, index) {
                 SizedBox(height:600,child:DealProductCard())
                //       },
                //     );
                //   } else {
                //     return SizedBox();
                //   }
                // },
              // ),
            ],
          )
        : SizedBox();
  }
}
