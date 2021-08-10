import 'dart:convert';
import 'dart:developer';
import '../models/meeting.dart';
import '../models/user.dart';
import '../../util/utility/api_provider.dart';

class DoctorServices {
  Future<User> loadDoctorDetails(String id) async {
    var res = await ApiProvider().getRequest('/api/Doctors/$id');
    return User.fromJson(res);
  }

  Future<List<User>> search({String search, int specialityId, int page, int take = 20}) async {
    String subUrl = '/api/Doctors';
    Map<String, dynamic> body = {"search": search ?? '', "specialityId": specialityId, "page": page, "take": take};
    var res = await ApiProvider().postRequest(subUrl, json.encode(body));
    List<User> list = [];
    res['data'].forEach((v) => list.add(User.fromJson(v)));
    return list;
  }

  Future<List<DateTime>> getAvailableTimes(String doctorId, String date, int meetingDurationId) async {
    String subUrl = '/api/Meetings/AvailableTimes?date=$date&doctorId=$doctorId&meetingDurationId=$meetingDurationId';
    Map<String, dynamic> body = {};
    var res = await ApiProvider().postRequest(subUrl, json.encode(body));
    List<DateTime> list = [];
    res.forEach((v) => list.add(DateTime.parse(v)));
    return list;
  }

  Future<int> addBookMeeting(String doctorId, String date, int meetingDurationId, int type) async {
    try {
      String subUrl = '/api/Meetings/BookMeeting';
      Map<String, dynamic> body = {
        "doctorId": doctorId,
        "date": date,
        "meetingDurationId": meetingDurationId,
        "type": type,
      };
      var res = await ApiProvider().postRequest(subUrl, json.encode(body));
      return res;
    } catch (err) {
      rethrow;
    }
  }

  Future<dynamic> markAsPaied(int meetingId) async {
    String subUrl = '/api/Meetings/MarkAsPaied/$meetingId';
    return await ApiProvider().getRequest(subUrl);
  }

  Future<dynamic> payBooking({int meetingId, String name, String number, String expiry, String cvc}) async {
    String subUrl = '/api/Order/$meetingId';
    Map<String, dynamic> body = {"name": name, "number": number, "expiry": expiry, "cvc": cvc};
    log(subUrl);
    log(body.toString());
    return await ApiProvider().postRequest(subUrl, json.encode(body));
  }

  Future<dynamic> updateMeetingPrices(List<Map<String, dynamic>> body) async {
    String subUrl = '/api/MeetingPrices';
    var res = await ApiProvider().postRequest(subUrl, json.encode(body));
    return res;
  }

  Future<dynamic> updateAvailabilityPlans(List<Map<String, dynamic>> body) async {
    String subUrl = '/api/AvailabilityPlans';
    var res = await ApiProvider().postRequest(subUrl, json.encode(body));
    return res;
  }

  Future<List<Meeting>> getUserMeetings({String search, DateTime date, int page = 0, bool started = true}) async {
    String subUrl = '/api/Meetings/UserMeetings';
    Map<String, dynamic> body = {"search": search, "date": date?.toIso8601String(), "page": page, "take": 20, "started": started};
    var res = await ApiProvider().postRequest(subUrl, json.encode(body));
    List<Meeting> list = [];
    res['data'].forEach((v) => list.add(Meeting.fromJson(v)));
    return list.reversed.toList();
  }

  Future<List<Meeting>> getdoctorMeetings({String search, DateTime date, int page = 0, bool started = true}) async {
    String subUrl = '/api/Meetings/DoctorMeetings';
    Map<String, dynamic> body = {"search": search, "date": date?.toIso8601String(), "page": page, "take": 20, "started": started};
    var res = await ApiProvider().postRequest(subUrl, json.encode(body));
    List<Meeting> list = [];
    res['data'].forEach((v) => list.add(Meeting.fromJson(v)));
    return list.reversed.toList();
  }

  Future<dynamic> getUserBills({DateTime fromDate, DateTime toDate, page = 0}) async {
    String subUrl = '/api/Meetings/Bills';
    Map<String, dynamic> body = {"fromDate": fromDate?.toIso8601String(), "toDate": toDate?.toIso8601String(), "page": page, "take": 20};
    var res = await ApiProvider().postRequest(subUrl, json.encode(body));
    return res;
  }

  Future<dynamic> getDoctorBills({DateTime fromDate, DateTime toDate, page = 0}) async {
    String subUrl = '/api/Meetings/Payments';
    Map<String, dynamic> body = {"fromDate": fromDate?.toIso8601String(), "toDate": toDate?.toIso8601String(), "page": page, "take": 20};
    var res = await ApiProvider().postRequest(subUrl, json.encode(body));
    return res;
  }

  Future<dynamic> getDoctorPayments({DateTime fromDate, DateTime toDate, page = 0}) async {
    String subUrl = '/api/Meetings/Payments';
    Map<String, dynamic> body = {"fromDate": fromDate?.toIso8601String(), "toDate": toDate?.toIso8601String(), "page": page, "take": 20};
    var res = await ApiProvider().postRequest(subUrl, json.encode(body));
    return res;
  }

  Future<dynamic> reportMissedMeeting(int meetingId, String userId) async {
    String subUrl = '/api/MissedMeetingReports';
    Map<String, dynamic> body = {"meetingId": meetingId, "userId": userId};
    var res = await ApiProvider().postRequest(subUrl, json.encode(body));

    return res;
  }

  Future<dynamic> rateDoctor(String doctorId, int rate) async {
    String subUrl = '/api/Review/$doctorId/$rate';
    var res = await ApiProvider().postRequest(subUrl, json.encode({}));
    return res;
  }

  Future<dynamic> getUserSessionInfo(int meetingId) async {
    String subUrl = '/api/Meetings/UserSessionInfo/$meetingId';
    var res = await ApiProvider().getRequest(subUrl);
    return res;
  }

  Future<dynamic> getCurrentSessionWith(String userId) async {
    String subUrl = '/api/Meetings/GetCurrentSessionWith/$userId';
    var res = await ApiProvider().getRequest(subUrl);
    return res;
  }

  Future<dynamic> meetingFinish(int meetingId) async {
    String subUrl = '/api/Meetings/Finish/$meetingId';
    var res = await ApiProvider().getRequest(subUrl);
    return res;
  }

  Future<dynamic> setupPhysicalMeetingDate(int meetingId, String date) async {
    String subUrl = '/api/Meetings/SetupPhysicalMeetingDate/$meetingId/$date';
    var res = await ApiProvider().postRequest(subUrl, "");
    return res;
  }
}
