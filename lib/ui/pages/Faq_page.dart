import 'dart:developer';

import '../../util/custome_widgets/loading.dart';
import '../../util/custome_widgets/messages.dart';
import '../../util/utility/custom_theme.dart';
import 'package:flutter/material.dart';
import '../../generated/locale_base.dart';
import '../../util/utility/global_var.dart';
import 'package:provider/provider.dart';
import '../../classes/providers/initial_data_provider.dart';
import 'main_page.dart';

class FaqPage extends StatefulWidget {
  static const String routeName = '/FaqPage';
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  InitialDataProvider initialDataProvider;
  List<Map<String, dynamic>> dataList = [];
  @override
  void initState() {
    Future.microtask(() => _loadData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initialDataProvider = Provider.of<InitialDataProvider>(context);
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(str.main.faqs),
      ),
      body: SafeArea(
        child: FullScreenLoading(
            inAsyncCall: _isLoading,
            child: SingleChildScrollView(
              child: Column(
                children: dataList
                    .map(
                      (e) => ExpansionTile(
                        title: Container(
                          child: Text(
                            e['question'] ?? "",
                            style: CustomTheme.title3,
                          ),
                        ),
                        childrenPadding: EdgeInsetsDirectional.only(start: 35),
                        children: [
                          Container(
                            width: double.infinity,
                            alignment: AlignmentDirectional.centerStart,
                            padding: EdgeInsets.all(5),
                            child: Text(e['answer'] ?? ""),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            )),
      ),
      drawer: MainPage.homeDrawer,
      drawerEdgeDragWidth: 25,
    );
  }

  void _loadData() async {
    setIsLoading(true);
    try {
      List res = await initialDataProvider.getFaqPage();
      log(res.toString());
      if (res != null) {
        res.forEach((element) {
          dataList.add(element);
        });
      }
    } catch (err) {
      showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
    }
    setIsLoading(false);
  }

  bool _isLoading = false;
  void setIsLoading(bool value) {
    if (mounted)
      setState(() {
        _isLoading = value;
      });
  }
}
