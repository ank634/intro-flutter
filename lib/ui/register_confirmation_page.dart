import 'package:flutter/material.dart';
import 'package:namer_app/ui/login_page.dart';

class RegisterConfirmationPage extends StatelessWidget {
  const RegisterConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sucessfully registered'),
      ),
      body: ElevatedButton(
          onPressed: () => _navigateToLoginPage(context),
          child: const Text('Go to login page')),
    );
  }

  void _navigateToLoginPage(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}
