import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../classes/providers/chat_provider.dart';
import '../../../util/custome_widgets/button.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/utility/api_provider.dart';
import '../../../util/utility/custom_theme.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';
import '../../../util/custome_widgets/loading.dart';

class ChatImagePickerPage extends StatefulWidget {
  static const String routeName = '/ChatImagePickerPage';

  @override
  _ChatImagePickerPageState createState() => _ChatImagePickerPageState();
}

class _ChatImagePickerPageState extends State<ChatImagePickerPage> {
  TextEditingController messageController = TextEditingController();
  ChatProvider chatProvider;
  ImageSource imageSource;
  File _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    Future.microtask(() => showImagePickerDialog(false));
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    theme = Theme.of(context);
    chatProvider = Provider.of<ChatProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black87,
        resizeToAvoidBottomInset: true,
        body: FullScreenLoading(
          inAsyncCall: _isLoading,
          dismissible: false,
          child: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _imageView(),
                _buildTopBar(),
                _buildBottomBar(),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
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
            IconButton(icon: Icon(Icons.crop), onPressed: _cropImage, color: Colors.white)
          ],
        ),
      ),
    );
  }

  _buildBottomBar() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        constraints: BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.black45, Colors.black26],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.camera_alt, color: Colors.white),
              onPressed: () {
                log('showImagePickerDialog');
                showImagePickerDialog(true);
              },
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: messageController,
                onFieldSubmitted: (value) => sendBTNHandler(),
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: str.main.addCaption,
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 5),
            CircularButton(
              color: theme.accentColor,
              dimension: 45,
              child: Icon(FontAwesomeIcons.solidPaperPlane, size: 20, color: Colors.white),
              onTap: sendBTNHandler,
            ),
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  _imageView() {
    return Container(
      child: _imageFile != null ? Image.file(_imageFile) : SizedBox(),
    );
  }

  void showImagePickerDialog(bool isDismissible) async {
    FocusScope.of(context).unfocus();
    log('showImagePickerDialog');
    showModalBottomSheet(
      isDismissible: isDismissible,
      context: context,
      elevation: 5,
      builder: (_) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: TextButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      str.main.camera,
                      style: CustomTheme.title3,
                    ),
                    Icon(
                      Icons.camera_alt,
                      size: 35,
                      color: Colors.grey.shade700,
                    )
                  ],
                ),
              ),
            ),
            Container(height: 45, width: 1, color: Colors.grey),
            Expanded(
              child: TextButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      str.main.gallery,
                      style: CustomTheme.title3,
                    ),
                    Icon(
                      Icons.image,
                      size: 35,
                      color: Colors.grey.shade700,
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _pickImage(ImageSource imageSource) async {
    Navigator.of(context).pop();
    final picker = ImagePicker();
    var image = await picker.getImage(source: imageSource, imageQuality: 75, maxHeight: 1024, maxWidth: 1024);
    if (image == null) return null;

    setState(() {
      _imageFile = File(image.path);
    });
  }

  void _cropImage() async {
    if (_imageFile == null) {
      showImagePickerDialog(false);
    } else {
      File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        //aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        maxHeight: 1024,
        maxWidth: 1024,
      );

      setState(() {
        _imageFile = cropped ?? _imageFile;
      });
    }
  }

  sendBTNHandler() async {
    if (_imageFile == null) {
      showImagePickerDialog(true);
    } else {
      try {
        setState(() {
          _isLoading = true;
        });
        String fileUploadResponse;
        fileUploadResponse = await ApiProvider().uploadFiles(_imageFile);
        log('fileUploadResponse ' + fileUploadResponse.toString());

        Navigator.pop(context, [messageController.text, fileUploadResponse]);
      } catch (err) {
        showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
      }
    }
  }
}
