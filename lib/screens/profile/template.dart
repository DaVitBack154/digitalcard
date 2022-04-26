import 'dart:developer';

import 'package:digitalcard/common/utill.dart';
import 'package:digitalcard/firebase/card_firebase.dart';
import 'package:digitalcard/models/theme_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class TemplateCard extends StatefulWidget {
  const TemplateCard({Key? key}) : super(key: key);

  @override
  State<TemplateCard> createState() => _TemplateCardState();
}

class _TemplateCardState extends State<TemplateCard> {
  bool isLoading = false;
  List<ThemeCard> itemThemes = [];
  List<GlobalKey> listKey = [];
  Map<String, dynamic>? userProfile;

  bool get itemChecked => itemThemes.where((e) => e.isChecked).length > 0;

  Future<void> loadData() async {
    try {
      isLoading = true;
      await Future.delayed(Duration(seconds: 1));
      int itemCount = 4;
      for (var i = 0; i < 4; i++) {
        String prefix = (i + 1).toString();
        itemThemes.add(ThemeCard(id: prefix, name: 'theme-00$prefix.jpg'));
        listKey.add(GlobalKey());
      }
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
    loadData();
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
      appBar: AppBar(
        backgroundColor: Color(0xffF5591F),
        title: Text(
          "Template-Card",
        ),
      ),
      body: isLoading
          ? Center(
              child: Text(
                "Loding...",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('โปรดเลือกธีมที่ต้องการใช้งาน'),
                        Text('ทั้งหมด (${itemThemes.length})'),
                      ],
                    ),
                  ),
                  Expanded(
                    // padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                      itemCount: itemThemes.length,
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) {
                        final item = itemThemes[i];

                        return GestureDetector(
                          onTap: () {
                            // item.isChecked = !item.isChecked;
                            itemThemes.forEach((t) {
                              t.isChecked = item.id == t.id;
                              // t.isChecked = false;
                            });
                            // item.isChecked = !item.isChecked;
                            setState(() {});
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 2,
                                  color: item.isChecked
                                      ? Colors.blue
                                      : Colors.grey.shade200),
                            ),
                            child: RepaintBoundary(
                              key: listKey[i],
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.transparent,
                                  ),
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/theme/${item.name}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(children: [
                                  Positioned(
                                    top: 40,
                                    left: 170,
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Icon(Icons.person),
                                        Text(
                                          '${userProfile!['name']}',
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 1, 92, 90),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "Programmer",
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 1, 92, 90),
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.email,
                                              color: Color(0xffF5591F),
                                            ),
                                            Text(' ${userProfile!['email']}')
                                          ],
                                        ),
                                        SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              color: Color(0xffF5591F),
                                            ),
                                            Text(' ${userProfile!['phone']}')
                                          ],
                                        ),
                                        SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.web,
                                              color: Color(0xffF5591F),
                                            ),
                                            Text(' chase.co.th')
                                          ],
                                        ),

                                        // Icon(Icons.email),
                                        // Text(
                                        //   ': ${userProfile!['email']}',
                                        //   style: TextStyle(
                                        //     color: Colors.black87,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 18,
                                        //   ),
                                        // ),
                                        // Icon(Icons.phone),
                                        // Text(
                                        //   ': ${userProfile!['phone']}',
                                        //   style: TextStyle(
                                        //     color: Colors.black87,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 18,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            height: 200,
                            // child: Text(item.isChecked ? 'Checked' : 'display'),
                            // child: Image.asset(name)
                            // Text(item.name.toString(),),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(0xffF5591F),
            padding: EdgeInsets.all(10),
          ),
          onPressed: itemChecked
              ? () async {
                  var getTheme =
                      itemThemes.firstWhereOrNull((d) => d.isChecked);

                  var getIndex = itemThemes.indexWhere((e) => e.isChecked);

                  FirebaseAuth auth = FirebaseAuth.instance;

                  var fileCapture =
                      await Utils.captureImagePostition(key: listKey[getIndex]);

                  print(fileCapture);
                  var upload = await Utils.uploadFileToStorage(fileCapture);

                  var getImageUrl = await Utils.dowloadUrl(upload!);

                  await CardFirebase.addCard({
                    'name': auth.currentUser!.displayName,
                    'email': auth.currentUser!.email,
                    'uuid': auth.currentUser!.uid,
                    'card_refs': [],
                    'theme_id': getTheme!.name,
                    'public_url': getImageUrl,
                  });
                  Navigator.pop(context);

                  print('use this theme');
                }
              : null,
          child: Text(
            'Use theme',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
