import '../../classes/providers/initial_data_provider.dart';
import '../../ui/widgets/specialtie.dart';
import 'package:flutter/material.dart';
import '../../generated/locale_base.dart';
import '../../util/utility/global_var.dart';
import 'package:provider/provider.dart';

import 'main_page.dart';

class SpecialtiesPage extends StatefulWidget {
  static const String routeName = '/SpecialtiesPage';
  @override
  _SpecialtiesPageState createState() => _SpecialtiesPageState();
}

class _SpecialtiesPageState extends State<SpecialtiesPage> {
  Size size;
  InitialDataProvider initialDataProvider;
  @override
  Widget build(BuildContext context) {
    initialDataProvider = Provider.of<InitialDataProvider>(context);
    size = MediaQuery.of(context).size;
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    return Scaffold(
      appBar: AppBar(
        title: Text(str.app.specialties),
      ),
      body: SafeArea(
        child: GridView.count(
          padding: EdgeInsets.all(16),
          crossAxisCount: 2,
          shrinkWrap: false,
          children: initialDataProvider.specialties.map((e) => SingelSpecialtieItme(e)).toList(),
        ),
      ),
      drawer: MainPage.homeDrawer,
      drawerEdgeDragWidth: 25,
    );
  }
}
