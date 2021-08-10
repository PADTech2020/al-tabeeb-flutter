import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:elajkom/classes/models/user.dart';
import 'package:elajkom/classes/services/openTok_service.dart';
import 'package:elajkom/ui/pages/chat/chat_file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../classes/models/meeting.dart';
import '../../../classes/providers/doctor_services.dart';
import '../../../util/custome_widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../classes/models/chat.dart';
import '../../../classes/models/message.dart';
import '../../../classes/providers/chat_provider.dart';
import '../../../classes/providers/user_provider.dart';
import '../../../generated/locale_base.dart';
import '../../../ui/pages/account/login.dart';
import '../../../ui/widgets/single_chat.dart';
import '../../../util/custome_widgets/button.dart';
import '../../../util/custome_widgets/image_widgets.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/utility/custom_theme.dart';
import '../../../util/utility/global_var.dart';
import 'chat_image_picker.dart';

class MessagePage extends StatefulWidget {
  static const String routeName = '/message_page';
  final Chat chat;
  final int meetingId;

  const MessagePage(this.chat, this.meetingId);
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  ChatProvider chatProvider;
  UserProvider userProvider;
  GlobalKey<ScaffoldState> _scafoldKey = GlobalKey();
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  File imageFile;
  Size size;

  bool selectionMode = false;
  List<Message> selectedList = [];

  int page = 0;
  String apiKey;
  String sessionId;
  String token;
  Meeting meeting;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _getUserSessionInfo();
      if (widget.chat != null) {
        await chatProvider.initChatHubConnection();
        chatProvider.currentChat = widget.chat;
        loadDataList(page);
        chatProvider.readAllChats(widget.chat.id);
      }
      scrollController.addListener(() {
        if (FocusScope.of(context).hasFocus && isCalling) FocusScope.of(context).unfocus();
      });
      scrollController.animateTo(
        0.0, // scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 150),
      );
    });
  }

  @override
  void dispose() {
    chatProvider.messagePageDispose();
    scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void scrollingListView() {
    scrollController.jumpTo(0.0);
  }

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    chatProvider = Provider.of<ChatProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // if (userProvider.user.role == 1 && meeting != null && sessionId != null && token != null) await _ratingDialog();
        return Future.value(true);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Scaffold(
            key: _scafoldKey,
            backgroundColor: CustomTheme.cardBackground,
            appBar: buildAppBar(),
            body: userProvider.isLogin()
                ? SafeArea(
                    child: FullScreenLoading(
                      inAsyncCall: _isLoading,
                      child: Column(
                        children: <Widget>[
                          _buildChatList(),
                          _buildSendMsgSection(),
                          SizedBox(height: 1),
                        ],
                      ),
                    ),
                  )
                : ErrorCustomWidget(
                    str.msg.loginError,
                    icon: Icons.sentiment_dissatisfied,
                    color: CustomTheme.accentColor,
                    showErrorWord: false,
                    action: ButtonWidget(
                      str.formAndAction.logIn,
                      () => Navigator.of(context).pushNamed(LoginPage.routeName),
                      margin: EdgeInsets.all(20),
                    ),
                  ),
          ),
          buildCallWidget(),
          buildcallScalingWidget(),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    if (chatProvider.selectionMode)
      return Container(
        width: size.width,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.clear), onPressed: chatProvider.cancelMessageSelection),
            Text(chatProvider.messagesSelected.length.toString() + ' ' + str.main.message),
            IconButton(icon: Icon(Icons.delete_forever), onPressed: _deleteMessages),
          ],
        ),
      );
    else
      return AppBar(
        elevation: .5,
        titleSpacing: -5,
        title: GestureDetector(
          // onTap: () => Navigator.of(context).pushNamed(UserProfilePage.routeName, arguments: widget.chat.id),
          child: Row(
            children: <Widget>[
              CircularImageView(widget.chat?.photo, tapped: false, dimension: 40),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.chat?.fullName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTheme.title1.copyWith(color: Colors.white),
                    ),
                    // Text(
                    //   str.main.active + " " + GlobalVar.timeAgo(widget.chat.latestMessageDate),
                    //   maxLines: 1,
                    //   style: CustomTheme.caption,
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
        actions: [
          ...buildCallingBTNWidget(),
          if (userProvider.user.email == 'testdoctor@al-tabeeb.com')
            IconButton(
              icon: Icon(Icons.add_business),
              onPressed: () => _physicalMeetingDateWidget(),
              constraints: BoxConstraints(maxWidth: 45),
            ),
        ],
      );
  }

  List<Widget> buildCallingBTNWidget() {
    if (meeting != null && apiKey != null && sessionId != null && token != null)
      return [
        if (meeting != null && meeting.meetingType == MeetingType.Video.index)
          IconButton(
              icon: Icon(Icons.videocam), onPressed: () => _openCallScreen(MeetingType.Video.index), constraints: BoxConstraints(maxWidth: 45)),
        if (meeting != null && (meeting.meetingType == MeetingType.Video.index || meeting.meetingType == MeetingType.Voice.index))
          IconButton(icon: Icon(Icons.call), onPressed: () => _openCallScreen(MeetingType.Voice.index), constraints: BoxConstraints(maxWidth: 45)),
      ];
    else
      return [];
  }

  Widget _buildChatList() {
    return Expanded(
      child: Container(
        color: CustomTheme.mainPageBackground,
        child: ListView.builder(
          reverse: true,
          controller: scrollController,
          itemBuilder: (ctx, index) {
            if (index == chatProvider.messages.length - 10 && chatProvider.messagesMoreAvalible) {
              loadDataList(++page);
            }
            if (index == chatProvider.messages.length) {
              if (chatProvider.messages.length == 0)
                return Image.asset(GlobalVar.no_data_available);
              else
                return SizedBox();
            }
            return SingleMessageItem(
              chatProvider.messages[index],
              image: widget.chat?.photo,
            );
          },
          itemCount: chatProvider.messages.length,
        ),
      ),
    );
  }

  void _deleteMessages() {
    showDialog(
      builder: (context) => CustomDialog(
        message: 'هل انت متاكد من حذف ${chatProvider.messagesSelected.length.toString()} رسالة؟',
        actions: <Widget>[
          TextButton(
            child: Text(str.main.yes),
            onPressed: () {
              chatProvider.deleteSelectedMessage();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(str.main.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      context: context,
    );
  }

  Widget _buildSendMsgSection() {
    if (meeting != null)
      return Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        margin: EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          color: CustomTheme.greyDarkBackground,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 5),
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxHeight: 200),
                padding: EdgeInsetsDirectional.only(start: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: CustomTheme.greyDarkBackground,
                  shape: BoxShape.rectangle,
                ),
                child: TextField(
                  controller: messageController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: str.main.enterMsg,
                  ),
                  onSubmitted: (value) => sendBTNHandler(),
                  onTap: () {
                    Timer(Duration(milliseconds: 300), () => scrollingListView());
                  },
                ),
              ),
            ),
            CircularButton(
              child: Icon(Icons.camera_alt, color: Colors.grey.shade600),
              onTap: _pickImage,
              color: Colors.transparent,
              elevation: 0,
            ),
            CircularButton(
              child: Icon(Icons.attach_file, color: Colors.grey.shade600),
              onTap: _pickFile,
              color: Colors.transparent,
              elevation: 0,
            ),
            SizedBox(width: 5),
            CircularSendButton(sendBTNHandler),
            SizedBox(width: 5),
          ],
        ),
      );
    return SizedBox();
  }

  Future<void> sendBTNHandler() async {
    String msg = messageController.text.trim();
    String img;
    if (msg.isNotEmpty) {
      chatProvider.sendMsg(msg, img, widget.chat?.id);
      messageController.clear();
    }
  }

  Future<void> _pickImage() async {
    var param = await Navigator.pushNamed(context, ChatImagePickerPage.routeName) as List<String>;
    if (param != null && param.length > 0 && param[1].isNotEmpty) chatProvider.sendMsg(param[0], param[1], widget.chat.id);
  }

  Future<void> _pickFile() async {
    var param = await Navigator.pushNamed(context, ChatFilePicher.routeName) as List<String>;
    if (param != null && param.length > 0 && param[1].isNotEmpty) chatProvider.sendMsg(param[0], param[1], widget.chat.id);
  }

  Future<void> loadDataList(int page) async {
    try {
      if (page == 0) resetSetting();
      chatProvider.getChatsMessages(widget.chat?.id, page: page);
    } catch (err) {
      print(err.toString());
    }
  }

  void resetSetting() {
    page = 0;
    chatProvider.messages = [];
  }

  Future<void> _getUserSessionInfo() async {
    try {
      var res;
      setIsLoading(true);
      if (widget.meetingId != null)
        res = await DoctorServices().getUserSessionInfo(widget.meetingId);
      else if (widget.chat?.id != null)
        res = await DoctorServices().getCurrentSessionWith(widget.chat.id);
      else
        throw Exception('there are no meeting!!');
      if (res != null) {
        apiKey = res['apiKey']?.toString();
        if (res['meeting'] != null) {
          if (res['sessionId'] != null || res['sessionToken'] != null) {
            sessionId = res['sessionId'] ?? null;
            token = res['sessionToken'] ?? null;
          }
          meeting = Meeting.fromJson(res['meeting']);
          User user;
          if (userProvider.user.id == meeting.doctor.id) {
            user = meeting.user;
          } else {
            user = meeting.doctor;
          }
          setState(() {
            widget.chat.fullName = user.fullName ?? "";
            widget.chat.photo = user.profilePhoto;
            widget.chat.id = user.id ?? "";
          });
        } else
          showDialog(builder: (context) => CustomDialog(message: res['errorMsg']), context: context);
      }
    } catch (err) {
      showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
    }
    setIsLoading(false);
  }

  void _physicalMeetingDateWidget() async {
    DateTime initDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context, initialDate: initDate, initialDatePickerMode: DatePickerMode.day, firstDate: DateTime(2015), lastDate: DateTime(2101));
    if (picked != null) {
      final TimeOfDay timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: initDate.hour, minute: initDate.minute),
      );
      if (timePicked != null) {
        DateTime physicalDate = new DateTime(picked.year, picked.month, picked.day, timePicked.hour, timePicked.minute);
        _setupPhysicalMeetingDate(physicalDate.toIso8601String());
      }
    }
  }

  void _setupPhysicalMeetingDate(String date) async {
    try {
      setIsLoading(true);
      await DoctorServices().setupPhysicalMeetingDate(meeting.id, date);
    } catch (err) {
      showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
    }
    setIsLoading(false);
  }

////////////////{ Call Section } ////////////////

  bool isCalling = false;
  OpenTokController controller;
  Map<String, dynamic> creationParams;

  bool scaleFactor = false;
  void scalFun() async {
    setState(() => scaleFactor = !scaleFactor);
  }

  Widget buildcallScalingWidget() {
    if (isCalling)
      return PositionedDirectional(
        top: scaleFactor ? null : 50,
        start: scaleFactor ? 20 : 20,
        bottom: scaleFactor ? 20 : null,
        child: CircularButton(
          onTap: scalFun,
          child: Icon(scaleFactor ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white),
          dimension: scaleFactor ? 80 : 50,
          color: Colors.black54,
        ),
      );
    else
      return SizedBox();
  }

  Widget buildCallWidget() {
    if (isCalling)
      return Transform.scale(
        alignment: AlignmentDirectional.bottomStart,
        scale: scaleFactor ? 0.3 : 1,
        child: OpenTokWidget(
          creationParams: creationParams,
          onOpenTokCreated: (controller) async {
            try {
              this.controller = controller;
              var res = await controller.makeCall(creationParams);
              log('re////////////s : $res');
              OpenTokWidget.resultHandler(context, res, _scafoldKey);

              setState(() {
                isCalling = false;
              });
              DoctorServices().meetingFinish(meeting.id);
            } catch (err) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.blankSnakBar(err.toString()));
            }
          },
          responseFromNative: (args) {
            log('/////////////////////////////// responseFromNative Function ${args.toString()}');
          },
        ),
      );
    else
      return SizedBox();
  }

  void _openCallScreen(int meetingTypeRequest) async {
    if (!isCalling) {
      bool perm = true;
      log(str.msg.cameraPermissios ?? 'dfsdfsdfdsfdsfdsfds');
      if (meetingTypeRequest == 0) {
        if (await Permission.camera.isDenied || await Permission.camera.isPermanentlyDenied)
          openAppSettings(str.msg.cameraPermissios);
        else
          await Permission.camera.request();
        if (!await Permission.camera.isGranted) perm = false;
      }
      if (meetingTypeRequest <= 1) {
        if (await Permission.microphone.isDenied || await Permission.microphone.isPermanentlyDenied)
          openAppSettings(str.msg.microphonePermissios);
        else
          await Permission.microphone.request();
        if (!await Permission.microphone.isGranted) perm = false;
      }
      if (perm) {
        creationParams = {
          'apiKey': apiKey,
          'sessionId': sessionId,
          'token': token,
          'meetingType': meeting.meetingType,
          'meetingTypeRequest': meetingTypeRequest,
        };

        setState(() {
          scaleFactor = false;
          isCalling = true;
        });
      }
    }
  }

  void openAppSettings(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBarWidget.blankSnakBar(msg, actionLable: str.main.setting, actionOnTap: () => AppSettings.openAppSettings()));
  }

  bool _isLoading = false;
  void setIsLoading(bool value) {
    if (mounted)
      setState(() {
        _isLoading = value;
      });
  }
}
