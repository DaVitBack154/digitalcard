import 'package:digitalcard/Screens/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController urlPhoto = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text('this is Profile page'),
            ElevatedButton.icon(
              onPressed: () {
                auth.signOut().then((_) {
                  print('sign out complete');
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (ctc) => LoginScreen()));
                });
              },
              icon: Icon(Icons.logout),
              label: Text('SIGN OUT'),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                controller: urlPhoto,
                decoration: InputDecoration(labelText: "urlPhoto"),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                auth.currentUser!.updatePhotoURL(urlPhoto.text);
                auth.currentUser!.reload();

                urlPhoto.clear();

                setState(() {
                  print('update profile');
                });
              },
              icon: Icon(Icons.logout),
              label: Text('UPDATE PROFILE'),
            )
          ],
        ),
      ),
    );
  }
}
