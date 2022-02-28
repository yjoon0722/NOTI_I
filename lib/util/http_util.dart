import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as diolib;
import 'package:http/http.dart' as http;
import 'package:cashnote/urls.dart';

class HttpUtil {
  Future<String> postLogin(String url, Map<String, dynamic> jsonMap,
      {int timeoutsec = 15}) async {
    Map<String, String> header = {
      'Service-Client' : 'cashnote',
      'Content-Type' : 'application/json',
      'Accept' : 'application/json',
    };
    var responseData;

    var uri = Uri.parse(url);
    try {
      final response = await http
          .post(uri, body: utf8.encode(jsonEncode(jsonMap)), headers: header)
          .timeout(Duration(seconds: timeoutsec));

      int? status = response.statusCode;
      if (status == 200) {
        responseData = utf8.decode(response.bodyBytes);
      } else {
        print("HTTP POST 요청 실패: $status 에러");
      }
    } on TimeoutException catch (e) {
      print("TimeoutExeception : ${e.toString()}");
    } on Exception catch (e) {
      print("Exception: ${e.toString()}");
    }

    return responseData;
  }

  Future<String> postFCM(String url, Map<String, dynamic> jsonMap, String accessToken,
      {int timeoutsec = 15}) async {
    Map<String, String> header = {
      'Service-Client' : 'cashnote',
      'Content-Type' : 'application/json',
      'Accept' : 'application/json',
      'Authorization' : "Bearer $accessToken",
    };
    var responseData;

    var uri = Uri.parse(url);
    try {
      final response = await http
          .post(uri, body: utf8.encode(jsonEncode(jsonMap)), headers: header)
          .timeout(Duration(seconds: timeoutsec));

      int? status = response.statusCode;
      print("status!!! = $status");
      if (status == 200) {
        responseData = utf8.decode(response.bodyBytes);
      } else {
        print("HTTP POST 요청 실패: $status 에러");
      }
    } on TimeoutException catch (e) {
      print("TimeoutException : ${e.toString()}");
    } on Exception catch (e) {
      print("Exception: ${e.toString()}");
    }

    return responseData;
  }

  Future<String> get(String url) async {
    Map<String, String> header = {
      'Service-Client' : 'cashnote',
      'Content-Type' : 'application/json',
      'Accept' : 'application/json',
    };
    var responseData;

    var uri = Uri.parse(url);
    try {
      final response = await http.get(uri, headers: header);
      int? status = response.statusCode;
      if (status == 200) {
        responseData = utf8.decode(response.bodyBytes);
      } else {
        print("HTTP POST 요청 실패: $status 에러");
      }
    } on TimeoutException catch (e) {
      print("TimeoutExeception : ${e.toString()}");
    } on Exception catch (e) {
      print("Exception: ${e.toString()}");
    }

    return responseData;
  }

  Future<bool> getIsToken(String url, String accessToken) async {
    Map<String, String> header = {
      'Service-Client' : 'cashnote',
      'Content-Type' : 'application/json',
      'Accept' : 'application/json',
      'Authorization' : 'Bearer $accessToken',
    };
    var isToken = false;
    var uri = Uri.parse(url);

    try {
      final response = await http.get(uri,headers: header);
      int? status = response.statusCode;
      if(status == 200) {
        isToken = true;
      }
    } on TimeoutException catch (e) {
      print("TimeoutException : ${e.toString()}");
    } on Exception catch (e) {
      print("Exception : ${e.toString()}");
    }

    return isToken;
  }

  // 일반 post 안될때 추가 테스트용 Dio 패키지 post
  Future<String> postWithDio(String url, Map<String, dynamic> param) async {
    var responseData;

    try {
      var dio = diolib.Dio();
      dio.options.baseUrl = Urls.BASE_API_URI;
      dio.options.connectTimeout = 10000;
      dio.options.receiveTimeout = 3000;
      dio.options.contentType = diolib.Headers.jsonContentType;

      diolib.FormData formData = diolib.FormData.fromMap(param);
      var response = await dio.post(url, data: formData);

      int? status = response.statusCode;
      if (status == 200) {
        responseData = response.data;
      }
    } on TimeoutException catch (e) {
      print("TimeoutExeception : ${e.toString()}");
    } on diolib.DioError catch (e) {
      print("DioError: ${e.toString()}");
    } on Exception catch (e) {
      print("Exception: ${e.toString()}");
    }

    return responseData;
  }
}
