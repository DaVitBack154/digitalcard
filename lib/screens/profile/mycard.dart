import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalcard/firebase/card_firebase.dart';
import 'package:digitalcard/screens/profile/template.dart';
import 'package:digitalcard/screens/profile/view.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class Mycard extends StatefulWidget {
  const Mycard({Key? key}) : super(key: key);

  @override
  State<Mycard> createState() => _MycardState();
}

class _MycardState extends State<Mycard> {
  final key = GlobalKey();
  FirebaseAuth auth = FirebaseAuth.instance;

  Widget _buildOpts(DocumentSnapshot document) {
    List<Map<String, dynamic>> itemsWidget = [
      {
        'icon': Icon(Icons.search),
        'onTab': () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VeiwPage(),
                  settings: RouteSettings(arguments: document.data())));
        },
      },
      {
        'icon': Icon(Icons.qr_code),
        'onTab': () {
          final imageName = 'photo-gallery-for-website-html-code.png';
          var data = document.data() as Map<String, dynamic>;
          showModalBottomSheet<void>(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (c) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                        'Show QR-Code',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    RepaintBoundary(
                      key: key,
                      child: Container(
                        color: Colors.white,
                        child: QrImage(
                          data: json.encode({
                            'type': 'card',
                            'userId': auth.currentUser!.uid,
                            'refId': document.id
                          }),
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        '${data['name']}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      child: IconButton(
                        onPressed: () async {
                          // check persminion storage

                          // if (!await Permission.storage.request().isGranted) {
                          //   print('not allow');
                          //   return;
                          // }

                          // Directory appDocDir =
                          //     await getApplicationDocumentsDirectory();
                          // String appDocPath =
                          //     '/storage/emulated/0/Download/$imageName';

                          // var res = await Dio().download(
                          //     "https://codeconvey.com/wp-content/uploads/2020/09/$imageName",
                          //     appDocPath);

                          // print('allow  storage $res');

                          try {
                            RenderRepaintBoundary boundary = key.currentContext!
                                .findRenderObject() as RenderRepaintBoundary;

                            var image = await boundary.toImage();
                            ByteData? byteData = await image.toByteData(
                                format: ImageByteFormat.png);
                            Uint8List pngBytes = byteData!.buffer.asUint8List();

                            final appDir =
                                await getApplicationDocumentsDirectory();

                            var datetime = DateTime.now();

                            var file =
                                await File('${appDir.path}/$datetime.png')
                                    .create();

                            await file.writeAsBytes(pngBytes);
// Share.shareFiles(['${directory.path}/image1.jpg', '${directory.path}/image2.jpg']);

                            await Share.shareFiles(
                              [file.path],
                              mimeTypes: ["image/png"],
                              text: "Share the QR Code",
                            );
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                        icon: Icon(Icons.download),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      },
      {
        'icon': Icon(Icons.download),
        'onTab': () {},
      },
      {
        'icon': Icon(Icons.delete),
        'onTab': () async {
          await CardFirebase.deleteCard(document);
        },
      }
    ];
    return Container(
        height: 50,
        color: Colors.black87.withOpacity(.8),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Row(
          // spacing: 5,
          // runAlignment: WrapAlignment.spaceAround,
          // crossAxisAlignment: WrapCrossAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...List.generate(
              itemsWidget.length,
              (index) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // color: Colors.white,
                  primary: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: itemsWidget[index]['onTab'],
                child: itemsWidget[index]['icon'],
              ),
            )
          ],
        )
        //   Padding(
        //   padding: const EdgeInsets.all(7.0),
        //   child: GridView.count(
        //     crossAxisCount: itemsWidget.length,
        //     mainAxisSpacing: 40,
        //     crossAxisSpacing: 40,
        //     children:
        //     [
        //       ...List.generate(
        //         itemsWidget.length,
        //         (index) => ElevatedButton(
        //           style: ElevatedButton.styleFrom(
        //             // color: Colors.white,
        //             primary: Colors.transparent,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(10),
        //               side: BorderSide(color: Colors.white),
        //             ),
        //           ),
        //           onPressed: itemsWidget[index]['onTab'],
        //           child: itemsWidget[index]['icon'],
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Digital-Card',
                    style: TextStyle(
                      color: Color.fromARGB(255, 11, 65, 12),
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TemplateCard();
                    }));
                    // await CardFirebase.addCard({
                    //   'name': 'Nut',
                    //   'uuid': '121212asdasd',
                    //   'card_refs': ['1111', '1111'],
                    //   'theme': 'A-001',
                    // });
                  },
                  style: ElevatedButton.styleFrom(
                    // 0xFF #
                    primary: Color.fromARGB(255, 1, 92, 90),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: Icon(Icons.add),
                  label: Text('Create-Card'),
                ),
              ],
            ),
            // SizedBox(height: 10),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: CardFirebase.getCards(),
                builder: (ctx, snap) {
                  // snap.data;
                  if (snap.hasError) {
                    return Center(
                      child: Text(snap.error.toString()),
                    );
                  }

                  // <QuerySnapshot<Map<String,dynamic>>
                  // if (snap.connectionState != ConnectionState.done)
                  //   return Text('loading....');
                  if (snap.connectionState == ConnectionState.waiting) {
                    return Text("Loading...");
                  }

                  if (!snap.hasData) return Text('data not found');

                  return ListView(
                    children: [
                      ...snap.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return _buildCard(context, data, document);
                      }).toList()
                    ],
                  );

                  // return ListView.builder(
                  //   itemCount: 0,
                  //   shrinkWrap: true,
                  //   itemBuilder: (ctx, i) {

                  //   },
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    Map<String, dynamic> data,
    DocumentSnapshot<Object?> document,
  ) {
    return Card(
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/theme/${data['theme_id']}'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Positioned(
                top: 10,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data['name']}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${data['email']}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   child: Image.asset(
              //     'assets/theme/${data['theme_id']}',
              //     fit: BoxFit.cover,
              //   ),
              // ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildOpts(document),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
