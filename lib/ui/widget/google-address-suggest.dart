import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:flutter/material.dart';

import '../../controller/google-address-suggest-controller.dart';

class GoogleAddressSuggest extends StatelessWidget {
  late GoogleAddressSuggestController controller;
  GoogleAddressSuggest({Key? key}) : super(key: key) {
    controller = ControllerGenerator.create(GoogleAddressSuggestController());
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
