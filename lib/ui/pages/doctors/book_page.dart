import 'package:elajkom/ui/pages/main_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../classes/models/meeting.dart';
import '../../../classes/models/meetingPrices.dart';
import '../../../classes/models/user.dart';
import '../../../classes/providers/doctor_services.dart';
import '../../../ui/pages/doctors/book_payment_page.dart';
import '../../../ui/sections/date_picker.dart';
import '../../../util/custome_widgets/button.dart';
import '../../../util/custome_widgets/dropdown_widget.dart';
import '../../../util/custome_widgets/loading.dart';
import '../../../util/custome_widgets/messages.dart';
import '../../../util/utility/custom_theme.dart';
import 'package:flutter/material.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';
import '../meetings_page.dart';

class BookPage extends StatefulWidget {
  static const String routeName = '/BookPage';
  final User doctor;
  final String id;
  BookPage({this.doctor, this.id});
  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  User doctor;
  MeetingPrices meetingPrices;
  List<DateTime> availableTimes = [];
  DateTime bookinTime;
  Size size;
  DateTime _selectedDate;
  MeetingType meetingType = MeetingType.Video;
  @override
  void initState() {
    _selectedDate = DateTime.now();
    if (widget.doctor == null) {
      _isLoading = true;
      Future.microtask(() => _loadDoctorDetails());
    } else {
      setDoctor(widget.doctor);
      Future.microtask(() => GlobalVar.isLogin(context));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(str.app.appointmentBooking),
      ),
      body: SafeArea(
        child: FullScreenLoading(
          inAsyncCall: _isLoading,
          child: _mainBody(),
        ),
      ),
    );
  }

  Widget _mainBody() {
    if (doctor != null) {
      if (GlobalVar.checkLisIsNotEmpty(doctor.availabilityPlans) && GlobalVar.checkLisIsNotEmpty(doctor.meetingPrices))
        return SingleChildScrollView(
          child: Column(
            children: [
              buildWeekDatePicker(),
              _bookingDetails(),
            ],
          ),
        );
      else
        return ErrorCustomWidget(str.app.noBookinAvailabil, icon: Icons.timer_off);
    } else if (_isLoading)
      return SizedBox();
    else
      return ErrorCustomWidget(str.msg.noDataAvailable);
  }

  Widget buildWeekDatePicker() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DatePickerWidget(
        _selectedDate,
        DateTime.now(),
        DateTime.now().add(Duration(days: 45)),
        width: size.width,
        onChange: (value) => _onSelectedDateChanged(value),
        isDayActive: (value) {
          int dayOfWeek = value.weekday;
          if (dayOfWeek == 7) dayOfWeek = 0;
          return doctor.availabilityPlans?.any((element) => element.isActive && element.dayOfWeek == dayOfWeek);
        },
      ),
    );
  }

  void _onSelectedDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
      _loadAvailableTimes();
    });
  }

  _bookingDetails() {
    return Container(
      width: size.width,
      color: CustomTheme.cardBackground,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(str.app.bookingDetails, style: CustomTheme.title2),
          SizedBox(height: 10),
          _bookinDoration(),
          SizedBox(height: 10),
          _bookinTime(),
          SizedBox(height: 25),
          _prices(),
          ButtonWidget(
            str.app.bookNow,
            sendFun,
            width: size.width,
            margin: EdgeInsets.all(25),
          ),
        ],
      ),
    );
  }

  Row _bookinDoration() {
    List<MeetingPrices> list = [];
    doctor.meetingPrices.forEach((element) {
      if (element.isActive) list.add(element);
    });

    return Row(
      children: [
        Expanded(child: Text(str.app.bookingDuration)),
        Expanded(
          child: DropdownWidget(
            dataList: list,
            initValue: meetingPrices,
            onChange: (item) {
              setState(() {
                meetingPrices = item;
                _loadAvailableTimes();
              });
            },
          ),
        )
      ],
    );
  }

  Row _prices() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonWidgetActive(
          child: Row(
            children: [
              Icon(Icons.videocam, color: meetingType == MeetingType.Video ? Colors.white : Colors.grey.shade700),
              SizedBox(width: 5),
              priceText(' ${meetingPrices.videoPrice}  ₺', meetingType == MeetingType.Video)
            ],
          ),
          onTap: () => setState(() => meetingType = MeetingType.Video),
          active: meetingType == MeetingType.Video,
          activeColor: CustomTheme.accentColor,
        ),
        ButtonWidgetActive(
          child: Row(
            children: [
              Icon(Icons.volume_up, color: meetingType == MeetingType.Voice ? Colors.white : Colors.grey.shade700),
              SizedBox(width: 5),
              priceText(' ${meetingPrices.audioPrice} ${GlobalVar.appCurrency} ', meetingType == MeetingType.Voice)
            ],
          ),
          onTap: () => setState(() => meetingType = MeetingType.Voice),
          active: meetingType == MeetingType.Voice,
          activeColor: CustomTheme.accentColor,
        ),
        ButtonWidgetActive(
          child: Row(
            children: [
              Icon(FontAwesomeIcons.solidComments, color: meetingType == MeetingType.Chat ? Colors.white : Colors.grey.shade700),
              SizedBox(width: 5),
              priceText(' ${meetingPrices.chatPrice} ${GlobalVar.appCurrency} ', meetingType == MeetingType.Chat)
            ],
          ),
          onTap: () => setState(() => meetingType = MeetingType.Chat),
          active: meetingType == MeetingType.Chat,
          activeColor: CustomTheme.accentColor,
        ),
      ],
    );
  }

  Widget priceText(String text, bool isActive) => Text(
        text,
        style: CustomTheme.numberStyle.copyWith(color: isActive ? Colors.white : Colors.black, fontWeight: FontWeight.w600),
        textScaleFactor: 1,
      );

  Row _bookinTime() {
    return Row(
      children: [
        Expanded(child: Text(str.app.bookingTime)),
        Expanded(
          child: DropdownWidget(
            dataList: availableTimes,
            initValue: bookinTime,
            onChange: (item) {
              setState(() {
                bookinTime = item;
              });
            },
            itemToString: (item) => GlobalVar.dateForamt(item, 'jm') ?? "",
          ),
        )
      ],
    );
  }

  void sendFun() async {
    if (GlobalVar.isLogin(context)) {
      if (bookinTime != null && meetingPrices != null) {
        setIsLoading(true);
        try {
          var id = await DoctorServices().addBookMeeting(doctor.id, bookinTime.toIso8601String(), meetingPrices.meetingDurationId, meetingType.index);
          // showDialog(context: context, child: CustomDialog(message: str.app.bookingDoneMsg)).then((value) => Navigator.pop(context));
          dynamic res = await Navigator.of(context).pushNamed(BookPaymentPage.routeName, arguments: id);
          if (res is bool && res) Navigator.pushNamedAndRemoveUntil(context, MainPage.routeName, (route) => false, arguments: MeetingsPage());
        } catch (err) {
          await showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
          _loadAvailableTimes();
        }
        setIsLoading(false);
      } else
        showDialog(builder: (context) => CustomDialog(message: str.app.selectBookingTimeMsg), context: context);
    }
  }

  void _loadAvailableTimes() async {
    if (_selectedDate == null) {
      showDialog(builder: (context) => CustomDialog(message: str.app.chooseDateFirst), context: context);
      return;
    }
    if (meetingPrices == null) return;
    setIsLoading(true);
    try {
      availableTimes = await DoctorServices().getAvailableTimes(doctor.id, _selectedDate.toIso8601String(), meetingPrices.meetingDurationId);
      if (availableTimes.length > 0) bookinTime = availableTimes.first;
    } catch (err) {
      showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
    }
    setIsLoading(false);
  }

  void _loadDoctorDetails() async {
    setIsLoading(true);
    try {
      var res = await DoctorServices().loadDoctorDetails(widget.id);
      GlobalVar.isLogin(context);
      setDoctor(res);
    } catch (err) {
      showDialog(builder: (context) => CustomDialog(message: err.toString()), context: context);
    }
    setIsLoading(false);
  }

  void setDoctor(User doc) {
    doctor = doc;
    if (GlobalVar.checkLisIsNotEmpty(doctor.meetingPrices)) {
      meetingPrices = GlobalVar.getFirstListItem(doctor.meetingPrices);
      _loadAvailableTimes();
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
