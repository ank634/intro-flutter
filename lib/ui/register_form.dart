import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/ui/display_widget.dart';
import 'package:namer_app/services/authentication_service.dart';
import 'package:namer_app/ui/login_page.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterForm> {
  final _usernameTextFieldController = TextEditingController();
  final _passwordTextFieldController = TextEditingController();
  String _message = '';
  bool _isVisible = false;

  @override
  void dispose() {
    _usernameTextFieldController.dispose();
    _passwordTextFieldController.dispose();
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
            controller: _usernameTextFieldController,
          ),
          TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              controller: _passwordTextFieldController),
          ElevatedButton(
              onPressed: () => _handleRegister(context),
              child: const Text('Register')),
        ]);
  }

  Future<void> _handleRegister(BuildContext context) async {
    String username = _usernameTextFieldController.text;
    String password = _passwordTextFieldController.text;

    Response response =
        await AuthenticationService().register(username, password);

    if (response.statusCode == 200 && context.mounted) {
      _switchToLoginPage(context);
    } else {
      setState(() {
        _isVisible = true;
        _message = convertStatusCodeToMessage(response);
        _usernameTextFieldController.text = '';
        _passwordTextFieldController.text = '';
      });
    }
  }

  void _switchToLoginPage(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  String convertStatusCodeToMessage(Response response) {
    switch (response.statusCode) {
      case 200:
        return 'Sucessfully registered';

      case 400:
        return 'Please provide both a username and password';

      case 409:
        return 'Username is already in use';

      default:
        return 'There is an issue on our end please try again later';
    }
  }
}
