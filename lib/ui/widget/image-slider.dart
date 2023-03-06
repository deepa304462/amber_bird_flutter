import 'package:amber_bird/data/appmanger/intro_image.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/overlay-widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageSlider extends StatefulWidget {
  final List<dynamic> images;
  final double width;
  double? height;
  bool isImagePath = true;
  bool disableTap = false;
  BoxFit fit = BoxFit.contain;
  ImageSlider(this.images, this.width,
      {Key? key,
      this.height,
      this.isImagePath = true,
      this.disableTap = false,
      this.fit = BoxFit.contain})
      : super(key: key);
  double minScale = .4;
  double defScale = 1;
  double maxScale = 2;

  @override
  State<StatefulWidget> createState() {
    return _ImageSlider();
  }
}

class _ImageSlider extends State<ImageSlider> {
  int currentPos = 0;
  CarouselController controller = CarouselController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        widget.isImagePath
            ? InkWell(
                onTap: () {
                  if (!widget.disableTap) showImageInOverlay(context);
                },
                child: CarouselSlider(
                  carouselController: controller,
                  options: CarouselOptions(
                      height: widget.height,
                      viewportFraction: 1,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentPos = index;
                        });
                      }),
                  items: widget.images.map((imageObj) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ImageBox(
                          imageObj,
                          fit: widget.fit,
                          width: widget.width,
                        );
                      },
                    );
                  }).toList(),
                ),
              )
            : CarouselSlider(
                carouselController: controller,
                options: CarouselOptions(
                    height: widget.height,
                    viewportFraction: 1,
                    autoPlay: true,
                    scrollPhysics: const BouncingScrollPhysics(),
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentPos = index;
                      });
                    }),
                items: widget.images.map((i) {
                  IntroImage imageObj = i as IntroImage;
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: widget.width,
                          margin: const EdgeInsets.symmetric(horizontal: 0.0),
                          decoration:
                              const BoxDecoration(color: Colors.transparent),
                          child: ImageBox(
                            imageObj.imageId!,
                            width: widget.width,
                          ));
                    },
                  );
                }).toList(),
              ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images
                .map((e) => InkWell(
                      onTap: () {
                        currentPos = widget.images.indexOf(e);
                        controller.jumpToPage(currentPos);
                      },
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPos == widget.images.indexOf(e)
                              ? const Color.fromRGBO(0, 0, 0, 0.9)
                              : const Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }

  void showImageInOverlay(BuildContext context) {
    Widget photoView = Container(
        child: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(
              '${ClientService.cdnUrl}${widget.images[index].toString()}'),
          initialScale: widget.minScale * 1.5,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
        );
      },
      backgroundDecoration: const BoxDecoration(color: Colors.white),
      itemCount: widget.images.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: const CircularProgressIndicator(),
        ),
      ),
    ));
    Navigator.of(context).push(OverlayWidget(photoView));
  }
}
