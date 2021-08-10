import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LocaleBase {
  Map<String, dynamic> _data;
  String _path;
  Future<void> load(String path) async {
    _path = path;
    final strJson = await rootBundle.loadString(path);
    _data = jsonDecode(strJson);
    initAll();
  }
  
  Map<String, String> getData(String group) {
    return Map<String, String>.from(_data[group]);
  }

  String getPath() => _path;

  Localeapp _app;
  Localeapp get app => _app;
  LocaleformAndAction _formAndAction;
  LocaleformAndAction get formAndAction => _formAndAction;
  Localemain _main;
  Localemain get main => _main;
  Localemsg _msg;
  Localemsg get msg => _msg;

  void initAll() {
    _app = Localeapp(Map<String, String>.from(_data['app']));
    _formAndAction = LocaleformAndAction(Map<String, String>.from(_data['formAndAction']));
    _main = Localemain(Map<String, String>.from(_data['main']));
    _msg = Localemsg(Map<String, String>.from(_data['msg']));
  }
}

class Localeapp {
  final Map<String, String> _data;
  Localeapp(this._data);

  String getByKey(String key) {
    return _data[key];
  }

  String get specialties => _data["specialties"];
  String get specialtie => _data["specialtie"];
  String get doctor => _data["doctor"];
  String get mostViewedDoctors => _data["mostViewedDoctors"];
  String get bookNow => _data["bookNow"];
  String get dr => _data["dr"];
  String get certificates => _data["certificates"];
  String get experiences => _data["experiences"];
  String get experiencesAr => _data["experiencesAr"];
  String get experiencesEn => _data["experiencesEn"];
  String get experiencesTr => _data["experiencesTr"];
  String get courses => _data["courses"];
  String get coursesAr => _data["coursesAr"];
  String get coursesEn => _data["coursesEn"];
  String get coursesTr => _data["coursesTr"];
  String get educationalTitle => _data["educationalTitle"];
  String get bio => _data["bio"];
  String get priceTable => _data["priceTable"];
  String get time => _data["time"];
  String get price => _data["price"];
  String get voice => _data["voice"];
  String get video => _data["video"];
  String get chat => _data["chat"];
  String get workTimes => _data["workTimes"];
  String get availabilDays => _data["availabilDays"];
  String get availabilTimes => _data["availabilTimes"];
  String get doctorPage => _data["doctorPage"];
  String get appointmentBooking => _data["appointmentBooking"];
  String get bookingDetails => _data["bookingDetails"];
  String get bookingDuration => _data["bookingDuration"];
  String get bookingTime => _data["bookingTime"];
  String get bookingType => _data["bookingType"];
  String get noBookinAvailabil => _data["noBookinAvailabil"];
  String get selectBookingTimeMsg => _data["selectBookingTimeMsg"];
  String get bookingDoneMsg => _data["bookingDoneMsg"];
  String get doctors => _data["doctors"];
  String get updatePersonalInfo => _data["updatePersonalInfo"];
  String get updateEducationalInfo => _data["updateEducationalInfo"];
  String get updatePriceInfo => _data["updatePriceInfo"];
  String get updateWorkTimesInfo => _data["updateWorkTimesInfo"];
  String get timeUnit => _data["timeUnit"];
  String get valueMustLessThan => _data["valueMustLessThan"];
  String get valueMustGreatThan => _data["valueMustGreatThan"];
  String get day => _data["day"];
  String get fromHour => _data["fromHour"];
  String get toHour => _data["toHour"];
  String get to => _data["to"];
  String get appointments => _data["appointments"];
  String get visites => _data["visites"];
  String get payments => _data["payments"];
  String get chooseDateFirst => _data["chooseDateFirst"];
  String get timeUnitShortcut => _data["timeUnitShortcut"];
  String get reportMeeting => _data["reportMeeting"];
  String get comunicate => _data["comunicate"];
  String get reportMissedMeetingSuccess => _data["reportMissedMeetingSuccess"];
  String get billCode => _data["billCode"];
  String get visiteCode => _data["visiteCode"];
  String get paymentAmount => _data["paymentAmount"];
  String get doctorName => _data["doctorName"];
  String get visiteDay => _data["visiteDay"];
  String get totalBills => _data["totalBills"];
  String get totalVisites => _data["totalVisites"];
  String get paymentInfo => _data["paymentInfo"];
  String get nameOnCard => _data["nameOnCard"];
  String get cardNum => _data["cardNum"];
  String get cardExpireDate => _data["cardExpireDate"];
  String get cardCode => _data["cardCode"];
  String get purchase => _data["purchase"];
  String get month => _data["month"];
  String get year => _data["year"];
  String get bills => _data["bills"];
  String get amountOfVisites => _data["amountOfVisites"];
  String get visitesCode => _data["visitesCode"];
  String get visiteUnPaid => _data["visiteUnPaid"];
  String get meetingTimeNotYet => _data["meetingTimeNotYet"];
  String get meetingTimepass => _data["meetingTimepass"];
  String get passportFirstName => _data["passportFirstName"];
  String get passportLastName => _data["passportLastName"];
  String get birthday => _data["birthday"];
  String get nationality => _data["nationality"];
  String get gender => _data["gender"];
  String get male => _data["male"];
  String get female => _data["female"];
  String get bankInformation => _data["bankInformation"];
  String get bankName => _data["bankName"];
  String get turkIban => _data["turkIban"];
  String get dollarIban => _data["dollarIban"];
  String get workAddress => _data["workAddress"];
  String get licenceStatus => _data["licenceStatus"];
  String get unLicence => _data["unLicence"];
  String get licence => _data["licence"];
  String get licenceWord => _data["licenceWord"];
  String get licenceIssuer => _data["licenceIssuer"];
  String get college => _data["college"];
  String get findADoctor => _data["findADoctor"];
  String get youTubeVideoUrl => _data["youTubeVideoUrl"];
  String get ratingMsg => _data["ratingMsg"];
  String get meetingReminder => _data["meetingReminder"];
  String get none => _data["none"];
  String get tenMin => _data["tenMin"];
  String get twentyMin => _data["twentyMin"];
  String get fourtyMin => _data["fourtyMin"];
  String get minutes => _data["minutes"];
  String get openTokConfigurationError => _data["openTokConfigurationError"];
  String get openTokConnectionLost => _data["openTokConnectionLost"];
  String get openTaoCallEnd => _data["openTaoCallEnd"];
  String get certificatesAr => _data["certificatesAr"];
  String get certificatesEn => _data["certificatesEn"];
  String get certificatesTr => _data["certificatesTr"];
  String get updateBankInfo => _data["updateBankInfo"];
  String get langs => _data["langs"];
  String get location => _data["location"];
  String get hospital => _data["hospital"];
  String get qualificationsAndExperiences => _data["qualificationsAndExperiences"];
  String get creditCardNumber => _data["creditCardNumber"];
  String get paymentSucess => _data["paymentSucess"];
  String get paymentFail => _data["paymentFail"];
  String get maximumFileSize => _data["maximumFileSize"];
  String get bookedAt => _data["bookedAt"];
  String get hospitals => _data["hospitals"];
  String get clinics => _data["clinics"];
  String get laboratories => _data["laboratories"];
  String get rays => _data["rays"];
  String get specials => _data["specials"];
  String get medicalTourism => _data["medicalTourism"];
  String get vipServices => _data["vipServices"];
  String get medicalCenters => _data["medicalCenters"];
}

class LocaleformAndAction {
  final Map<String, String> _data;
  LocaleformAndAction(this._data);

  String getByKey(String key) {
    return _data[key];
  }

  String get logIn => _data["logIn"];
  String get signup => _data["signup"];
  String get username => _data["username"];
  String get email => _data["email"];
  String get password => _data["password"];
  String get phone => _data["phone"];
  String get logout => _data["logout"];
  String get changePassword => _data["changePassword"];
  String get save => _data["save"];
  String get oldPassword => _data["oldPassword"];
  String get newPassword => _data["newPassword"];
  String get update => _data["update"];
  String get title => _data["title"];
  String get theMessage => _data["theMessage"];
  String get send => _data["send"];
  String get name => _data["name"];
  String get skip => _data["skip"];
  String get registerMsg => _data["registerMsg"];
  String get orLoginBy => _data["orLoginBy"];
  String get googleLogin => _data["googleLogin"];
  String get facebookLogin => _data["facebookLogin"];
  String get account => _data["account"];
  String get profile => _data["profile"];
  String get alreadyHaveAnAccount => _data["alreadyHaveAnAccount"];
  String get fullName => _data["fullName"];
  String get confirmPassword => _data["confirmPassword"];
  String get forgetPassword => _data["forgetPassword"];
  String get personalAccount => _data["personalAccount"];
  String get resetPassword => _data["resetPassword"];
  String get emailOrPhone => _data["emailOrPhone"];
  String get code => _data["code"];
  String get firstName => _data["firstName"];
  String get lastName => _data["lastName"];
  String get countryPhoneCode => _data["countryPhoneCode"];
  String get personalPage => _data["personalPage"];
  String get displayName => _data["displayName"];
  String get user => _data["user"];
  String get choosFile => _data["choosFile"];
}

class Localemain {
  final Map<String, String> _data;
  Localemain(this._data);

  String getByKey(String key) {
    return _data[key];
  }

  String get lang => _data["lang"];
  String get setting => _data["setting"];
  String get changeLanguage => _data["changeLanguage"];
  String get faqs => _data["faqs"];
  String get howToUse => _data["howToUse"];
  String get english => _data["english"];
  String get arabic => _data["arabic"];
  String get home => _data["home"];
  String get privacyPolicy => _data["privacyPolicy"];
  String get termOfUse => _data["termOfUse"];
  String get search => _data["search"];
  String get more => _data["more"];
  String get less => _data["less"];
  String get contactUs => _data["contactUs"];
  String get image => _data["image"];
  String get report => _data["report"];
  String get block => _data["block"];
  String get clear => _data["clear"];
  String get delete => _data["delete"];
  String get clearChat => _data["clearChat"];
  String get enterMsg => _data["enterMsg"];
  String get chats => _data["chats"];
  String get cancel => _data["cancel"];
  String get retry => _data["retry"];
  String get appName => _data["appName"];
  String get camera => _data["camera"];
  String get gallery => _data["gallery"];
  String get addCaption => _data["addCaption"];
  String get welcom => _data["welcom"];
  String get active => _data["active"];
  String get myAccount => _data["myAccount"];
  String get all => _data["all"];
  String get images => _data["images"];
  String get next => _data["next"];
  String get ok => _data["ok"];
  String get seeAll => _data["seeAll"];
  String get map => _data["map"];
  String get edit => _data["edit"];
  String get yes => _data["yes"];
  String get no => _data["no"];
  String get later => _data["later"];
  String get unBLock => _data["unBLock"];
  String get add => _data["add"];
  String get message => _data["message"];
  String get profilPage => _data["profilPage"];
  String get about => _data["about"];
  String get paymentPolicy => _data["paymentPolicy"];
  String get followUs => _data["followUs"];
  String get turk => _data["turk"];
  String get notifications => _data["notifications"];
  String get arabicTrans => _data["arabicTrans"];
  String get englishTrans => _data["englishTrans"];
  String get turkishTrans => _data["turkishTrans"];
  String get back => _data["back"];
  String get details => _data["details"];
}

class Localemsg {
  final Map<String, String> _data;
  Localemsg(this._data);

  String getByKey(String key) {
    return _data[key];
  }

  String get errorOccurred => _data["errorOccurred"];
  String get shareMsg => _data["shareMsg"];
  String get noInternet => _data["noInternet"];
  String get updateSucceeded => _data["updateSucceeded"];
  String get sendingFailed => _data["sendingFailed"];
  String get sendingDone => _data["sendingDone"];
  String get sentSuccesfully => _data["sentSuccesfully"];
  String get wrongUsernameOrPassword => _data["wrongUsernameOrPassword"];
  String get errConnectionServer => _data["errConnectionServer"];
  String get errorPageRouting => _data["errorPageRouting"];
  String get loginError => _data["loginError"];
  String get invalidUsername => _data["invalidUsername"];
  String get loginFaild => _data["loginFaild"];
  String get loginLater => _data["loginLater"];
  String get invalidEmail => _data["invalidEmail"];
  String get passwordShort => _data["passwordShort"];
  String get invalidPhone => _data["invalidPhone"];
  String get invalidTitle => _data["invalidTitle"];
  String get invalidName => _data["invalidName"];
  String get loginFirst => _data["loginFirst"];
  String get confirmPasswordIncorrect => _data["confirmPasswordIncorrect"];
  String get logininToContinue => _data["logininToContinue"];
  String get createAccuont => _data["createAccuont"];
  String get fillField => _data["fillField"];
  String get pleaseAddImage => _data["pleaseAddImage"];
  String get fillFieldNumber => _data["fillFieldNumber"];
  String get fillFieldInt => _data["fillFieldInt"];
  String get logoutConfirm => _data["logoutConfirm"];
  String get exitConfirmation => _data["exitConfirmation"];
  String get imageNotSaved => _data["imageNotSaved"];
  String get noMessagesAvailable => _data["noMessagesAvailable"];
  String get deleteConfermation => _data["deleteConfermation"];
  String get noDataAvailable => _data["noDataAvailable"];
  String get saveSucceeded => _data["saveSucceeded"];
  String get errorDateFormat => _data["errorDateFormat"];
  String get noNotificationsAvailable => _data["noNotificationsAvailable"];
  String get enterEmail => _data["enterEmail"];
  String get enterPhone => _data["enterPhone"];
  String get cameraPermissios => _data["cameraPermissios"];
  String get microphonePermissios => _data["microphonePermissios"];
  String get activationCodeSendToEmail => _data["activationCodeSendToEmail"];
  String get pleaseChooseOntOfThese => _data["pleaseChooseOntOfThese"];
}

