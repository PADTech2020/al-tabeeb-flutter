import '../models/banners.dart';
import '../models/nationalities.dart';
import '../models/specialty.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../util/utility/api_provider.dart';
import '../models/user.dart';

class InitialDataProvider extends ChangeNotifier {
  User user;
  int cartItemsCount = 0;

  String facebookLink;
  String twitterLink;
  String linkedInLink;
  String instagramLink;
  String contactPhone;
  String contactEmail;
  String googlePlayLink;
  String appleStoreLink;

  List<Specialty> specialties = [];
  List<Specialty> topSpecialties = [];
  List<Specialty> homeSpecialties = [];
  List<User> mostViewedDoctors = [];
  List<Banners> banners = [];
  List<String> topics = [];
  List<Nationalities> nationalities = [];

  Future<void> getInitData() async {
    final String url = "/api/account";
    try {
      var data = await ApiProvider().getRequest(url);
      user = data['user'] != null ? new User.fromJson(data['user']) : null;
      if (data['specialties'] != null) {
        specialties.clear();
        data['specialties'].forEach((v) => specialties.add(new Specialty.fromJson(v)));
      }
      if (data['nationalities'] != null) {
        nationalities.clear();
        data['nationalities'].forEach((v) => nationalities.add(new Nationalities.fromJson(v)));
      }

      if (data['topics'] != null) {
        topics = [];
        data['topics'].forEach((v) {
          topics.add(v);
        });
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getHomeData() async {
    final String url = "/api/home";
    try {
      var data = await ApiProvider().getRequest(url);
      var settings = data['settings'];
      if (settings != null) {
        facebookLink = settings['facebookLink'] != null ? settings['facebookLink'] : "";
        twitterLink = settings['twitterLink'] != null ? settings['twitterLink'] : "";
        linkedInLink = settings['linkedInLink'] != null ? settings['linkedInLink'] : "";
        instagramLink = settings['instagramLink'] != null ? settings['instagramLink'] : "";
        contactPhone = settings['contactPhone'] != null ? settings['contactPhone'] : "";
        contactEmail = settings['contactEmail'] != null ? settings['contactEmail'] : "";
        googlePlayLink = settings['googlePlayLink'] != null ? settings['googlePlayLink'] : "";
        appleStoreLink = settings['appleStoreLink'] != null ? settings['appleStoreLink'] : "";
      }

      if (data['topSpecialties'] != null) {
        topSpecialties.clear();
        data['topSpecialties'].forEach((v) => topSpecialties.add(new Specialty.fromJson(v)));
      }
      if (data['homeSpecialties'] != null) {
        homeSpecialties.clear();
        data['homeSpecialties'].forEach((v) => homeSpecialties.add(new Specialty.fromJson(v)));
      }
      if (data['mostViewedDoctors'] != null) {
        mostViewedDoctors.clear();
        data['mostViewedDoctors'].forEach((v) {
          mostViewedDoctors.add(new User.fromJson(v));
        });
      }
      if (data['banners'] != null) {
        banners.clear();
        data['banners'].forEach((v) {
          banners.add(new Banners.fromJson(v));
        });
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getContentPage(String type) async {
    var res = await ApiProvider().getRequest('/api/Pages/$type');
    return res;
  }

  Future<dynamic> getFaqPage() async {
    var res = await ApiProvider().getRequest('/api/Faq');
    return res;
  }
}
