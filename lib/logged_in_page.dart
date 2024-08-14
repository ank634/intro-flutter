import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/login_page.dart';
import 'package:path_provider/path_provider.dart';

class LoggedInPage extends StatelessWidget {
  const LoggedInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('You Are Logged In'),
        ),
        body: ElevatedButton(
            onPressed: () {
              logout().then((response) {
                if (response.statusCode == 200 && context.mounted) {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                }
              });
            },
            child: const Text('Log out')));
  }

  Future<Response> logout() async {
    final dio = await _networkingSetup();
    const String url = 'http://127.0.0.1:5000/auth/logout';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Response response =
        await dio.delete(url, options: Options(headers: headers));

    return response;
  }

  Future<Dio> _networkingSetup() async {
    final dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage('$appDocPath/.cookies/'));

    dio.interceptors.add(CookieManager(cookieJar));

    return dio;
  }
}
