import 'package:amber_bird/services/client-service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
    return CachedNetworkImage(
      imageUrl: path,
      width: width,
      cacheKey: path,
      height: height == 0 ? width * 1 : height,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
          color: Colors.white,
          child: const Center(child: CircularProgressIndicator())),
      errorWidget: (context, url, error) =>
          const Center(child: Icon(Icons.error)),
    );
  }
}
