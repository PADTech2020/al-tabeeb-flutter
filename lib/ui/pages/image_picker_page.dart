import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../util/custome_widgets/messages.dart';
import '../../util/utility/custom_theme.dart';
import '../../generated/locale_base.dart';
import '../../util/utility/global_var.dart';

class ImagePickerPage extends StatefulWidget {
  static const String routeName = '/ImagePickerPage';
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  ImageSource imageSource;
  File _imageFile;

  @override
  void initState() {
    Future.microtask(() => showImagePickerDialog(isDismissible: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    theme = Theme.of(context);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
        onWillPop: () async {
          bool backResult = false;
          await showDialog(
            builder: (context) => CustomDialog(
              title: str.msg.exitConfirmation,
              message: str.msg.imageNotSaved,
              actions: <Widget>[
                TextButton(
                    child: Text(str.main.yes),
                    onPressed: () {
                      Navigator.pop(context);
                      backResult = true;
                    }),
                TextButton(
                    child: Text(str.main.no),
                    onPressed: () {
                      Navigator.pop(context);
                      backResult = false;
                    }),
              ],
            ),
            context: context,
          );
          if (backResult == true) await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
          return backResult;
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.black87,
            resizeToAvoidBottomInset: true,
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _imageView(),
                _buildTopBar(),
                _buildBottomBar(),
                SizedBox(height: 10),
              ],
            ),
          ),
        ));
  }

  _buildTopBar() {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.black26, Colors.black12, Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          children: <Widget>[
            BackButton(color: Colors.white),
            Spacer(),
            IconButton(icon: Icon(Icons.edit, color: Colors.white), onPressed: showImagePickerDialog),
            IconButton(
                icon: Icon(
                  Icons.crop,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: _cropImage),
            GestureDetector(child: Icon(Icons.check, size: 40, color: Colors.white), onTap: _save),
          ],
        ),
      ),
    );
  }

  _buildBottomBar() {
    return SizedBox();
  }

  _imageView() {
    return Container(
      child: _imageFile != null ? Image.file(_imageFile) : SizedBox(),
    );
  }

  void showImagePickerDialog({bool isDismissible = true}) async {
    showDialog(
      builder: (context) => SimpleDialog(
        children: <Widget>[
          TextButton(
            onPressed: () => _pickImage(ImageSource.camera),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[Text(str.main.camera, style: CustomTheme.body1), Icon(Icons.camera_alt, color: Colors.grey.shade700)],
            ),
          ),
          Divider(),
          TextButton(
            onPressed: () => _pickImage(ImageSource.gallery),
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

  void _pickImage(ImageSource imageSource) async {
    Navigator.of(context).pop();
    final picker = ImagePicker();
    var image = await picker.getImage(source: imageSource, imageQuality: 75);
    if (image == null) return null;

    setState(() {
      _imageFile = File(image.path);
    });
  }

  void _cropImage() async {
    if (_imageFile == null) {
      showImagePickerDialog(isDismissible: true);
    } else {
      File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        //aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        maxWidth: 512,
        maxHeight: 912,
      );

      setState(() {
        _imageFile = cropped ?? _imageFile;
      });
    }
  }

  void _save() async {
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    Navigator.pop(context, _imageFile);
  }
}
