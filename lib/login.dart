// import 'package:crypto/View/navBar.dart';
// import 'package:flutter/material.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   String loginMessage = '';
//
//   void login() {
//     String username = usernameController.text;
//     String password = passwordController.text;
//
//     if (username == 'user' && password == '123') {
//       setState(() {
//         loginMessage = 'Login Successful';
//       });
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context) => NavBar()));
//     } else {
//       setState(() {
//         loginMessage = 'Invalid username or password';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.yellow[200],
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             FlutterLogo(size: 100),
//             SizedBox(height: 20),
//             Text(
//               'Crypto App',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),
//             TextFormField(
//               controller: usernameController,
//               decoration: InputDecoration(
//                 labelText: 'Username',
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: login,
//               child: Text('Login'),
//             ),
//             SizedBox(height: 10),
//             Text(
//               loginMessage,
//               style: TextStyle(
//                 color: Colors.red,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:crypto/View/navBar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/signup.dart';
import 'connect/connection.dart';


class loginpage extends StatefulWidget {
  const loginpage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  @override
  String username = "";
  String password = "";
  bool isLoginSuccess = true;
  bool isUsername = true;
  bool isPassword = true;
  var Username_controller = TextEditingController();
  var Password_controller = TextEditingController();

  void _loginNow() async {
    try {
      var res = await http.post(
        Uri.parse(API.login),
        body:{
          "username" : Username_controller.text.trim(),
          "password" : Password_controller.text.trim(),
        },
      );
      if(res.statusCode == 200)
      {
        var resBodyOfLogin = jsonDecode(res.body);
        if (resBodyOfLogin['success'] == true) {
          Fluttertoast.showToast(msg: "Login success!");
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) {
                return NavBar();
              }
              )
          );
        } else {
          Fluttertoast.showToast(msg: "Login failed, isi username dan password dengan benar");
        }
      }
    }catch(e){
      print("error = " + e.toString());
    }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Crypto'),
        backgroundColor: Colors.yellow[800],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(
                "Login Account",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 300,
              height: 40,
              child: TextFormField(
                onChanged: (value) {
                  username = value;
                }, decoration: InputDecoration(hintText: 'Username',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 300,
              height: 40,
              child: TextFormField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 150,
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: (isLoginSuccess) ? Colors.blue : Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Username_controller.text = username;
                  Password_controller.text = password;
                  print(Username_controller.text);
                  if (Username_controller.text != "" &&
                      Password_controller.text != "") {
                    _loginNow();
                  } else {
                    SnackBar snackBar = SnackBar(
                      content: Text("Tidak Boleh Ada Yang Kosong"),
                      backgroundColor: Colors.redAccent,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text('Login'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(onPressed: () {},
                child: const Text('Forgot Password?',
                    style: TextStyle(color: Colors.grey))
            ),
            Row(
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 13),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context){
                          return SignUp();
                        })
                    );
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ),
      ),
    );
  }
}
