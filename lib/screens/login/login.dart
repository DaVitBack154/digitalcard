import 'package:digitalcard/screens/profile/home.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:digitalcard/Screens/register/register.dart';
import 'package:digitalcard/components/background.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController user = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    _buildTextFiled({
      TextEditingController? controller,
      Widget? prefixIcon,
      String? hintText,
      bool ispassword = false,
    }) {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        padding: EdgeInsets.only(left: 20, right: 20),
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color(0xffEEEEEE),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 20),
                blurRadius: 100,
                color: Color(0xffEEEEEE)),
          ],
        ),
        child: TextFormField(
          // validator: checksting,
          obscureText: ispassword,
          controller: controller,
          cursorColor: Color(0xffF5591F),
          decoration: InputDecoration(
            focusColor: Color(0xffF5591F),
            icon: prefixIcon,
            hintText: hintText,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          // validator: (value) =>
          //     value!.isEmpty ? 'Passwords cannot be emply' : null,
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(),
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Image.asset("assets/images/logo12.png"),
            ),
            SizedBox(height: size.height * 0.01),

            _buildTextFiled(
              controller: user,
              hintText: 'Email',
              prefixIcon: Icon(
                Icons.email,
                color: Colors.red,
              ),
            ),
            // SizedBox(height: size.height * 0.03),
            _buildTextFiled(
              ispassword: true,
              controller: pass,
              hintText: 'Password',
              prefixIcon: Icon(
                Icons.vpn_key,
                color: Colors.red,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  // Write Click Listener Code Here
                },
                child: Text("Forget Password?"),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  auth
                      .signInWithEmailAndPassword(
                          email: user.text, password: pass.text)
                      .then((value) {
                    user.clear();
                    pass.clear();
                    print('login success');
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (c) => HomePage()));
                  }).catchError((onError) {
                    pass.clear();
                    print('login failed $onError');
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  textStyle: TextStyle(color: Colors.white),
                  padding: const EdgeInsets.all(0),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: size.width * 0.5,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: new LinearGradient(colors: [
                        Color.fromARGB(255, 255, 136, 34),
                        Color.fromARGB(255, 255, 177, 41)
                      ])),
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    "LOGIN",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: GestureDetector(
                onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()))
                },
                child: Text(
                  "Create account? Sign up",
                  style: TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 1, 92, 90),
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
