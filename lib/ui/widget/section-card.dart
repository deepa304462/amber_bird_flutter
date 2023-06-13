import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/data/order/address.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/ui/widget/location-dialog.dart';
import 'package:amber_bird/ui/widget/web-page-viewer.dart';
import 'package:flutter/material.dart';
import 'package:amber_bird/utils/ui-style.dart';

Widget sectionCard(
  String title,
  String subtitleVal,
  icon,
  Function() onTap,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: onTap,
      child: Card(
        child: ListTile(
          leading: icon != null ? Icon(icon) : const SizedBox(),
          title: Text(
            title,
            style: TextStyles.headingFont,
          ),
          subtitle: subtitleVal != ''
              ? Text(
                  subtitleVal,
                  style: TextStyles.bodyFont,
                )
              : null,
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    ),
  );
}

openWebPage(String url, BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) {
        return SizedBox(
            height: MediaQuery.of(context).size.height * .7,
            child: WebPageViewer(url));
      });
}

Widget addressCard(BuildContext context, LocationController locationController,
    int index, Address address, Map Function() onTap) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: onTap,
      child: Card(
        child: ListTile(
          title: Text(
            address.name!,
            style: TextStyles.headingFont,
          ),
          subtitle: FitText(
            '${address.line1!} ${address.zipCode}',
            style: TextStyles.bodyFont,
          ),
          trailing: IconButton(
            onPressed: () {
              locationController.seelctedIndexToEdit.value = index;
              print(index);
              locationController.changeAddressData.value = address;
              displayLocationDialog(context, locationController, 'Edit');
            },
            icon: const Icon(Icons.edit),
          ),
        ),
      ),
    ),
  );
}

displayLocationDialog(
    BuildContext context, LocationController locationController, String type) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 500),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation,
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return LocationDialog(type);
    },
  );
}
