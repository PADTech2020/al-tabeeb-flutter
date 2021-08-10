import 'package:elajkom/util/utility/lunch_url.dart';

import '../../classes/providers/initial_data_provider.dart';
import '../../ui/pages/Faq_page.dart';
import '../../ui/pages/account/account_page.dart';
import '../../ui/pages/account/login.dart';
import '../../ui/pages/content_page.dart';
import '../../ui/pages/doctors/payment_doctor_page.dart';
import '../../ui/pages/doctors/specialties_doctor_page.dart';
import '../../ui/pages/meetings_page.dart';
import '../../ui/pages/payment_user_page.dart';
import '../../ui/pages/specialty_page.dart';
import '../../ui/pages/visities_page.dart';
import '../../util/custome_widgets/button.dart';
import '../../util/custome_widgets/dropdown_widget.dart';
import '../../util/custome_widgets/image_widgets.dart';
import '../../util/utility/custom_theme.dart';
import '../../util/utility/global_var.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../classes/providers/user_provider.dart';
import '../../ui/pages/home_page.dart';

import '../../main.dart';

class HomeDrawer extends StatefulWidget {
  final Function drawerHandler;

  HomeDrawer(this.drawerHandler);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  UserProvider userProvider;
  InitialDataProvider initialDataProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    initialDataProvider = Provider.of<InitialDataProvider>(context);
    TextStyle textStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    double iconSize = 25;
    String logoName = GlobalVar.assetsImageBase + "logo-grey-";
    logoName += (GlobalVar.initializationLanguage == "ar" ? "ar" : "en") + ".png";
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Container(
              alignment: AlignmentDirectional.centerEnd,
              padding: EdgeInsetsDirectional.only(end: 16),
              child: userProvider.isLogin()
                  ? _profile()
                  : ButtonWidget(
                      str.formAndAction.logIn,
                      () => Navigator.of(context).pushNamed(LoginPage.routeName),
                    ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              image: DecorationImage(
                image: AssetImage(logoName),
                alignment: AlignmentDirectional.centerStart,
                fit: BoxFit.scaleDown,
                scale: 7.2,
              ),
              gradient: LinearGradient(
                begin: AlignmentDirectional.centerEnd,
                end: AlignmentDirectional.centerStart,
                colors: [Color(0xFF1670B9), Color(0xFF1285BB), Color(0xFF129CBF), Color(0xFF11B2C2)],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  title: Text(str.main.home, style: textStyle),
                  leading: Icon(Icons.home, size: iconSize),
                  onTap: () {
                    widget.drawerHandler(HomePage(), str.main.home);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(str.app.specialties, style: textStyle),
                  leading: Icon(Icons.bookmark, size: iconSize),
                  onTap: () {
                    widget.drawerHandler(SpecialtiesPage(), str.app.specialties);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(str.app.doctors, style: textStyle),
                  leading: Icon(Icons.supervised_user_circle, size: iconSize),
                  onTap: () {
                    widget.drawerHandler(SpecialtiesDoctorsPage(null), str.app.doctors);
                    Navigator.pop(context);
                  },
                ),
                if (userProvider.isLogin())
                  ListTile(
                    title: Text(str.app.appointments, style: textStyle),
                    leading: Icon(Icons.featured_play_list, size: iconSize),
                    onTap: () {
                      widget.drawerHandler(MeetingsPage(), str.app.doctors);
                      Navigator.pop(context);
                    },
                  ),
                if (userProvider.isLogin())
                  ListTile(
                    title: Text(str.app.visites, style: textStyle),
                    leading: Icon(Icons.view_list, size: iconSize),
                    onTap: () {
                      widget.drawerHandler(VisitesPage(), str.app.doctors);
                      Navigator.pop(context);
                    },
                  ),
                if (userProvider.isLogin())
                  ListTile(
                    title: Text(userProvider.user?.role == 2 ? str.app.payments : str.app.bills, style: textStyle),
                    leading: Icon(Icons.chrome_reader_mode, size: iconSize),
                    onTap: () {
                      if (userProvider.user?.role == 2)
                        widget.drawerHandler(PaymentDoctorPage(), str.app.doctors);
                      else if (userProvider.user?.role == 1) widget.drawerHandler(PaymentUserPage(), str.app.doctors);

                      Navigator.pop(context);
                    },
                  ),
                Divider(),
                ListTile(
                  title: Text(str.main.about, style: textStyle),
                  leading: SizedBox(),
                  onTap: () {
                    widget.drawerHandler(ContentPage(ContentPageType.About), str.main.about);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(str.main.faqs, style: textStyle),
                  leading: SizedBox(width: 15),
                  onTap: () {
                    widget.drawerHandler(FaqPage(), str.main.faqs);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(str.main.privacyPolicy, style: textStyle),
                  leading: SizedBox(),
                  onTap: () {
                    widget.drawerHandler(ContentPage(ContentPageType.PrivacyPolicy), str.main.privacyPolicy);
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                ListTile(
                  title: DropdownWidget(
                    initValue: GlobalVar.initializationLanguage == 'tr'
                        ? str.main.turk
                        : GlobalVar.initializationLanguage == 'ar'
                            ? str.main.arabic
                            : str.main.english,
                    dataList: [str.main.english, str.main.arabic, str.main.turk],
                    onChange: (item) {
                      String lan = item == str.main.arabic
                          ? 'ar'
                          : item == str.main.turk
                              ? 'tr'
                              : 'en';
                      _setAppLanguge(lan);
                    },
                  ),
                  leading: Icon(Icons.language),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(str.main.contactUs, style: CustomTheme.body1),
                ),
                ListTile(
                  dense: true,
                  title: Text(initialDataProvider.contactPhone ?? "", style: CustomTheme.body3),
                  leading: SizedBox(),
                  trailing: Icon(Icons.phone_iphone, color: CustomTheme.primaryColor),
                  onTap: () => launch("tel://" + initialDataProvider.contactPhone ?? ""),
                ),
                ListTile(
                  dense: true,
                  title: Text(initialDataProvider.contactEmail ?? "", style: CustomTheme.body3),
                  leading: SizedBox(),
                  trailing: Icon(Icons.email, color: CustomTheme.primaryColor),
                  onTap: () => launch("mailto:" + initialDataProvider.contactEmail ?? ""),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(str.main.followUs, style: CustomTheme.body1),
                ),
                ListTile(
                  dense: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if (initialDataProvider.facebookLink != null)
                        IconButton(
                          icon: Icon(FontAwesomeIcons.facebookF, color: Color(0xFF3b5999)),
                          onPressed: () async {
                            LunchUrl.canLaunch(initialDataProvider.facebookLink);
                          },
                        ),
                      if (initialDataProvider.instagramLink != null)
                        IconButton(
                          icon: Icon(FontAwesomeIcons.instagram, color: Color(0xFFe4405f)),
                          onPressed: () async {
                            LunchUrl.canLaunch(initialDataProvider.instagramLink);
                          },
                        ),
                      if (initialDataProvider.twitterLink != null)
                        IconButton(
                          icon: Icon(FontAwesomeIcons.twitter, color: Color(0xFF55acee)),
                          onPressed: () async {
                            LunchUrl.canLaunch(initialDataProvider.twitterLink);
                          },
                        ),
                      if (initialDataProvider.linkedInLink != null)
                        IconButton(
                          icon: Icon(FontAwesomeIcons.linkedin, color: CustomTheme.accentColor),
                          onPressed: () async {
                            LunchUrl.canLaunch(initialDataProvider.linkedInLink);
                          },
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setAppLanguge(String lang) async {
    try {
      if (GlobalVar.isLogin(context, showAlertDialog: false)) {
        // check user login
        userProvider.user.lang = lang;
        await userProvider.updateLang(lang);
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(GlobalVar.langKey, lang);
      GlobalVar.initializationLanguage = lang;
      GlobalVar.cloudMessaging.deleteInstance();
      InitWidget.restartApp(context);
    } catch (err) {}
  }

  Widget _profile() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).pushNamed(AccountPage.routeName);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularImageView(
            userProvider.user.profilePhoto,
            tapped: false,
            dimension: 100,
            border: Border.all(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(userProvider.user.fullName ?? "", style: CustomTheme.title1.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
