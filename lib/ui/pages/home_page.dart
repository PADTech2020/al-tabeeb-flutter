import 'package:carousel_slider/carousel_slider.dart';
import 'package:elajkom/classes/providers/notification_provider.dart';
import 'package:elajkom/ui/widgets/app_widgets.dart';
import 'package:elajkom/util/custome_widgets/badge.dart';
import '../../classes/providers/initial_data_provider.dart';
import '../../ui/pages/main_page.dart';
import '../../ui/widgets/banner_widgets.dart';
import '../../ui/widgets/specialtie.dart';
import '../../util/utility/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/locale_base.dart';
import '../../util/utility/global_var.dart';
import 'doctors/doctor_widget.dart';
import 'notification_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/HomePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InitialDataProvider initialDataProvider;
  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    initialDataProvider = Provider.of<InitialDataProvider>(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate([
              _banners(),
              _specialties(),
              SizedBox(height: 15),
              _mostViewedDoctors(),
            ])),
            SliverToBoxAdapter(child: SizedBox(height: 15)),
          ],
        ),
      ),
      drawer: MainPage.homeDrawer,
      drawerEdgeDragWidth: 25,
    );
  }

  AppBar buildAppBar() {
    String logoName = GlobalVar.assetsImageBase + "logo-land-grey-";
    logoName += (GlobalVar.initializationLanguage == "ar" ? "ar" : "en") + ".png";
    return AppBar(
      title: Image.asset(logoName, height: 40), //Text(str.main.home),
      actions: [
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(NotificationPage.routeName),
          child: Consumer<NotificationProvider>(
            builder: (context, value, child) => Badge(value: value.notificationItemCount, child: child),
            child: IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () => Navigator.of(context).pushNamed(NotificationPage.routeName),
            ),
          ),
        ),
        MainSearchButton(),
      ],
    );
  }

  Widget _banners() {
    if (initialDataProvider.banners.length > 0)
      return CarouselSlider(
        items: initialDataProvider.banners.map((item) {
          return SingleBannerItem(item);
        }).toList(),
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 4 / 3,
          viewportFraction: 1.0,
          enlargeCenterPage: true,
        ),
      );
    else
      return SizedBox();
  }

  Widget _specialties() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 16, start: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(str.app.specialties, style: CustomTheme.title1),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: initialDataProvider.homeSpecialties.map((e) => SingelSpecialtieItme(e)).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _mostViewedDoctors() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(str.app.mostViewedDoctors, style: CustomTheme.title1),
          SizedBox(height: 10),
          SingleChildScrollView(
            child: Column(
              children: initialDataProvider.mostViewedDoctors.map((e) => SingleDoctorlistItem(e)).toList(),
            ),
          )
        ],
      ),
    );
  }
}
