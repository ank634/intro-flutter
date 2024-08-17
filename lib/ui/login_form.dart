import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/ui/display_widget.dart';
import 'package:namer_app/ui/register_page.dart';
import 'package:namer_app/services/authentication_service.dart';
import 'logged_in_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
              onPressed: () => _handleLogin(context),
              child: const Text('Login')),
          ElevatedButton(
              onPressed: () => _switchToRegisterPage(context),
              child: const Text('Register')),
        ]);
  }

  void _switchToLoggedInPage(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoggedInPage()));
  }

  void _switchToRegisterPage(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const RegisterPage()));
  }

  void _handleLogin(BuildContext context) async {
    String username = _usernameTextFieldController.text;
    String password = _passwordTextFieldController.text;
    Response response = await AuthenticationService().login(username, password);

    // TODO: consider adding function
    if (response.statusCode == 200 && context.mounted) {
      _switchToLoggedInPage(context);
    } else if (response.statusCode == 401) {
      setState(() {
        _isVisible = true;
        _message = 'Invalid Credentials';
        _usernameTextFieldController.text = '';
        _passwordTextFieldController.text = '';
      });
    }
  }
}
