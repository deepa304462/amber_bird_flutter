import 'dart:io';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  Function(String) callback;
  Function(bool) isLoading;
  final String defaultImageId;
  ImagePickerPage(this.defaultImageId, this.callback, this.isLoading);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<ImagePickerPage> {
  /// Variables
  File? imageFile = null;

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        imageFile != null
            ? Container(
                height: 150,
                width: 150,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                    //set border radius more than 50% of height and width to make circle
                  ),
                  child: Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(
                height: 150,
                width: 150,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                    //set border radius more than 50% of height and width to make circle
                  ),
                  child: widget.defaultImageId != ''
                      ? ImageBox(
                          widget.defaultImageId,
                          width: MediaQuery.of(context).size.width,
                          height: 170,
                          type: 'download',
                          fit: BoxFit.cover,
                        )
                      : ImageBox(
                          '35b50ba9-3bfe-4688-8b22-1d56f657f3bb',
                          width: MediaQuery.of(context).size.width,
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                _getFromGallery();
              },
              child: Text(
                "Select from Gallery",
                style: TextStyles.bodyFont,
              ),
            ),
            TextButton(
              onPressed: () {
                _getFromCamera();
              },
              child: Text(
                "Click a picture",
                style: TextStyles.bodyFont,
              ),
            )
          ],
        ),
      ],
    );
  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      widget.isLoading(true);
      setState(() {
        imageFile = File(pickedFile.path);
      });

      var resp = await ClientService.postFile(
          path: 'fileStorage',
          file: imageFile!,
          payload: {
            "bucketName": "AMBER_BIRD_DOCS",
            "dirPrefix": "GENERAL_DOCS",
            "purpose": "official-docs",
            "accessType": "PRIVATE"
          });
      if (resp.statusCode == 200) {
        widget.callback(resp.data['_id']);
      }
      widget.isLoading(false);
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      widget.isLoading(true);
      setState(() {
        imageFile = File(pickedFile.path);
      });
      var resp = await ClientService.postFile(
          path: 'fileStorage',
          file: imageFile!,
          payload: {
            "bucketName": "AMBER_BIRD_DOCS",
            "dirPrefix": "GENERAL_DOCS",
            "purpose": "official-docs",
            "accessType": "PRIVATE"
          });
      if (resp.statusCode == 200) {
        widget.callback(resp.data['_id']);
      }
      widget.isLoading(false);
    }
  }

  // Future pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image == null) return;
  //     final imageTemp = File(image.path);
  //     setState(() => this.image = imageTemp);
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }
}
