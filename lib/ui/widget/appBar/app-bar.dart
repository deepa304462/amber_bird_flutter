import 'package:amber_bird/ui/widget/appBar/location-widget.dart';
import 'package:flutter/material.dart';

class appBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: [
          locationWidget(),
          // SearchWidget()
        ],
      ),
    );
  }
}
