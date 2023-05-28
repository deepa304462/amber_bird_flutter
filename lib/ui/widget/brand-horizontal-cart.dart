import 'package:amber_bird/data/brand/brand.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/shimmer-widget.dart';
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
    List<Brand> shuffledBrands = [];
    return Obx(() {
      if (!brandPageController.isLoading.value) {
        shuffledBrands = List.from(brandPageController.brands);
        shuffledBrands.shuffle();
      }
      return brandPageController.isLoading.value
          ? ShimmerWidget(
              heightOfTheRow: 180, radiusOfcell: 12, widthOfCell: 150)
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
                      style: TextStyles.headingFont,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (index == 19) {
                          return InkWell(
                            onTap: () {
                              Modular.to.navigate('/home/brand');
                              //  Modular.to.pushReplacementNamed('/home/brand');
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                          child: Text(
                                        'View all brands',
                                        style: TextStyles.bodyFont,
                                        textAlign: TextAlign.center,
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return _brandCard(shuffledBrands[index], context);
                      },
                      itemCount: 20,
                    ),
                  ),
                ],
              ),
            );
    });
  }

  Widget _brandCard(Brand brand, BuildContext context) {
    return InkWell(
      onTap: () {
        Modular.to.pushNamed('/widget/brandProduct/${brand.id}');
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ImageBox(
                key: Key(brand.logoId!),
                brand.logoId!,
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              '${brand.name}',
              style: TextStyles.body,
            )
          ],
        ),
      ),
    );
  }
}
