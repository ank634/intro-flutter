import 'dart:convert';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterForm> {
  final usernameTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();
  String _message = '';
  bool _isVisible = false;

  void _sendRegistrationRequest() async {
    Response response = await register();
    setState(() {
      _isVisible = true;
      _message = convertStatusCodeToMessage(response);
    });
  }

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
          DisplayWidget(message: _message, isVisible: _isVisible),
          TextField(
            decoration: const InputDecoration(labelText: 'Username'),
            controller: usernameTextFieldController,
          ),
          TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              controller: passwordTextFieldController),
          ElevatedButton(
              onPressed: _sendRegistrationRequest,
              child: const Text('Register')),
        ]);
  }

  Future<Dio> _networkingSetup() async {
    final dio = Dio(BaseOptions(
        validateStatus: (status) => status != null && status < 500));
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage('$appDocPath/.cookies/'));

    dio.interceptors.add(CookieManager(cookieJar));

    return dio;
  }

  Future<Response> register() async {
    final dio = await _networkingSetup();
    String username = usernameTextFieldController.text;
    String password = passwordTextFieldController.text;
    const String url = 'http://127.0.0.1:5000/auth/register';
    const Map<String, String> headers = {'Content-Type': 'application/json'};
    final String body =
        jsonEncode({'username': username, 'password': password});

    late Response response;

    response =
        await dio.post(url, data: body, options: Options(headers: headers));

    return response;
  }

  String convertStatusCodeToMessage(Response response) {
    switch (response.statusCode) {
      case 200:
        return 'Successfully Registered';

      case 400:
        return 'Please provide both a username and password';

      case 409:
        return 'Username is already in use';

      default:
        return 'There is an issue on our end please try again later';
    }
  }
}

class DisplayWidget extends StatelessWidget {
  final String message;
  final bool isVisible;
  const DisplayWidget(
      {super.key, required this.message, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Visibility(visible: isVisible, child: Text(message));
  }
}
