import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui/pages/chat/Message_page.dart';
import '../../util/custome_widgets/image_widgets.dart';
import '../../classes/models/chat.dart';
import '../../classes/models/message.dart';
import '../../classes/providers/chat_provider.dart';
import '../../classes/providers/user_provider.dart';
import '../../util/utility/custom_theme.dart';
import '../../util/utility/global_var.dart';
import 'app_widgets.dart';

class SingleChat extends StatelessWidget {
  final Chat item;

  SingleChat(this.item);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, MessagePage.routeName, arguments: item);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.only(bottom: 2),
        color: item.unreadCount > 0 ? Colors.grey.shade200 : CustomTheme.cardBackground,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularImageView(item.photo, tapped: false),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  FittedBox(child: Text(item.fullName ?? '', style: CustomTheme.title3)),
                  SizedBox(height: 5),
                  item.latestMessageFiles == null
                      ? buildTextLine(item.latestMessageText ?? "")
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.image, color: Colors.grey.shade600),
                            Expanded(
                                child: buildTextLine(
                                    ' ' + item.latestMessageText == null || item.latestMessageText.isEmpty ? str.main.image : item.latestMessageText))
                          ],
                        ),
                ],
              ),
            ),
            Text(GlobalVar.timeAgo(item.latestMessageDate), style: CustomTheme.caption),
          ],
        ),
      ),
    );
  }

  Text buildTextLine(String text) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: CustomTheme.body2.copyWith(color: Colors.black),
    );
  }
}

class SingleMessageItem extends StatefulWidget {
  final Message item;
  final String image;
  SingleMessageItem(this.item, {this.image});

  @override
  _SingleMessageItemState createState() => _SingleMessageItemState();
}

class _SingleMessageItemState extends State<SingleMessageItem> {
  ChatProvider chatProvider;
  UserProvider userProvider;
  Size size;

  bool _isSelected = false;

  bool me;
  double borderRadius;
  double topEndBorderRadius;
  double topStartBorderRadius;
  Color backgroundColor;
  Color textColor;
  double maxWidth;

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
    size = MediaQuery.of(context).size;
    me = widget.item.fromUserId == userProvider.user.id;
    borderRadius = 7;
    backgroundColor = CustomTheme.greyDarkBackground;
    textColor = CustomTheme.primaryColor;
    TextDirection textDirection;
    final String img = me ? userProvider.user.profilePhoto : widget.image;
    final double imgWidth = 200;
    final double imgHeight = imgWidth / 3 * 4; // for 3/4 aspect ratio
    maxWidth = widget.item.files != null && widget.item.files.isNotEmpty ? imgWidth : size.width - 90;
    if (_isSelected && !chatProvider.selectionMode) _isSelected = false;
    if (GlobalVar.initializationLanguage == 'ar') {
      if (me)
        textDirection = TextDirection.rtl;
      else
        textDirection = TextDirection.ltr;
    } else {
      if (me)
        textDirection = TextDirection.ltr;
      else
        textDirection = TextDirection.rtl;
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        textDirection: textDirection,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircularImageView(img, dimension: 40),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: me ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: <Widget>[
              widget.item.files != null && widget.item.files.isNotEmpty
                  ? ClipRRect(
                      child: GlobalVar.imageExtensions.contains(widget.item.files.split('.').last)
                          ? ImageView(widget.item.files, height: imgHeight, width: imgWidth)
                          : FileWidget(widget.item.files, height: imgHeight / 5, width: imgWidth / 5),
                      borderRadius: BorderRadius.circular(borderRadius),
                    )
                  : SizedBox(),
              widget.item.message != null && widget.item.message.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(widget.item.message, textAlign: TextAlign.start, style: CustomTheme.body2.copyWith(color: textColor)),
                    )
                  : SizedBox(),
              Text(GlobalVar.timeAgo(widget.item.createdDate), style: CustomTheme.body3.copyWith(color: Colors.grey.shade600, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  void itemOnTap() {
    if (chatProvider.selectionMode && me) {
      setState(() {
        _isSelected = !_isSelected;
      });
      if (_isSelected)
        chatProvider.addToMessageSelection(widget.item);
      else
        chatProvider.deleteFromMessageSelection(widget.item);
    }
  }
}
