import '../../../classes/models/specialty.dart';
import '../../../classes/models/user.dart';
import '../../../classes/providers/doctor_services.dart';
import '../../../ui/pages/doctors/doctor_widget.dart';
import '../../../util/custome_widgets/infinite_listview.dart';
import '../../../util/custome_widgets/loading.dart';
import '../../../util/custome_widgets/messages.dart';
import 'package:flutter/material.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';
import '../main_page.dart';

class SpecialtiesDoctorsPage extends StatefulWidget {
  static const String routeName = '/SpecialtiesDoctorsPage';
  final Specialty specialty;
  SpecialtiesDoctorsPage(this.specialty);
  @override
  _SpecialtiesDoctorsPageState createState() => _SpecialtiesDoctorsPageState();
}

class _SpecialtiesDoctorsPageState extends State<SpecialtiesDoctorsPage> {
  List<User> dataList = [];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    theme = Theme.of(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.specialty == null ? str.app.doctors : widget.specialty?.title),
      ),
      body: _mainBody(),
      drawer: widget.specialty != null ? null : MainPage.homeDrawer,
    );
  }

  SafeArea _mainBody() {
    return SafeArea(
      child: FullScreenLoading(
        inAsyncCall: _isLoading,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InfiniteListview(
            dataList: dataList,
            loadDataFunction: loadUserAds,
            listItemWidget: (item) => SingleDoctorlistItem(item),
          ),
        ),
      ),
    );
  }

  Future<dynamic> loadUserAds(int page) async {
    try {
      return await DoctorServices().search(specialityId: widget.specialty?.id, page: page);
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
