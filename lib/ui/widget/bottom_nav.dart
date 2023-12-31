import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../data/showcase-key.dart';
import '../../helpers/controller-generator.dart';

final Color? defaultColor = Colors.grey[700];

final Color defaultOnSelectColor = Colors.blue;

class BottomNav extends StatefulWidget {
  final int index;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;
  final Duration animationDuration;
  final bool showElevation;
  final Color backgroundColor;
  final double navBarHeight;
  final double radius;

  BottomNav(
      {required this.index,
      this.navBarHeight = 100.0,
      this.showElevation = true,
      required this.onTap,
      required this.items,
      this.animationDuration = const Duration(milliseconds: 200),
      this.backgroundColor = Colors.white,
      this.radius = 16.0})
      : assert(items.length >= 2);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  int? currentIndex;
  List<AnimationController> _controllers = [];

  @override
  void initState() {
    currentIndex = widget.index;
    super.initState();
    for (int i = 0; i < widget.items.length; i++) {
      _controllers.add(
        AnimationController(
          vsync: this,
          duration: widget.animationDuration,
        ),
      );
    }
    // Start animation for initially selected controller.
    _controllers[widget.index].forward();
  }

  onItemClick(int i) {
    setState(() {
      currentIndex = i;
    });
 widget.onTap(i);
  }

  @override
  Widget build(BuildContext context) {
    _changeValue();
    return SafeArea(
      bottom: true,
      left: false,
      right: false,
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 01),
        child: Container(
          height: widget.navBarHeight,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.grey),
            // borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            boxShadow: [
              if (widget.showElevation)
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: widget.items.map((element) {
                int item = widget.items.indexOf(element);
                return BottomBarItem(element.icon, element.imgIcon,
                    element.suffix, widget.navBarHeight, element.label, () {
                  widget.onTap(item);
                }, element.selectedColor, _controllers[item], widget.radius,
                    element.givenKey);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _changeValue() {
    _controllers.forEach((controller) => controller.reverse());
    _controllers[widget.index].forward();
  }

  parseLabel(String label, bool selected) {}
}

class BottomNavItem {
  final IconData icon;
  final String label;
  final String suffix;
  Color selectedColor;
  final String imgIcon;
  final ShowcaseKey givenKey;

  BottomNavItem(
      {required this.icon,
      this.imgIcon = '',
      this.suffix = '',
      required this.label,
      required this.selectedColor,
      required this.givenKey});
}

class BottomBarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final double height;
  final VoidCallback onTap;
  final Color color;
  final AnimationController controller;
  final double radius;
  final String imageIcon;
  final String suffix;
  final ShowcaseKey givenKey;

  BottomBarItem(this.icon, this.imageIcon, this.suffix, this.height, this.label,
      this.onTap, this.color, this.controller, this.radius, this.givenKey);

  @override
  _BottomBarItemState createState() => _BottomBarItemState();
}

class _BottomBarItemState extends State<BottomBarItem>
    with TickerProviderStateMixin {
  late Animation animation;
  late AnimationController controller;
  late CartController cartController;
  Controller commonController = Get.find();

  @override
  void initState() {
    super.initState();
    cartController =
        ControllerGenerator.create(CartController(), tag: 'cartController');
    if (widget.controller == null) {
      controller = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200));
    } else {
      controller = widget.controller;
    }
    animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.linear),
    );

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
      },
      child: Showcase(
        description: widget.givenKey.desc,
        title: widget.givenKey.title,
        key: widget.givenKey.key,
        titleTextStyle: TextStyles.titleFont,
        descTextStyle: TextStyles.body,
        titleAlignment: TextAlign.center,
        // scaleAnimationAlignment: Alignment.centerRight,
        // descriptionPadding: const EdgeInsets.all(0),
        // tooltipPadding: const EdgeInsets.all(2),
        // titleTextStyle: TextStyles.bodyFont,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.label == 'Cart'
                  ? <Widget>[
                      Obx(
                        () => Stack(
                          fit: StackFit.passthrough,
                          clipBehavior: Clip.none,
                          children: [
                            widget.imageIcon.isEmpty
                                ? Icon(widget.icon,
                                    color: animation.value == 0.0
                                        ? Colors.black
                                        : widget.color,
                                    size: widget.height / 1.5)
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.asset(
                                      widget.imageIcon,
                                      height: widget.height / 1.5,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                            Positioned(
                              top: -4,
                              right: -12,
                              child: Card(
                                color: AppColors.primeColor,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6.0, right: 6, top: 4, bottom: 4),
                                  child: Text(
                                      (cartController.cartProducts.length +
                                              cartController
                                                  .cartProductsScoins.length +
                                              cartController.msdProducts.length)
                                          .toString(),
                                      style: TextStyles.bodySm
                                          .copyWith(color: AppColors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]
                  : [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: widget.imageIcon.isEmpty
                            ? Icon(widget.icon,
                                color: animation.value == 0.0
                                    ? AppColors.DarkGrey
                                    : widget.color,
                                size: widget.height / 1.5)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset(
                                  widget.imageIcon,
                                  height: widget.height / 1.5,
                                  fit: BoxFit.fill,
                                ),
                              ),
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
