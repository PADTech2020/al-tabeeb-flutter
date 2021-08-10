import 'package:elajkom/classes/models/specialty.dart';
import 'package:elajkom/classes/models/user.dart';
import 'package:elajkom/classes/providers/doctor_services.dart';
import 'package:elajkom/ui/widgets/app_widgets.dart';
import 'package:elajkom/util/custome_widgets/messages.dart';
import 'package:flutter/material.dart';
import '../../util/utility/custom_theme.dart';
import '../../generated/locale_base.dart';
import '../../util/utility/global_var.dart';
import 'package:provider/provider.dart';
import '../../classes/providers/initial_data_provider.dart';
import 'doctors/doctor_widget.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = '/SearchPage';
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  InitialDataProvider initialDataProvider;
  Specialty selectedSpecialty;
  List<User> dataList = [];
  bool pageFirstStart = true;
  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    initialDataProvider = Provider.of<InitialDataProvider>(context);
    if (selectedSpecialty == null) selectedSpecialty = GlobalVar.getFirstListItem(initialDataProvider.topSpecialties);
    return Scaffold(
      appBar: AppBar(
        title: Text(str.main.search),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [searchBar()],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index == dataList.length) if (_isLoading)
                  return Padding(padding: const EdgeInsets.all(8.0), child: Center(child: CircularProgressIndicator()));
                else if (dataList.length == 0)
                  return pageFirstStart ? SizedBox() : ErrorCustomWidget(str.msg.noDataAvailable, showErrorWord: false);
                else
                  return SizedBox();
                return SingleDoctorlistItem(dataList[index]);
              }, childCount: dataList.length + 1),
            )
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 15),
          Text(str.app.findADoctor, style: CustomTheme.title1.copyWith(color: CustomTheme.accentColor, fontSize: 26)),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                    border: OutlineInputBorder(borderSide: BorderSide(color: CustomTheme.accentColor)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: CustomTheme.accentColor)),
                    focusColor: CustomTheme.accentColor,
                    hintText: str.main.search,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                // child: CustomTextFormField(controller: searchController, hintText: str.main.search),
              ),
              SizedBox(width: 1),
              ElevatedButton(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(str.main.search, style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.search, color: Colors.white, size: 20),
                    ],
                  ),
                  onPressed: loadUserAds),
            ],
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: initialDataProvider.topSpecialties
                  .map((e) => SingleCategory(e, () => _selectCategory(e), active: e.id == selectedSpecialty.id))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _selectCategory(Specialty cat) {
    if (cat.id != selectedSpecialty.id)
      setState(() {
        selectedSpecialty = cat;
      });
  }

  Future<dynamic> loadUserAds([int page = 0]) async {
    dataList.clear();
    pageFirstStart = false;
    FocusScope.of(context).unfocus();
    setIsLoading(true);
    try {
      dataList = await DoctorServices().search(search: searchController.text, specialityId: selectedSpecialty?.id, page: page, take: 200);
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
