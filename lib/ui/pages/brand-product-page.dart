import 'package:amber_bird/controller/brand-page-controller.dart';
import 'package:amber_bird/controller/brand-product-page-controller.dart';
import 'package:amber_bird/data/brand/brand.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/loading-with-logo.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class BrandProductPage extends StatelessWidget {
  final String id;
  late BrandProductPageController controller;
  BrandProductPage(this.id, {Key? key}) : super(key: key) {
    controller = ControllerGenerator.create(BrandProductPageController(),
        tag: 'brandProductController');
    controller.setBrandId(id);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const LoadingWithLogo()
          : Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.primeColor,
                leading: IconButton(
                    onPressed: () {
                      Modular.to.navigate('/home/brand');
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ImageBox(
                      '${controller.brand.value.logoId}',
                      width: 30,
                      fit: BoxFit.contain,
                      height: 30,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${controller.brand.value.name}',
                      style:
                          TextStyles.bodyFontBold.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              body: productList(context)),
    );
  }

  Widget brandInfo(Rx<Brand> brand, BuildContext context) {
    return Card(
        child: ListTile(
      leading: ImageBox(
        brand.value.logoId!,
        width: 100,
        height: 100,
      ),
      title: Text(
        brand.value.name!,
        style: TextStyles.titleLargeBold,
      ),
      subtitle: Text(
        brand.value.description!.defaultText!.text!,
        style: TextStyles.bodyFontBold,
      ),
    ));
  }

  productList(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      padding: const EdgeInsets.all(4),
      physics: const BouncingScrollPhysics(),
      itemCount: controller.productList.length,
      itemBuilder: (_, index) {
        var product = controller.productList[index];
        return ProductCard(
            product, product.id, 'BRAND', product.varient!.price!, null, null);
      },
    );
  }
}
