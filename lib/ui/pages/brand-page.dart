import 'package:amber_bird/controller/brand-page-controller.dart';
import 'package:amber_bird/data/brand/brand.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/loading-with-logo.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class BrandPage extends StatelessWidget {
  late BrandPageController brandPageController;
  BrandPage({Key? key}) : super(key: key) {
    brandPageController = ControllerGenerator.create(BrandPageController());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => brandPageController.isLoading.value
        ? Center(child: LoadingWithLogo())
        : MasonryGridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            physics: const BouncingScrollPhysics(),
            itemCount: brandPageController.brands.length,
            itemBuilder: (_, index) {
              return _brandTile(brandPageController.brands[index]);
            },
          ));
  }

  Widget _brandTile(Brand brand) {
    return InkWell(
      onTap: () {
        Modular.to.navigate('/home/brandProduct/${brand.id}');
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ImageBox(
                brand.logoId!,
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
              Text(
                '${brand.name}',
                style: TextStyles.bodyFont,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
