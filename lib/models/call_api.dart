import 'dart:convert';

// pubspec packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class CallApi {
  int? statusCode;
  String? userName;
  String? token;
  final String _url = 'https://c24apidev.accelx.net';

  Future postData(data, apiUrl) async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();
    var tokenJson = successLogin.getString('token');
    token = json.decode(json.encode(tokenJson));
    var fullUrl = Uri.parse(_url + apiUrl);

    return await http.post(
      fullUrl,
      body: json.encode(data),
      headers: _setHeaders(),
    );
  }

  // set headers for all method
  _setHeaders() => {
        'Content-Type': 'Application/json',
        'Authorization': 'Token ' '$token',
      };

  Future getData(apiUrl) async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();
    var tokenJson = successLogin.getString('token');
    token = json.decode(json.encode(tokenJson));
    var fullUrl = Uri.parse(_url + apiUrl);
    return await http.get(
      fullUrl,
      headers: _getHeaders(),
    );
  }

  _getHeaders() => {
        'Content-Type': 'Application/json',
        'Authorization': 'Token ' '$token',
      };

  Future patchData(data, apiUrl) async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();
    var tokenJson = successLogin.getString('token');
    token = json.decode(json.encode(tokenJson));
    var fullUrl = Uri.parse(_url + apiUrl);
    return await http.patch(
      fullUrl,
      body: json.encode(data),
      headers: _getHeaders(),
    );
  }

  Future putData(data, apiUrl) async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();
    var tokenJson = successLogin.getString('token');
    token = json.decode(json.encode(tokenJson));
    var fullUrl = Uri.parse(_url + apiUrl);

    return await http.put(
      fullUrl,
      body: json.encode(data),
      headers: _getHeaders(),
    );
  }

  Future deleteData(apiUrl) async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();
    var tokenJson = successLogin.getString('token');
    token = json.decode(json.encode(tokenJson));
    var fullUrl = Uri.parse(_url + apiUrl);
    return await http.delete(
      fullUrl,
      headers: _getHeaders(),
    );
  }

  Future createSchedule(data, apiUrl) async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();
    var tokenJson = successLogin.getString('token');
    token = json.decode(json.encode(tokenJson));
    var fullUrl = _url + apiUrl;

    var dio = Dio();

    dio.options.baseUrl = fullUrl;

    return await dio.post(
      fullUrl,
      data: data,
      options: Options(
        headers: {
          'Accept': 'Application/json',
          'Authorization': 'Token ' '$token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future getUnauthorizedData(apiUrl) async {
    var fullUrl = Uri.parse(_url + apiUrl);

    return await http.get(
      fullUrl,
      headers: {
        'Content-Type': 'Application/json',
      },
    );
  }
}
