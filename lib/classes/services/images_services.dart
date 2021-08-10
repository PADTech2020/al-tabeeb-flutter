import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../util/utility/custom_theme.dart';
import '../../util/utility/global_var.dart';

class PickImageServices {
  BuildContext context;
  bool galaryMultiSelect = false;

  PickImageServices({@required this.context, this.galaryMultiSelect});

  void showImagePickerDialog({bool isDismissible = true, Function cameraOntap, Function galaryOntap}) async {
    if (cameraOntap == null) cameraOntap = () => pickImage(ImageSource.camera);
    if (galaryOntap == null) galaryOntap = () => pickImage(ImageSource.gallery);
    showDialog(
      builder: (context) => SimpleDialog(
        children: <Widget>[
          TextButton(
            onPressed: cameraOntap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[Text(str.main.camera, style: CustomTheme.body1), Icon(Icons.camera_alt, color: Colors.grey.shade700)],
            ),
          ),
          Divider(),
          TextButton(
            onPressed: galaryOntap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[Text(str.main.gallery, style: CustomTheme.body1), Icon(Icons.image, color: Colors.grey.shade700)],
            ),
          ),
        ],
      ),
      barrierDismissible: isDismissible,
      context: context,
    );
  }

  Future<File> pickImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: imageSource, imageQuality: 75);
    if (image == null) return null;
    var fileImage = File(image.path);
    return fileImage;
  }

  Future<File> cropImage(File image) async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: image.path,
      //aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      maxWidth: 512,
      maxHeight: 912,
    );
    return cropped;
  }
}
