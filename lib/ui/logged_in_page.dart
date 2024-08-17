import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:namer_app/ui/login_page.dart';
import 'package:namer_app/services/authentication_service.dart';

class LoggedInPage extends StatelessWidget {
  const LoggedInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('You Are Logged In'),
        ),
        body: ElevatedButton(
            onPressed: () => _handleLogout(context),
            child: const Text('Log out')));
  }

  void _switchToLoginInPage(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  Future<void> _handleLogout(BuildContext context) async {
    Response response = await AuthenticationService().logout();

    // TODO maybe if they get a 500 let them logout anyway...
    if (response.statusCode! <= 500 && context.mounted) {
      _switchToLoginInPage(context);
    }
  }
}
