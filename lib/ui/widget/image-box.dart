import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

//https://pub.dev/documentation/disposable_cached_images/latest/
class ImageBox extends StatelessWidget {
  final String path;
  double height;
  double width;
  BoxFit fit;
  ImageBox(this.path,
      {Key? key, this.height = 0, this.width = 0, this.fit = BoxFit.fitHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '${ClientService.cdnUrl}$path',
      width: width,
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
          child: Center(child: const CircularProgressIndicator())),
      errorWidget: (context, url, error) =>
          Center(child: const Icon(Icons.error)),
    );
  }
}
