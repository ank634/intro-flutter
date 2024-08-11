import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'logged_in_page.dart';


class LoginForm extends StatefulWidget{
  final String loginApiUrl;
  const LoginForm(this.loginApiUrl, {super.key});
  
  @override
  State<StatefulWidget> createState() => _LoginFormState();

}

class _LoginFormState extends State<LoginForm>{
  final usernameTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();

  @override
  void dispose() {
    usernameTextFieldController.dispose();
    passwordTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,  // Center vertically multiple widgets
      crossAxisAlignment: CrossAxisAlignment.center,  // Center horizontally multiple widgets

      children: [TextField(decoration: InputDecoration(labelText: 'Username'), controller: usernameTextFieldController,),
                TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password'), controller: passwordTextFieldController),
                ElevatedButton(onPressed: (){
                  login().then((response) {
                    if (response.statusCode == 200){
                      Navigator.pop(context);
                      print(response.headers);
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const LoggedInPage()));
                    }
                  });
                }, child: Text('Login'))]
      );
    
  }

  Future<http.Response> login() async{
    String username = usernameTextFieldController.text;
    String password = passwordTextFieldController.text;

    final response = await http.post(Uri.parse('http://127.0.0.1:5000/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json'
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password
    })
    );

    return response;
  }
}