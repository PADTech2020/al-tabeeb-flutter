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
import 'main_page.dart';
import 'package:provider/provider.dart';
import '../../classes/providers/user_provider.dart';

class VisitesPage extends StatefulWidget {
  static const String routeName = '/MeetingsPage';
  @override
  _VisitesPageState createState() => _VisitesPageState();
}

class _VisitesPageState extends State<VisitesPage> {
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
        title: Text(str.app.visites),
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
                    listItemWidget: (item) => SingleMeetingItem(item),
                  ),
                )
              : LoginFirstWidget(),
        ),
      ),
      drawer: MainPage.homeDrawer,
      drawerEdgeDragWidth: 25,
    );
  }

  Future<dynamic> _loadData(int page) async {
    try {
      if (userProvider.user.role == 2)
        return await DoctorServices().getdoctorMeetings(page: page, started: true);
      else
        return await DoctorServices().getUserMeetings(page: page, started: true);
    } catch (err) {
      showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
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
