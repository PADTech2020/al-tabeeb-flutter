import 'package:elajkom/classes/models/notifications.dart';
import 'package:elajkom/classes/providers/notification_provider.dart';
import 'package:elajkom/classes/providers/notification_services.dart';
import 'package:elajkom/generated/locale_base.dart';
import 'package:elajkom/ui/widgets/app_widgets.dart';
import 'package:elajkom/util/custome_widgets/infinite_listview.dart';
import 'package:elajkom/util/custome_widgets/messages.dart';
import 'package:elajkom/util/utility/global_var.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../classes/providers/user_provider.dart';

class NotificationPage extends StatefulWidget {
  static const String routeName = '/NotifationPage';
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationClass> dataList = [];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  UserProvider userProvider;
  NotificationProvider notificationProvider;

  @override
  void initState() {
    Future.microtask(() {
      notificationProvider.readAllNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    userProvider = Provider.of<UserProvider>(context);
    notificationProvider = Provider.of<NotificationProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(str.main.notifications),
      ),
      body: userProvider.isLogin() ? _mainBody() : LoginFirstWidget(),
    );
  }

  SafeArea _mainBody() {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: InfiniteListview(
        dataList: dataList,
        loadDataFunction: loadData,
        listItemWidget: (item) => SingleNotificationsItem(item),
      ),
    ));
  }

  Future<dynamic> loadData(int page) async {
    try {
      return await NotificationServices().loadNotification(page);
    } catch (err) {
      showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
    }
  }
}
