import 'dart:convert';
import 'dart:io';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'logged_in_page.dart';

class LoginForm extends StatefulWidget {
  final String loginApiUrl;
  const LoginForm(this.loginApiUrl, {super.key});

  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final usernameTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();

  @override
  void dispose() {
    usernameTextFieldController.dispose();
    passwordTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center vertically multiple widgets
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center horizontally multiple widgets

        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Username'),
            controller: usernameTextFieldController,
          ),
          TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              controller: passwordTextFieldController),
          ElevatedButton(
              onPressed: () {
                login().then((response) {
                  if (response.statusCode == 200 && context.mounted) {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoggedInPage()));
                  }
                });
              },
              child: const Text('Login'))
        ]);
  }

  Future<Response> login() async {
    final dio = await _networkingSetup();
    String username = usernameTextFieldController.text;
    String password = passwordTextFieldController.text;
    const String url = 'http://127.0.0.1:5000/auth/login';
    const Map<String, String> headers = {'Content-Type': 'application/json'};
    final String body =
        jsonEncode({'username': username, 'password': password});

    Response response =
        await dio.post(url, data: body, options: Options(headers: headers));
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
