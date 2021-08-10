import '../../../classes/models/payment.dart';
import '../../../classes/providers/doctor_services.dart';
import '../../../generated/locale_base.dart';
import '../../../ui/widgets/meeting_widget.dart';
import '../../../util/custome_widgets/infinite_listview.dart';
import '../../../util/custome_widgets/loading.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/utility/custom_theme.dart';
import '../../../util/utility/global_var.dart';
import 'package:flutter/material.dart';

import '../main_page.dart';

class PaymentDoctorPage extends StatefulWidget {
  static const String routeName = '/MeetingsPage';
  @override
  _PaymentDoctorPageState createState() => _PaymentDoctorPageState();
}

class _PaymentDoctorPageState extends State<PaymentDoctorPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Payment> dataList = [];
  double totalBills = 0;
  double unPaidCount = 0;
  int totalvisites = 0;
  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(str.app.payments),
      ),
      body: SafeArea(
        child: FullScreenLoading(
          inAsyncCall: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _totalsSection(),
                Expanded(
                  child: InfiniteListview(
                    dataList: dataList,
                    loadDataFunction: _loadData,
                    listItemWidget: (item) => SinglePaymentDoctorItem(item),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: MainPage.homeDrawer,
      drawerEdgeDragWidth: 25,
    );
  }

  Widget _totalsSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(str.app.totalBills, style: CustomTheme.title2),
              SizedBox(width: 10),
              Text(GlobalVar.doubleToString(totalBills) + ' ${GlobalVar.appCurrency}', style: CustomTheme.numberStyle.copyWith(fontSize: 15)),
              Spacer(),
              Text(str.app.totalVisites, style: CustomTheme.title2),
              SizedBox(width: 10),
              Text(totalvisites.toString(), style: CustomTheme.numberStyle.copyWith(fontSize: 15)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(str.app.visiteUnPaid, style: CustomTheme.title2.copyWith(color: CustomTheme.redColor)),
                    SizedBox(width: 10),
                    Text(GlobalVar.doubleToString(unPaidCount) + ' ${GlobalVar.appCurrency}',
                        style: CustomTheme.numberStyle.copyWith(fontSize: 15, color: CustomTheme.redColor))
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> _loadData(int page) async {
    try {
      var res = await DoctorServices().getDoctorBills(page: page);
      List<Payment> list = [];
      res['payments'].forEach((v) => list.add(Payment.fromJson(v)));
      setState(() {
        if (page == 0) {
          totalBills = 0;
          unPaidCount = 0;
          totalvisites = 0;
        }
        totalBills += res['totalAmount'];
        unPaidCount += res['unPaidCount'];
        totalvisites += res['meetingCount'];
      });
      return list;
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
