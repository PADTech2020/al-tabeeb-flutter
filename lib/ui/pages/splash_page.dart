import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../util/utility/api_provider.dart';
import '../../util/utility/custom_theme.dart';

import '../../generated/locale_base.dart';
import '../../util/utility/global_var.dart';
import '../../util/custome_widgets/messages.dart';
import '../../classes/providers/initial_data_provider.dart';
import '../../classes/providers/user_provider.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = '/';
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isLoading = false;
  double scalFactor = 0;
  UserProvider userProvider;
  InitialDataProvider initialDataProvider;
  Size size;

  void getInitData() async {
    setState(() {
      _isLoading = true;
    });
    bool initData = false, homeData = false;
    try {
      await userProvider.checkAuthorization(context);
      initialDataProvider.getInitData().then((value) {
        initData = true;
        userProvider.user = initialDataProvider.user;
        if (userProvider.user == null && ApiProvider.accessToken != null && ApiProvider.accessToken.isNotEmpty) {
          userProvider.logout(context);
        }
        if (homeData) Navigator.of(context).pushReplacementNamed(MainPage.routeName);
      }).catchError((err) => _errorHandl(err));
      initialDataProvider.getHomeData().then((value) {
        homeData = true;
        if (initData) Navigator.of(context).pushReplacementNamed(MainPage.routeName);
      }).catchError((err) => _errorHandl(err));
    } catch (err) {
      _errorHandl(err);
    }
  }

  void _errorHandl(err) {
    showDialog(
        builder: (context) => CustomDialog(
              message: err.toString(),
              actions: <Widget>[
                TextButton(child: Text(str.main.cancel), onPressed: () => Navigator.pop(context)),
                TextButton(
                    child: Text(str.main.retry),
                    onPressed: () {
                      Navigator.pop(context);
                      getInitData();
                    }),
              ],
            ),
        context: context);
  }

  @override
  void initState() {
    Future.microtask(() => getInitData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    userProvider = Provider.of<UserProvider>(context);
    initialDataProvider = Provider.of<InitialDataProvider>(context);
    theme = Theme.of(context);
    size = MediaQuery.of(context).size;
    String logoName = GlobalVar.assetsImageBase + "logo-1-";
    logoName += GlobalVar.initializationLanguage == "ar" ? "ar" : "en";
    logoName += ".png";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomTheme.cardBackground,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(_isLoading ? 25.0 : 25),
          child: Image.asset(
            logoName,
            width: (size.width),
            height: size.width * (16 / 9),
          ),
        ),
      ),
    );
  }
}
