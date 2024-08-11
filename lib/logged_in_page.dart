import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/login_page.dart';

class LoggedInPage extends StatelessWidget{
  const LoggedInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('You Are Logged In'),
      ),
      body: ElevatedButton(onPressed: (){
        logout().then((response) {
          
          if (response.statusCode == 200){
            
            Navigator.pop(context);

            Navigator.push(context, 
            MaterialPageRoute(builder: (context) => const LoginPage()));
          }
        });
      }, child: Text('Log out'))
    );
  }

  // TODO: find out how to store cookie persistent 
  Future<http.Response> logout() async{
    final response = await http.delete(Uri.parse('http://127.0.0.1:5000/auth/logout'),
    headers: <String, String>{
    'Content-Type': 'application/json',
    'Cookie': 'session-id=a58b7239-032a-461a-bf34-7c50c2c74d69'
    });

    return response;
  }
}