import 'package:digitalcard/screens/profile/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:digitalcard/Screens/login/login.dart';
import 'package:digitalcard/components/background.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController user = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController mobileNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "REGISTER",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2661FA),
                  fontSize: 36),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
              controller: name,
              decoration: InputDecoration(labelText: "Full-Name"),
            ),
          ),
          // SizedBox(height: size.height * 0.03),
          // Container(
          //   alignment: Alignment.center,
          //   margin: EdgeInsets.symmetric(horizontal: 40),
          //   child: TextFormField(
          //     controller: mobileNo,
          //     decoration: InputDecoration(labelText: "Mobile Number"),
          //   ),
          // ),
          SizedBox(height: size.height * 0.03),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
              controller: user,
              decoration: InputDecoration(labelText: "Email"),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
              controller: pass,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
          ),
          SizedBox(height: size.height * 0.05),
          // Container(
          //   alignment: Alignment.center,
          //   margin: EdgeInsets.symmetric(horizontal: 40),
          //   child: TextFormField(
          //     controller: pass,
          //     decoration: InputDecoration(labelText: "Image"),
          //     obscureText: true,
          //   ),
          // ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  var res = await auth.createUserWithEmailAndPassword(
                      email: user.text, password: pass.text);

                  auth.currentUser!.updateDisplayName(name.text);

                  auth.currentUser!.reload();
                  // auth.currentUser;
                  print(res);

                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (c) => HomePage()));
                } catch (e) {
                  print(e);
                }
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
                  "SIGN UP",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: GestureDetector(
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()))
              },
              child: Text(
                "Already Have an Account? Sign in",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2661FA)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
