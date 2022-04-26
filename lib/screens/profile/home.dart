import 'package:digitalcard/Screens/profile/bookcard.dart';
import 'package:digitalcard/Screens/profile/profile.dart';
import 'package:digitalcard/screens/profile/mycard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;
  List<String> titles = ['Mycard', 'BookCard', 'Profile'];

  void onTabChange(int i) {
    setState(() {
      print('change page $i');
      currentTab = i;
    });
  }

  // get child => null;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // auth.currentUser!.updatePhotoURL(
    //     'https://static.remove.bg/remove-bg-web/b27c50a4d669fdc13528397ba4bc5bd61725e4cc/assets/start_remove-c851bdf8d3127a24e2d137a55b1b427378cd17385b01aec6e59d5d4b5f39d2ec.png');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 75,
        leadingWidth: 80,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: 50,
            child: auth.currentUser!.photoURL != null
                ? CircleAvatar(
                    // maxRadius: 20,
                    backgroundImage: NetworkImage(auth.currentUser!.photoURL!))
                : CircleAvatar(
                    // maxRadius: 20,
                    backgroundImage: AssetImage(
                      'assets/images/tokota.jpg',
                    ),
                  ),
          ),
        ),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${auth.currentUser!.displayName}",
                  style: TextStyle(
                    color: Color.fromARGB(255, 11, 65, 12),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.email),
                    Text(
                      "${auth.currentUser!.email}",
                      style: TextStyle(
                          color: Color.fromARGB(255, 11, 65, 12), fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: currentTab,
        children: [
          Mycard(),
          BookCard(),
          Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color.fromARGB(255, 232, 100, 29),
        unselectedItemColor: Color.fromARGB(255, 141, 140, 140),
        currentIndex: currentTab,
        // backgroundColor: Color.fromARGB(255, 250, 79, 17),
        onTap: onTabChange,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'MY-CARD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_card),
            label: 'BOOKCARD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }
}
