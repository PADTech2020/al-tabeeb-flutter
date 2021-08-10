import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../classes/providers/user_provider.dart';
import '../../../ui/pages/account/my_profile.dart';
import '../../../ui/pages/splash_page.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';
import 'my_doctor_profile.dart';

class AccountPage extends StatefulWidget {
  static const String routeName = '/AccountPage';
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  UserProvider userProvider;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    theme = Theme.of(context);
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: buildAppBar(),
      body: SafeArea(
        child: userProvider.user?.role == 2 ? MyDoctorProfile() : MyProfile(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Text(str.main.myAccount),
      actions: <Widget>[
        TextButton(
          child: Text(str.formAndAction.logout, style: TextStyle(color: Colors.white)),
          style: TextButton.styleFrom(textStyle: TextStyle(color: Colors.white)),
          onPressed: () async {
            showDialog(
              builder: (context) => CustomDialog(
                message: str.msg.logoutConfirm,
                actions: <Widget>[
                  TextButton(
                    child: Text(str.formAndAction.logout),
                    onPressed: () async {
                      await userProvider.logout(context);
                      Navigator.pushNamedAndRemoveUntil(context, SplashPage.routeName, (route) => false);
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
          },
        ),
      ],
    );
  }
}
