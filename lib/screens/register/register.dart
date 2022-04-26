import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalcard/models/member.dart';
import 'package:digitalcard/screens/profile/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:digitalcard/Screens/login/login.dart';
import 'package:digitalcard/components/background.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  Member memberem = Member();
  // FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.value([]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Size size = MediaQuery.of(context).size;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Background(
                child: Container(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            "REGISTER",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 1, 92, 90),
                                fontSize: 35),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 20, right: 20, top: 70),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[200],
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 10),
                                  blurRadius: 50,
                                  color: Color(0xffEEEEEE)),
                            ],
                          ),
                          child: TextFormField(
                            validator: RequiredValidator(
                                errorText: "โปรดระบุชื่อ-นามสกุล"),
                            cursorColor: Color(0xffF5591F),
                            onSaved: (v) {
                              memberem.name = v;
                            },
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: Color(0xffF5591F),
                              ),
                              hintText: "Full Name",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[200],
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 10),
                                  blurRadius: 50,
                                  color: Color(0xffEEEEEE)),
                            ],
                          ),
                          child: TextFormField(
                            validator: MultiValidator([
                              EmailValidator(
                                  errorText: "Email-adress ไม่ถูกต้อง"),
                              RequiredValidator(errorText: "โปรดระบุ Email"),
                            ]),
                            cursorColor: Color(0xffF5591F),
                            onSaved: (v) {
                              memberem.email = v;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.email,
                                color: Color(0xffF5591F),
                              ),
                              hintText: "Email",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
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
                            validator: RequiredValidator(
                                errorText: "โปรดระบุเบอร์โทรศัพท์"),
                            cursorColor: Color(0xffF5591F),
                            onSaved: (v) {
                              memberem.phone = v;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusColor: Color(0xffF5591F),
                              icon: Icon(
                                Icons.phone,
                                color: Color(0xffF5591F),
                              ),
                              hintText: "Phone Number",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
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
                            validator: RequiredValidator(
                                errorText: "โปรดระบุ password"),
                            obscureText: true,
                            cursorColor: Color(0xffF5591F),
                            onSaved: (v) {
                              memberem.password = v;
                            },
                            decoration: InputDecoration(
                              focusColor: Color(0xffF5591F),
                              icon: Icon(
                                Icons.vpn_key,
                                color: Color(0xffF5591F),
                              ),
                              hintText: "Enter Password",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              formKey.currentState!.save();

                              try {
                                final auth = FirebaseAuth.instance;
                                var res =
                                    await auth.createUserWithEmailAndPassword(
                                        email: memberem.email.toString(),
                                        password: memberem.password.toString());

                                auth.currentUser!
                                    .updateDisplayName(memberem.name);

                                auth.currentUser!.reload();
                                await FirebaseFirestore.instance
                                    .collection("members")
                                    .doc(res.user!.uid)
                                    .set({
                                  'uid': res.user!.uid,
                                  "name": memberem.name,
                                  "phone": memberem.phone,
                                  "email": memberem.email,
                                  "password": memberem.password
                                });

                                formKey.currentState!.reset();
                                // auth.currentUser;
                                print(res);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => HomePage()));
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
                          margin: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()))
                            },
                            child: Text(
                              "Already Have an Account? Sign in",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 1, 92, 90),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
