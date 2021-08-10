import 'package:elajkom/ui/pages/doctors/update_bank_info_page.dart';

import '../../../classes/providers/user_provider.dart';
import '../../../ui/pages/doctors/doctor_widget.dart';
import '../../../ui/pages/doctors/update_educational_Section_page.dart';
import '../../../ui/pages/doctors/update_personal_info_page.dart';
import '../../../ui/pages/doctors/update_price_table_page.dart';
import '../../../ui/pages/doctors/update_work_times_page.dart';
import '../../../util/custome_widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';

class MyDoctorProfile extends StatefulWidget {
  static const String routeName = '/MyDoctorProfile';
  @override
  _MyDoctorProfileState createState() => _MyDoctorProfileState();
}

class _MyDoctorProfileState extends State<MyDoctorProfile> {
  UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MainInfoDoctor(userProvider.user),
            SizedBox(height: 2),
            YoutubeVideoWidget(userProvider.user),
            SizedBox(height: 2),
            BioDoctor(userProvider.user),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ButtonWidget(str.app.updatePersonalInfo, () => Navigator.of(context).pushNamed(UpdatePersonalInfoPage.routeName),
                      margin: EdgeInsets.symmetric(horizontal: 3), width: double.infinity),
                ),
                Expanded(
                  flex: 1,
                  child: ButtonWidget(str.app.updateBankInfo, () => Navigator.of(context).pushNamed(UpdateBankInfoPage.routeName),
                      margin: EdgeInsets.symmetric(horizontal: 3), width: double.infinity),
                ),
              ],
            ),
            SizedBox(height: 2),
            EeducationalDoctorSection(userProvider.user),
            ButtonWidget(str.formAndAction.update + " " + str.app.qualificationsAndExperiences,
                () => Navigator.of(context).pushNamed(UpdateEducationalSectionPage.routeName),
                margin: EdgeInsets.symmetric(horizontal: 15)),
            SizedBox(height: 2),
            PriceTableDoctor(userProvider.user),
            ButtonWidget(str.app.updatePriceInfo, () => Navigator.of(context).pushNamed(UpdatePriceTablePage.routeName),
                margin: EdgeInsets.symmetric(horizontal: 15)),
            SizedBox(height: 2),
            Divider(),
            WorkTimesTableDoctor(userProvider.user),
            ButtonWidget(str.app.updateWorkTimesInfo, () => Navigator.of(context).pushNamed(UpdateWorkeTimePage.routeName),
                margin: EdgeInsets.symmetric(horizontal: 15)),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
