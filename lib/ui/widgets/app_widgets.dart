import 'dart:developer';
import 'dart:io';

import 'package:elajkom/classes/models/notifications.dart';
import 'package:elajkom/ui/pages/search_page.dart';
import 'package:elajkom/util/custome_widgets/image_widgets.dart';
import 'package:elajkom/util/utility/api_provider.dart';
import 'package:elajkom/util/utility/lunch_url.dart';
import 'package:file_picker/file_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../ui/pages/account/login.dart';
import '../../util/custome_widgets/messages.dart';
import '../../util/utility/custom_theme.dart';
import '../../util/utility/global_var.dart';
import 'package:flutter/material.dart';

class LoginFirstWidget extends StatelessWidget {
  final Color buttonTextColor;
  LoginFirstWidget({this.buttonTextColor = CustomTheme.accentColor});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ErrorCustomWidget(
          str.msg.loginFirst,
          icon: Icons.sentiment_dissatisfied,
          color: CustomTheme.accentColor,
          showErrorWord: false,
          action: TextButton(
            child: Text(
              str.formAndAction.logIn,
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(backgroundColor: buttonTextColor),
            onPressed: () => Navigator.of(context).pushNamed(LoginPage.routeName),
          ),
        ),
      ],
    );
  }
}

class MainSearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        Navigator.of(context).push(
          new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return SearchPage();
            },
            fullscreenDialog: true,
            // this flag will provide out screen “close symbol” in the top left corner instead of the default “back arrow”.
            //  On iOS devices, it also affects swipe back behavior.
          ),
        );
      },
    );
  }
}

class SingleCategory extends StatelessWidget {
  final dynamic item;
  final Function onTapCallback;
  final bool active;
  SingleCategory(this.item, this.onTapCallback, {this.active = false});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        margin: EdgeInsetsDirectional.only(end: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: active ? CustomTheme.primaryColor : CustomTheme.accentColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(item.title ?? '', style: CustomTheme.body2.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class SingleNotificationsItem extends StatelessWidget {
  final NotificationClass item;
  SingleNotificationsItem(this.item);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      subtitle: Text(item.text),
      trailing: Text(GlobalVar.dateForamt(item.createdDate)),
    );
  }
}

class LogoWidget extends StatelessWidget {
  final double hieght;
  LogoWidget({this.hieght = 90.0});
  @override
  Widget build(BuildContext context) {
    String logoName = GlobalVar.assetsImageBase + "logo-land-";
    logoName += GlobalVar.initializationLanguage == "ar" ? "ar" : "en";
    logoName += ".png";
    return Image.asset(
      logoName,
      fit: BoxFit.fitWidth,
      height: hieght,
    );
  }
}

class FileWidget extends StatelessWidget {
  final dynamic file;
  final Color color;
  final double height;
  final double width;
  final bool showFileName;
  FileWidget(this.file, {this.height = 50, this.width = 40, this.color = Colors.grey, this.showFileName = false});
  @override
  Widget build(BuildContext context) {
    String fileType;
    String fileName;
    log(file.toString());
    if (file != null) {
      if (file is String && file.isNotEmpty) {
        fileType = file?.split('.')?.last ?? null;
        fileName = file?.split('.')?.first ?? null;
      } else if (file is File) {
        fileType = file?.path?.split('.')?.last ?? null;
      } else if (file is PlatformFile) {
        fileType = file.extension ?? null;
        fileName = file.name ?? null;
      }
      if (fileType != null) {
        fileType = fileType.toLowerCase();
        if (GlobalVar.imageExtensions.contains(fileType)) {
          return imageFile(fileType);
        } else
          return docFile(fileType, fileName);
      }
    }

    return SizedBox();
  }

  Widget imageFile(String fileType) {
    if (file is String)
      return ImageView(file, height: height, width: width);
    else
      return ImageView(File(file.path), height: height, width: width);
  }

  Widget docFile(String fileType, String fileName) {
    IconData icon = FontAwesomeIcons.folder;
    if (fileType == 'pdf')
      icon = FontAwesomeIcons.solidFilePdf;
    else if (GlobalVar.videoExtensions.contains(fileType))
      icon = FontAwesomeIcons.solidFileVideo;
    else if (fileType == 'doc' || fileType == 'docx')
      icon = FontAwesomeIcons.fileWord;
    else if (fileType == 'xlsx' || fileType == 'xls')
      icon = FontAwesomeIcons.fileExcel;
    else if (fileType == 'rar' || fileType == 'zip')
      icon = FontAwesomeIcons.fileArchive;
    else
      icon = FontAwesomeIcons.file;

    return Column(
      children: [
        GestureDetector(
          child: Icon(icon, size: height, color: color),
          onTap: () {
            if (file is File)
              LunchUrl.canLaunch(file.path);
            else if (file is PlatformFile)
              LunchUrl.canLaunch(file.path);
            else
              LunchUrl.canLaunch(ApiProvider.downloadApi + file);
          },
        ),
        SizedBox(height: 10),
        if (showFileName) SizedBox(height: 50),
        if (showFileName) Text(fileName ?? " ", style: CustomTheme.title1.copyWith(color: Colors.white)),
      ],
    );
  }
}
