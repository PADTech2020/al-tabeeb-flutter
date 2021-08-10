import 'dart:developer';
import 'dart:io';

import 'package:elajkom/classes/providers/chat_provider.dart';
import 'package:elajkom/ui/widgets/app_widgets.dart';
import 'package:elajkom/util/custome_widgets/button.dart';
import 'package:elajkom/util/custome_widgets/loading.dart';
import 'package:elajkom/util/custome_widgets/messages.dart';
import 'package:elajkom/util/utility/api_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';

class ChatFilePicher extends StatefulWidget {
  static const String routeName = '/ChatFilePicher';
  @override
  _ChatFilePicherState createState() => _ChatFilePicherState();
}

class _ChatFilePicherState extends State<ChatFilePicher> {
  TextEditingController messageController = TextEditingController();
  ChatProvider chatProvider;
  PlatformFile _file;
  bool _isLoading = false;
  Size size;

  @override
  void initState() {
    Future.microtask(() => _filePicker());
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
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black87,
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
              icon: Icon(Icons.attach_file, color: Colors.white),
              onPressed: () {
                _filePicker();
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
              child: Icon(FontAwesomeIcons.solidPaperPlane,
                  size: 20, color: Colors.white),
              onTap: sendBTNHandler,
            ),
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  _imageView() {
    if (_file != null)
      return SingleChildScrollView(
        child: Container(
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FileWidget(
                _file,
                height: size.height / 2,
                width: size.width,
                color: Colors.white70,
                showFileName: true,
              ),
            ],
          ),
        ),
      );
    return SizedBox();
  }

  Future<PlatformFile> _filePicker() async {
    //List<String> allowedExtensions = ['jpg', 'pdf', 'doc', 'docx'];
    PlatformFile file;
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        //allowedExtensions: allowedExtensions,
      );
      if (result != null) {
        file = result.files.single;
        log(file.path);
        log(file.name);
        log(file.extension);
        log(file.size.toString() + " Kb");
        if (file.size > (1024 * 20)) {
          showDialog(
              builder: (context) => CustomDialog(message: str.app.maximumFileSize + " 20 Mb"), context: context);
        } else {
          setState(() => _file = file);
        }
      } else if (_file == null) Navigator.pop(context);
    } catch (err) {
      showDialog(
          builder: (context) => CustomDialog(message: err.toString()), context: context);
    }
    return file;
  }

  sendBTNHandler() async {
    if (_file == null) {
      _filePicker();
    } else {
      try {
        setState(() {
          _isLoading = true;
        });
        String fileUploadResponse;
        fileUploadResponse = await ApiProvider().uploadFiles(File(_file.path));
        log('fileUploadResponse ' + fileUploadResponse.toString());

        Navigator.pop(context, [messageController.text, fileUploadResponse]);
      } catch (err) {
        showDialog(
            builder: (context) => CustomDialog(message: err.toString()), context: context);
      }
    }
  }
}
