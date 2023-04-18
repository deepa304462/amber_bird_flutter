import 'package:amber_bird/services/client-service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';

//https://pub.dev/documentation/disposable_cached_images/latest/
class ImageBox extends StatelessWidget {
  String path;
  final String type;
  double height;
  double width;
  BoxFit fit;
  String fileId = '';
  ImageBox(this.path,
      {Key? key,
      this.height = 0,
      this.width = 0,
      this.type = 'cdn',
      this.fit = BoxFit.fitHeight})
      : super(key: key) {
    fileId = path;
    if (type == 'download') {
      path = '${ClientService.downloadUrl}$path';
    } else {
      path = '${ClientService.cdnUrl}$path';
    }
  }

  @override
  Widget build(BuildContext context) {
    // DefaultCacheManager manager = new DefaultCacheManager();
    // manager.emptyCache();
    // await CachedNetworkImage.evictFromCache(url);

    // print((FastCachedImageConfig.isCached(imageUrl: path).toString() +
    //     ' cached ' +
    //     path));
    return CachedNetworkImage(
      imageUrl: path,
      fit: fit,
      width: width,
      fadeInDuration: const Duration(milliseconds: 20),
      height: height == 0 ? width * 1 : height,
      errorWidget: (context, exception, stacktrace) {
        CachedNetworkImage.evictFromCache(path);
        return const Icon(Icons.error);
      },
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return Shimmer.fromColors(
            // ignore: sort_child_properties_last
            child: SizedBox(
              width: width,
              height: height,
              child: Card(
                color: Colors.white,
              ),
            ),
            baseColor: Colors.grey.shade300,
            period: const Duration(milliseconds: 500),
            highlightColor: Colors.grey.shade300);
      },
    );
  }
}
