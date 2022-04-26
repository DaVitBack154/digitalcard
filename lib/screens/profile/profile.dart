import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalcard/firebase/card_firebase.dart';
import 'package:digitalcard/Screens/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<GlobalKey> listKey = [];
  Map<String, dynamic>? userProfile;

  // final TextEditingController urlPhoto = TextEditingController();

  Future<void> getUserLogin() async {
    try {
      var res = await CardFirebase.getProfileInfo();
      userProfile = res;
    } catch (e) {
      print('get profile failed $e');
    }
  }

  @override
  void initState() {
    getUserLogin();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(userProfile.toString());
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 243, 240, 231),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            "ข้อมูลส่วนตัว",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 1, 92, 90),
                            ),
                          ),
                          SizedBox(height: 15),
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(
                              'assets/images/tokota.jpg',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: TextEditingController(
                                  text: '${userProfile!['name']}'),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Full-name',
                              ),
                              readOnly: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: TextEditingController(
                                  text: '${userProfile!['email']}'),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Email',
                              ),
                              readOnly: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: TextEditingController(
                                  text: '${userProfile!['phone']}'),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Phone',
                              ),
                              readOnly: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              auth.signOut().then((_) {
                                print('sign out complete');
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (ctc) => LoginScreen()));
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 238, 20, 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            icon: Icon(Icons.logout),
                            label: Text('SIGN OUT'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
    //   backgroundColor: Colors.grey.shade100,
    //   body: Padding(
    //     padding: const EdgeInsets.all(10.0),
    //     child: Column(
    //       children: [
    //         Text('this is Profile page'),
    //         ElevatedButton.icon(
    //           onPressed: () {
    //             auth.signOut().then((_) {
    //               print('sign out complete');
    //               Navigator.of(context).pushReplacement(
    //                   MaterialPageRoute(builder: (ctc) => LoginScreen()));
    //             });
    //           },
    //           icon: Icon(Icons.logout),
    //           label: Text('SIGN OUT'),
    //         ),
    //         Container(
    //           alignment: Alignment.center,
    //           margin: EdgeInsets.symmetric(horizontal: 40),
    //           child: TextFormField(
    //             controller: urlPhoto,
    //             decoration: InputDecoration(labelText: "urlPhoto"),
    //           ),
    //         ),
    //         ElevatedButton.icon(
    //           onPressed: () async {
    //             auth.currentUser!.updatePhotoURL(urlPhoto.text);
    //             auth.currentUser!.reload();

    //             urlPhoto.clear();

    //             setState(() {
    //               print('update profile');
    //             });
    //           },
    //           icon: Icon(Icons.logout),
    //           label: Text('UPDATE PROFILE'),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
