import 'dart:developer';
import 'package:elajkom/ui/pages/main_page.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import './api_response.dart';
import './custom_exception.dart';
import './global_var.dart';

class ApiProvider {
  static String accessToken;
  static const String baseUrl = "https://dashboard.al-tabeeb.com";
  static const String imageApi = baseUrl + "/api/services/previewimage/";
  static const String downloadApi = baseUrl + "/api/services/Download/";
  static const String shareAdUrl = "https://al-tabeeb.com";
  Map<String, String> headers = new Map();

  Future<String> getAccessToken() async {
    return ApiProvider.accessToken;
  }

  Future<Map<String, String>> getHeaders() async {
    headers['Content-Type'] = 'application/json';
    await getAccessToken();
    headers['Accept-Language'] = GlobalVar.initializationLanguage ?? '*';
    headers['authorization'] = 'Bearer ${ApiProvider.accessToken ?? ""}';
    return headers;
  }

  Future<dynamic> postRequest(String subUrl, dynamic body, {Map<String, String> headers}) async {
    if (subUrl != '/connect/token' && MainPage.userProvider != null) await MainPage.userProvider.checkAuthorization(null);

    if (headers == null) {
      await getHeaders();
      headers = this.headers;
    }

    printConnectionInfo('POST', ApiProvider.baseUrl + subUrl, headers, body: body);

    try {
      final httpResponse = await http.post(ApiProvider.baseUrl + subUrl, headers: headers, body: body);
      return _responseHandel(httpResponse, url: subUrl);
    } on SocketException {
      throw FetchDataException(str.msg.noInternet);
    } catch (err) {
      rethrow;
    }
  }

  Future<dynamic> getRequest(String subUrl, {Map<String, String> headers, String baseUrl}) async {
    if (subUrl != '/connect/token' && MainPage.userProvider != null) await MainPage.userProvider.checkAuthorization(null);
    if (headers == null) {
      await getHeaders();
      headers = this.headers;
    }
    bool parseAsExternalApi = false;
    if (baseUrl != null)
      parseAsExternalApi = true;
    else
      baseUrl = ApiProvider.baseUrl;

    printConnectionInfo('GET', baseUrl + subUrl, headers);

    try {
      final httpResponse = await http.get(baseUrl + subUrl, headers: headers);

      return _responseHandel(httpResponse, url: subUrl, parseAsExternalApi: parseAsExternalApi);
    } on SocketException {
      throw FetchDataException(str.msg.noInternet);
    } catch (err) {
      rethrow;
    }
  }

  Future<dynamic> deleteRequest(String subUrl, {Map<String, String> headers}) async {
    this.headers = await getHeaders();
    if (headers == null) headers = this.headers;

    // printConnectionInfo('DELETE', ApiProvider.baseUrl + subUrl, headers);

    try {
      final httpResponse = await http.delete(ApiProvider.baseUrl + subUrl, headers: headers);
      return _responseHandel(httpResponse, url: subUrl);
    } on SocketException {
      throw FetchDataException(str.msg.noInternet);
    } catch (err) {
      rethrow;
    }
  }

  Future<dynamic> uploadFiles(File imageFile, {Map<String, String> headers}) async {
    var uri = Uri.parse(ApiProvider.baseUrl + '/api/Services/SaveUploaded');
    this.headers = await getHeaders();
    if (headers == null) headers = this.headers;
    // printConnectionInfo('UploadFiles', ApiProvider.baseUrl + uri.toString(), headers);

    try {
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
      var response = await request.send();

      if (response.statusCode == 200) log('UploadFiles success!');
      final body = await response.stream.bytesToString();
      var httpResponse = http.Response(body, response.statusCode);
      return _responseHandel(httpResponse, url: uri.toString());
    } on SocketException {
      throw FetchDataException(str.msg.noInternet);
    } catch (err) {
      rethrow;
    }
  }

  dynamic _responseHandel(http.Response httpResponse, {String url = '', bool parseAsExternalApi = false}) {
    log(''' @@@@@@@@@@@@@@@@@@@@@@@@@@ response from $url | statusCode:${httpResponse.statusCode}
    body:${httpResponse.body}
    .''');
    try {
      var responseJson = json.decode(httpResponse.body.toString());
      if (parseAsExternalApi) {
        return responseJson;
      } else {
        ApiResponse apiResponse = ApiResponse();
        apiResponse.fromJson(responseJson);
        // print('apiResponse.data :' + apiResponse.data.toString());
        if (!apiResponse.success) {
          print('///////////////// apiResponse.getErrorsString :' + apiResponse.getErrorsString());
          throw FetchDataException(apiResponse.getErrorsString());
        }
        return apiResponse.data;
      }
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  void printConnectionInfo(String connectionType, String url, Map headers, {dynamic body = ""}) {
    log(''' @@@@@@@@@@@@@@@@@@@@@@@@@@ $connectionType  $url
    headers: $headers
    body: $body
    .''');
  }

  Future<bool> checkNetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
    }
    return false;
  }
}
