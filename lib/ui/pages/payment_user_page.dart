import '../../classes/models/meeting.dart';
import '../../classes/providers/doctor_services.dart';
import '../../ui/widgets/app_widgets.dart';
import '../../ui/widgets/meeting_widget.dart';
import '../../util/custome_widgets/infinite_listview.dart';
import '../../util/custome_widgets/loading.dart';
import '../../util/custome_widgets/messages.dart';
import '../../util/utility/custom_theme.dart';
import 'package:flutter/material.dart';
import '../../generated/locale_base.dart';
import '../../util/utility/global_var.dart';
import 'main_page.dart';
import 'package:provider/provider.dart';
import '../../classes/providers/user_provider.dart';

class PaymentUserPage extends StatefulWidget {
  static const String routeName = '/MeetingsPage';
  @override
  _PaymentUserPageState createState() => _PaymentUserPageState();
}

class _PaymentUserPageState extends State<PaymentUserPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  UserProvider userProvider;
  List<Meeting> dataList = [];
  double totalBills = 0;
  int totalvisites = 0;
  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(str.app.bills),
      ),
      body: SafeArea(
        child: FullScreenLoading(
          inAsyncCall: _isLoading,
          child: userProvider.isLogin()
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _totalsSection(),
                      Expanded(
                        child: InfiniteListview(
                          dataList: dataList,
                          loadDataFunction: _loadData,
                          listItemWidget: (item) => SinglePaymentUserItem(item),
                        ),
                      ),
                    ],
                  ),
                )
              : LoginFirstWidget(),
        ),
      ),
      drawer: MainPage.homeDrawer,
      drawerEdgeDragWidth: 25,
    );
  }

  Widget _totalsSection() {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(str.app.totalBills, style: CustomTheme.title1),
              SizedBox(width: 10),
              Text(GlobalVar.doubleToString(totalBills) + ' ${GlobalVar.appCurrency}', style: CustomTheme.numberStyle.copyWith(fontSize: 15))
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(str.app.totalVisites, style: CustomTheme.title1),
              SizedBox(width: 10),
              Text(totalvisites.toString(), style: CustomTheme.numberStyle.copyWith(fontSize: 15))
            ],
          )
        ],
      ),
    );
  }

  Future<dynamic> _loadData(int page) async {
    try {
      var res = await DoctorServices().getUserBills(page: page);
      List<Meeting> list = [];
      res['bills'].forEach((v) => list.add(Meeting.fromJson(v)));
      setState(() {
        if (page == 0) {
          totalBills = 0;
          totalvisites = 0;
        }
        totalBills += res['totalAmount'];
        totalvisites += res['meetingCount'];
      });
      return list.reversed.toList();
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
