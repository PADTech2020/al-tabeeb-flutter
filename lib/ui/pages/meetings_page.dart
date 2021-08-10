import '../../classes/models/chat.dart';
import '../../classes/models/meeting.dart';
import '../../classes/providers/doctor_services.dart';
import '../../ui/widgets/app_widgets.dart';
import '../../ui/widgets/meeting_widget.dart';
import '../../util/custome_widgets/infinite_listview.dart';
import '../../util/custome_widgets/loading.dart';
import '../../util/custome_widgets/messages.dart';
import 'package:flutter/material.dart';
import '../../generated/locale_base.dart';
import '../../util/utility/global_var.dart';
import 'chat/Message_page.dart';
import 'main_page.dart';
import 'package:provider/provider.dart';
import '../../classes/providers/user_provider.dart';

class MeetingsPage extends StatefulWidget {
  static const String routeName = '/MeetingsPage';
  final bool withDrawer;
  MeetingsPage({this.withDrawer = true});
  @override
  _MeetingsPageState createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Meeting> dataList = [];
  UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(str.app.appointments),
      ),
      body: SafeArea(
        child: FullScreenLoading(
          inAsyncCall: _isLoading,
          child: userProvider.isLogin()
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InfiniteListview(
                    dataList: dataList,
                    loadDataFunction: _loadData,
                    listItemWidget: (item) =>
                        SingleMeetingItem(item, reportMissedMeetingFun: reportMissedMeetingFun, startMeetingFun: startMeetingFun),
                  ),
                )
              : LoginFirstWidget(),
        ),
      ),
      drawer: widget.withDrawer ? MainPage.homeDrawer : null,
    );
  }

  Future<dynamic> _loadData(int page) async {
    try {
      if (userProvider.user.role == 2)
        return await DoctorServices().getdoctorMeetings(page: page, started: false);
      else
        return await DoctorServices().getUserMeetings(page: page, started: false);
    } catch (err) {
      showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
    }
  }

  void startMeetingFun(Meeting meeting, String id, String fullName, String photo) {
    DateTime startDate = DateTime.parse(meeting.meetingDateTime);
    DateTime endDate = startDate.add(Duration(minutes: meeting.durationInMinutes));
    DateTime nowDate = DateTime.now();
    if (nowDate.isAfter(startDate)) {
      if (nowDate.isBefore(endDate)) {
        if (GlobalVar.isLogin(context)) {
          Chat chat = Chat(id: id, fullName: fullName, photo: photo);
          Navigator.pushNamed(context, MessagePage.routeName, arguments: [chat, meeting.id]);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.blankSnakBar(str.app.meetingTimepass));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.blankSnakBar(str.app.meetingTimeNotYet));
    }
  }

  void reportMissedMeetingFun(Meeting meeting, String userId) async {
    DateTime startDate = DateTime.parse(meeting.meetingDateTime);
    DateTime endDate = startDate.add(Duration(minutes: meeting.durationInMinutes));
    DateTime nowDate = DateTime.now();
    if (nowDate.isAfter(startDate)) {
      if (nowDate.isBefore(endDate)) {
        if (GlobalVar.isLogin(context)) {
          try {
            setIsLoading(true);
            await DoctorServices().reportMissedMeeting(meeting.id, userId);
            ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.blankSnakBar(str.app.reportMissedMeetingSuccess));
          } catch (err) {
            showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
          }
          setIsLoading(false);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.blankSnakBar(str.app.meetingTimepass));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.blankSnakBar(str.app.meetingTimeNotYet));
    }
  }

  bool _isLoading = false;
  void setIsLoading(bool value) {
    if (mounted)
      setState(() {
        _isLoading = value;
      });
  }
}
