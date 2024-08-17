import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:namer_app/boundary/network_client.dart';

class AuthenticationService {
  Future<Response> login(String username, String password) async {
    final NetworkClient client = await NetworkClient.getInstance();
    Dio dio = client.dio;
    const String loginUrl = 'http://127.0.0.1:5000/auth/login';
    final String body =
        jsonEncode({'username': username, 'password': password});

    late final Response response;
    response = await dio.post(loginUrl, data: body);

    return response;
  }

  Future<Response> register(String username, String password) async {
    final NetworkClient client = await NetworkClient.getInstance();
    final Dio dio = client.dio;
    const String registerUrl = 'http://127.0.0.1:5000/auth/register';
    final String body =
        jsonEncode({'username': username, 'password': password});

    late final Response response;
    response = await dio.post(registerUrl, data: body);

    return response;
  }

  ///Desc: sends a logout request to the api with the current cookie inside of cookie jar configured with dio object
  ///Throws: will throw dio exception error for anything other then status code
  ///Return dio response object. 200 if succesfully logged out, 400 if there is no session-id in cookie header, 404 if no user with session-id is logged in
  Future<Response> logout() async {
    final NetworkClient client = await NetworkClient.getInstance();
    final Dio dio = client.dio;
    const logoutUrl = 'http://127.0.0.1:5000/auth/logout';

    return await dio.delete(logoutUrl);
  }
}
