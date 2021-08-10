import 'dart:developer';
import 'dart:io';

import 'package:elajkom/ui/widgets/app_widgets.dart';
import 'package:elajkom/util/custome_widgets/ChipsInput.dart';
import 'package:elajkom/util/utility/api_provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../../classes/models/user.dart';
import '../../../classes/providers/user_provider.dart';
import '../../../util/custome_widgets/button.dart';
import '../../../util/custome_widgets/dropdown_widget.dart';
import '../../../util/custome_widgets/loading.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/custome_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../util/utility/custom_theme.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';

class UpdateEducationalSectionPage extends StatefulWidget {
  static const String routeName = '/UpdateEducationalSectionPage';
  @override
  _UpdateEducationalSectionPageState createState() => _UpdateEducationalSectionPageState();
}

class _UpdateEducationalSectionPageState extends State<UpdateEducationalSectionPage> {
  UserProvider userProvider;
  bool initializedData = false;

  List<String> certificatesArArr = [];
  List<String> certificatesEnArr = [];
  List<String> certificatesTrArr = [];
  List<String> coursesArArr = [];
  List<String> coursesEnArr = [];
  List<String> coursesTrArr = [];
  List<String> experiencesArArr = [];
  List<String> experiencesEnArr = [];
  List<String> experiencesTrArr = [];

  List<String> langsArArr = [];
  List<String> langsEnArr = [];
  List<String> langsTrArr = [];

  String _locationAr;
  String _locationEn;
  String _locationTr;
  String _hospitalAr;
  String _hospitalEn;
  String _hospitalTr;

  String _workAddress;
  int _licenceStatus;
  String _licenceIssuer;
  String _college;
  Size size;
  PlatformFile _cvFile;
  PlatformFile _licenceFile;

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    userProvider = Provider.of<UserProvider>(context);
    size = MediaQuery.of(context).size;
    if (!initializedData) initData();
    return Scaffold(
      appBar: AppBar(
        title: Text(str.app.qualificationsAndExperiences),
      ),
      body: SafeArea(
        child: FullScreenLoading(
          inAsyncCall: _isLoading,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(GlobalVar.assetsImageBase + "certificates.png", width: 30, color: CustomTheme.accentColor),
                      SizedBox(width: 10),
                      Text(str.app.educationalTitle, style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  ////////////////{ certificates } ////////////////
                  SizedBox(height: 15), Divider(), Text(str.app.certificates, style: TextStyle(fontSize: 18)),
                  _buildChipsInput(certificatesArArr, str.app.certificatesAr, (value) => certificatesArArr = value),
                  _buildChipsInput(certificatesEnArr, str.app.certificatesEn, (value) => certificatesEnArr = value),
                  _buildChipsInput(certificatesTrArr, str.app.certificatesTr, (value) => certificatesTrArr = value),
                  ////////////////{ courses } ////////////////
                  SizedBox(height: 15), Divider(), Text(str.app.courses, style: TextStyle(fontSize: 18)),
                  _buildChipsInput(coursesArArr, str.app.coursesAr, (value) => coursesArArr = value),
                  _buildChipsInput(coursesEnArr, str.app.coursesEn, (value) => coursesEnArr = value),
                  _buildChipsInput(coursesTrArr, str.app.coursesTr, (value) => coursesTrArr = value),
                  ////////////////{ experiences } ////////////////
                  SizedBox(height: 15), Divider(), Text(str.app.experiences, style: TextStyle(fontSize: 18)),
                  _buildChipsInput(experiencesArArr, str.app.experiencesAr, (value) => experiencesArArr = value),
                  _buildChipsInput(experiencesEnArr, str.app.experiencesEn, (value) => experiencesEnArr = value),
                  _buildChipsInput(experiencesTrArr, str.app.experiencesTr, (value) => experiencesTrArr = value),
                  // _educationalList(str.app.certificates, certificatesArr, _certTextController),
                  // Divider(),
                  // _educationalList(str.app.courses, coursesArr, _courseTextController),
                  // Divider(),
                  // _educationalList(str.app.experiences, experiencesArr, _expTextController),
                  // Divider(),
                  SizedBox(height: 15),
                  Divider(color: Colors.grey.shade500),
                  SizedBox(height: 15),
                  CustomTextFormField(
                    initialValue: userProvider.user.workAddress ?? '',
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 2,
                    labelText: str.app.workAddress,
                    onChanged: (String val) => _workAddress = val.trim(),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(flex: 1, child: Center(child: Text(str.app.licenceStatus))),
                      Expanded(
                        flex: 2,
                        child: DropdownWidget(
                          initValue: _licenceStatus == 1 ? str.app.licence : str.app.unLicence,
                          dataList: [str.app.licence, str.app.unLicence],
                          onChange: (item) => setState(() => _licenceStatus = item == str.app.licence ? 1 : 0),
                          borderShap: true,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  CustomTextFormField(
                    initialValue: userProvider.user.licenceIssuer ?? '',
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 2,
                    labelText: str.app.licenceIssuer,
                    onChanged: (String val) => _licenceIssuer = val.trim(),
                  ),
                  SizedBox(height: 15),
                  CustomTextFormField(
                    initialValue: userProvider.user.college ?? '',
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 2,
                    labelText: str.app.college,
                    onChanged: (String val) => _college = val.trim(),
                  ),
                  ////////////////{ langs } ////////////////
                  _buildChipsInput(langsArArr, str.app.langs + " " + str.main.arabicTrans, (value) => langsArArr = value),
                  _buildChipsInput(langsEnArr, str.app.langs + " " + str.main.englishTrans, (value) => langsEnArr = value),
                  _buildChipsInput(langsTrArr, str.app.langs + " " + str.main.turkishTrans, (value) => langsTrArr = value),

                  ////////////////{ location } ////////////////
                  SizedBox(height: 15),
                  CustomTextFormField(
                    initialValue: userProvider.user.locationAr ?? '',
                    keyboardType: TextInputType.text,
                    labelText: str.app.location + " " + str.main.arabicTrans,
                    onChanged: (String val) => _locationAr = val.trim(),
                  ),
                  SizedBox(height: 15),
                  CustomTextFormField(
                    initialValue: userProvider.user.locationEn ?? '',
                    keyboardType: TextInputType.text,
                    labelText: str.app.location + " " + str.main.englishTrans,
                    onChanged: (String val) => _locationEn = val.trim(),
                  ),
                  SizedBox(height: 15),
                  CustomTextFormField(
                    initialValue: userProvider.user.locationTr ?? '',
                    keyboardType: TextInputType.text,
                    labelText: str.app.location + " " + str.main.turkishTrans,
                    onChanged: (String val) => _locationTr = val.trim(),
                  ),

                  ////////////////{ location } ////////////////
                  SizedBox(height: 15),
                  CustomTextFormField(
                    initialValue: userProvider.user.hospitalAr ?? '',
                    keyboardType: TextInputType.text,
                    labelText: str.app.hospital + " " + str.main.arabicTrans,
                    onChanged: (String val) => _hospitalAr = val.trim(),
                  ),
                  SizedBox(height: 15),
                  CustomTextFormField(
                    initialValue: userProvider.user.hospitalEn ?? '',
                    keyboardType: TextInputType.text,
                    labelText: str.app.hospital + " " + str.main.englishTrans,
                    onChanged: (String val) => _hospitalEn = val.trim(),
                  ),
                  SizedBox(height: 15),
                  CustomTextFormField(
                    initialValue: userProvider.user.hospitalTr ?? '',
                    keyboardType: TextInputType.text,
                    labelText: str.app.hospital + " " + str.main.turkishTrans,
                    onChanged: (String val) => _hospitalTr = val.trim(),
                  ),

                  SizedBox(height: 25),
                  _buildFileSection(),

                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 5,
          color: CustomTheme.cardBackground,
          child: ButtonWidget(str.formAndAction.save, _submit, margin: EdgeInsets.symmetric(horizontal: 25, vertical: 8)),
        ),
      ),
    );
  }

  Widget _buildFileSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text('CV : ', style: TextStyle(fontSize: 16)),
            OutlinedButton(
              onPressed: () async {
                var res = await _filePicker();
                if (res != null) setState(() => _cvFile = res);
              },
              child: Text(str.formAndAction.choosFile),
            ),
            SizedBox(width: 10),
            Expanded(child: Text(_cvFile?.name?.split('/')?.last ?? "", style: TextStyle(fontSize: 12))),
            FileWidget(userProvider.user.cvFile),
          ],
        ),
        Divider(),
        Row(
          children: [
            Text(str.app.licenceWord + ' : ', style: TextStyle(fontSize: 16)),
            OutlinedButton(
              onPressed: () async {
                var res = await _filePicker();
                if (res != null) setState(() => _licenceFile = res);
              },
              child: Text(str.formAndAction.choosFile),
            ),
            SizedBox(width: 10),
            Expanded(child: Text(_licenceFile?.name?.split('/')?.last ?? "", style: TextStyle(fontSize: 12))),
            FileWidget(_licenceFile ?? userProvider.user.licenceFile),
          ],
        ),
      ],
    );
  }

  Future<PlatformFile> _filePicker() async {
    List<String> allowedExtensions = ['jpg', 'pdf', 'doc', 'docx'];
    PlatformFile file;
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );
      if (result != null) {
        if (!allowedExtensions.contains(result.files.single.extension)) {
          showDialog(
              builder: (context) => CustomDialog(message: str.msg.pleaseChooseOntOfThese + " " + allowedExtensions.join('/')), context: context);
        } else {
          file = result.files.single;
          log(file.path);
          log(file.name);
          log(file.extension);
          log(file.size.toString() + " Kb");
        }
      }
    } catch (err) {
      showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
    }
    return file;
  }

  Widget _buildChipsInput(List<String> initData, String labelText, Function(List<String>) onChanged) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      constraints: BoxConstraints(minHeight: 60, maxHeight: 600),
      child: ChipsInput<String>(
        initChips: initData,
        onChipTapped: (value) => log(value),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ),
        findSuggestions: _findSuggestions,
        onChanged: (value) {
          onChanged(value);
        },
        chipBuilder: (BuildContext context, ChipsInputState<String> state, String item) {
          return InputChip(
            key: ObjectKey(item),
            label: Text(item),
            onDeleted: () => state.deleteChip(item),
            // onSelected: (_) => _onChipTapped(item),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
        suggestionBuilder: (BuildContext context, ChipsInputState<String> state, String item) {
          log(item);
          if (item == null || item.isEmpty) return SizedBox();
          return Container(
            color: Colors.grey.shade300,
            child: ListTile(
              selected: true,
              key: ObjectKey(item),
              title: Text(item),
              onTap: () => state.selectSuggestion(item),
            ),
          );
        },
      ),
    );
  }

  Future<List<String>> _findSuggestions(String query) async {
    return <String>[query];
  }

  void initData() {
    {
      certificatesArArr = spiltFun(userProvider.user.certificatesAr);
      certificatesEnArr = spiltFun(userProvider.user.certificatesEn);
      certificatesTrArr = spiltFun(userProvider.user.certificatesTr);
    }
    {
      experiencesArArr = spiltFun(userProvider.user.experiencesAr);
      experiencesEnArr = spiltFun(userProvider.user.experiencesEn);
      experiencesTrArr = spiltFun(userProvider.user.experiencesTr);
    }
    {
      coursesArArr = spiltFun(userProvider.user.coursesAr);
      coursesEnArr = spiltFun(userProvider.user.coursesEn);
      coursesTrArr = spiltFun(userProvider.user.coursesTr);
    }
    {
      langsArArr = spiltFun(userProvider.user.langsAr);
      langsEnArr = spiltFun(userProvider.user.langsEn);
      langsTrArr = spiltFun(userProvider.user.langsTr);
    }
    if (_licenceStatus == null) _licenceStatus = userProvider.user.licenceStatus;
    _workAddress = userProvider.user.workAddress;
    _licenceIssuer = userProvider.user.licenceIssuer;
    _college = userProvider.user.college;
    _locationAr = userProvider.user.locationAr;
    _locationEn = userProvider.user.locationEn;
    _locationTr = userProvider.user.locationTr;
    _hospitalAr = userProvider.user.hospitalAr;
    _hospitalEn = userProvider.user.hospitalEn;
    _hospitalTr = userProvider.user.hospitalTr;
    initializedData = true;
  }

  List<String> spiltFun(String source) => (source != null && source.isNotEmpty) ? source.split(',') : [];

  void _submit() async {
    setIsLoading(true);
    try {
      User user = userProvider.user;

      if (_cvFile != null) {
        var cvFileName = await ApiProvider().uploadFiles(File(_cvFile.path));
        if (cvFileName != null) userProvider.user.cvFile = cvFileName;
      }
      if (_licenceFile != null) {
        var licenceFileName = await ApiProvider().uploadFiles(File(_licenceFile.path));
        if (licenceFileName != null) userProvider.user.licenceFile = licenceFileName;
      }

      user.certificatesAr = certificatesArArr.join(',');
      user.certificatesEn = certificatesEnArr.join(',');
      user.certificatesTr = certificatesTrArr.join(',');
      user.coursesAr = coursesArArr.join(',');
      user.coursesEn = coursesEnArr.join(',');
      user.coursesTr = coursesTrArr.join(',');
      user.experiencesAr = experiencesArArr.join(',');
      user.experiencesEn = experiencesEnArr.join(',');
      user.experiencesTr = experiencesTrArr.join(',');
      user.langsAr = langsArArr.join(',');
      user.langsEn = langsEnArr.join(',');
      user.langsTr = langsTrArr.join(',');

      user.locationAr = _locationAr;
      user.locationEn = _locationEn;
      user.locationTr = _locationTr;

      user.hospitalAr = _hospitalAr;
      user.hospitalEn = _hospitalEn;
      user.hospitalTr = _hospitalTr;

      user.workAddress = _workAddress;
      user.licenceStatus = _licenceStatus;
      user.licenceIssuer = _licenceIssuer;
      user.college = _college;
      await userProvider.updateAccount(user.toJson());
      setTranslationParam(user);
      userProvider.user = user;
      Navigator.pop(context);
    } catch (err) {
      showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
    }
    setIsLoading(false);
  }

  void setTranslationParam(User user) {
    if (GlobalVar.initializationLanguage == 'ar') {
      user.certificates = user.certificatesAr;
      user.courses = user.coursesAr;
      user.experiences = user.experiencesAr;
      user.lang = user.langsAr;
      user.location = user.locationAr;
    } else if (GlobalVar.initializationLanguage == 'en') {
      user.certificates = user.certificatesEn;
      user.courses = user.coursesEn;
      user.experiences = user.experiencesEn;
      user.lang = user.langsEn;
      user.location = user.locationEn;
    } else if (GlobalVar.initializationLanguage == 'tr') {
      user.certificates = user.certificatesTr;
      user.courses = user.coursesTr;
      user.experiences = user.experiencesTr;
      user.lang = user.langsTr;
      user.location = user.locationTr;
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
