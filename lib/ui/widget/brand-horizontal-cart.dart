import 'package:amber_bird/data/brand/brand.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/shimmer-widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../../controller/brand-page-controller.dart';
import '../../helpers/controller-generator.dart';
import '../../utils/ui-style.dart';

class BrandHorizontalCard extends StatelessWidget {
  late BrandPageController brandPageController;
  BrandHorizontalCard({Key? key}) : super(key: key) {
    brandPageController = ControllerGenerator.create(BrandPageController());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => brandPageController.isLoading.value
        ? ShimmerWidget(heightOfTheRow: 180, radiusOfcell: 12, widthOfCell: 150)
        : Container(
            color: AppColors.off_red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    "Find your favourite brand",
                    style: TextStyles.titleLargeSemiBold,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 140,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return _brandCard(
                          brandPageController.brands[index], context);
                    },
                    itemCount: brandPageController.brands.length,
                  ),
                ),
              ],
            ),
          ));
  }

  Widget _brandCard(Brand brand, BuildContext context) {
    return InkWell(
      onTap: () {
        Modular.to.pushNamed('/home/brandProduct/${brand.id}');
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ImageBox(
                brand.logoId!,
                width: 100,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              '${brand.name}',
              style: TextStyles.bodyFont,
            )
          ],
        ),
      ),
    );
  }
}
