import 'package:amber_bird/services/client-service.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
        return Lottie.asset(
          'assets/ripple-loading.json',
          height: height == 0 ? width * 1 : height,
          fit: BoxFit.fill,
        );
      },
    );
  }
}
