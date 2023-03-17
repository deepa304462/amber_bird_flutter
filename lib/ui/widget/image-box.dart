import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/shimmer-widget.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

//https://pub.dev/documentation/disposable_cached_images/latest/
class ImageBox extends StatelessWidget {
  String path;
  final String type;
  double height;
  double width;
  BoxFit fit;
  ImageBox(this.path,
      {Key? key,
      this.height = 0,
      this.width = 0,
      this.type = 'cdn',
      this.fit = BoxFit.fitHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == 'download') {
      path = '${ClientService.downloadUrl}$path';
    } else {
      path = '${ClientService.cdnUrl}$path';
    }
    // print((FastCachedImageConfig.isCached(imageUrl: path).toString() +
    //     ' cached ' +
    //     path));
    return FastCachedImage(
      url: '$path',
      fit: fit,
      isAntiAlias: true,
      width: width,
      fadeInDuration: const Duration(milliseconds: 20),
      height: height == 0 ? width * 1 : height,
      errorBuilder: (context, exception, stacktrace) {
        return Icon(Icons.error);
      },
      loadingBuilder: (context, progress) {
        return Shimmer.fromColors(
            // ignore: sort_child_properties_last
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Container(
                width: width,
                height: height,
              ),
            ),
            baseColor: Colors.grey.shade100,
            period: const Duration(milliseconds: 300),
            highlightColor: Colors.grey.shade300);
      },
    );
  }
}
