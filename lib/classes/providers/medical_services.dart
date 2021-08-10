import 'package:elajkom/classes/models/medical_center.dart';
import 'package:elajkom/util/utility/api_provider.dart';

class MedicalServices {
  final String baseUrl = 'https://al-tabeeb.net';

  Future<List<MedicalCenter>> getMedicalCenters(String type, int page) async {
    String subUrl = '/api/v1/medical_centers?page=$page&type=$type';
    var res = await ApiProvider().getRequest(subUrl, baseUrl: baseUrl);
    List<MedicalCenter> list = [];
    res['data'].forEach((v) => list.add(MedicalCenter.fromMap(v)));
    return list;
  }

  Future<List<MedicalCenter>> getSpecialOffer(int page) async {
    String subUrl = '/api/v1/offers?page=$page';
    var res = await ApiProvider().getRequest(subUrl, baseUrl: baseUrl);
    List<MedicalCenter> list = [];
    res['data'].forEach((v) => list.add(MedicalCenter.fromMap(v)));
    return list;
  }

  Future<List<MedicalCenter>> getVipServices(int page) async {
    String subUrl = '/api/v1/vip?page=$page';
    var res = await ApiProvider().getRequest(subUrl, baseUrl: baseUrl);
    List<MedicalCenter> list = [];
    res['data'].forEach((v) => list.add(MedicalCenter.fromMap(v)));
    return list;
  }

  Future<String> getMedicalTourism() async {
    String subUrl = '/api/v1/medical_tourism';
    var res = await ApiProvider().getRequest(subUrl, baseUrl: baseUrl);
    return res['data'];
  }
}
