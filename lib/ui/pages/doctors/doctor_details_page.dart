import '../../../classes/models/user.dart';
import '../../../classes/providers/doctor_services.dart';
import '../../../classes/providers/user_provider.dart';
import '../../../generated/locale_base.dart';
import '../../../ui/pages/doctors/book_page.dart';
import '../../../util/custome_widgets/button.dart';
import '../../../util/custome_widgets/loading.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/utility/global_var.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'doctor_widget.dart';

class DoctorDetailsPage extends StatefulWidget {
  static const String routeName = '/DoctorDetailsPage';
  final String id;
  DoctorDetailsPage(this.id);
  @override
  _DoctorDetailsPageState createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  UserProvider userProvider;
  Future loadAdsFuture;
  User doctor;
  Size size;
  @override
  void initState() {
    loadAdsFuture = DoctorServices().loadDoctorDetails(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    theme = Theme.of(context);
    size = MediaQuery.of(context).size;
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: FutureBuilder(
        future: loadAdsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return FullScreenLoading(inAsyncCall: true, child: SizedBox());
          } else if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
            doctor = snapshot.data;
            return _body();
          } else {
            return Center(child: ErrorCustomWidget(snapshot.error.toString() ?? str.msg.errConnectionServer));
          }
        },
      ),
      floatingActionButton: ButtonWidget(
        str.app.bookNow,
        () => Navigator.of(context).pushNamed(BookPage.routeName, arguments: doctor),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(title: Text(str.app.doctorPage));
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          MainInfoDoctor(doctor),
          SizedBox(height: 2),
          YoutubeVideoWidget(doctor),
          SizedBox(height: 2),
          BioDoctor(doctor),
          SizedBox(height: 2),
          EeducationalDoctorSection(doctor),
          SizedBox(height: 2),
          PriceTableDoctor(doctor),
          SizedBox(height: 2),
          WorkTimesTableDoctor(doctor),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}
