import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalcard/common/utill.dart';
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
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class Mycard extends StatefulWidget {
  const Mycard({Key? key}) : super(key: key);

  @override
  State<Mycard> createState() => _MycardState();
}

class _MycardState extends State<Mycard> {
  final key = GlobalKey();
  final GlobalKey genCardKey = GlobalKey();
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
                          data: data['public_url'],
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
                  ],
                ),
              );
            },
          );
        },
      },
      {
        'icon': Icon(Icons.download),
        'onTab': () async {
          log('download');
          var data = document.data() as Map<String, dynamic>;
          var fileName = 'card-${DateTime.now().millisecondsSinceEpoch}.png';
          var res = await Utils.downloadFile(data['public_url'], fileName);

          Utils.shareFile([res.path]);
        },
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
        ));
  }

  @override
  void initState() {
    //  WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 243, 240, 231),
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
                    text: 'นามบัตรของฉัน',
                    style: TextStyle(
                      color: Color.fromARGB(255, 19, 94, 20),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TemplateCard();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    // 0xFF #
                    primary: Color(0xffF5591F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: Icon(Icons.add),
                  label: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'สร้างนามบัตร',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
    return RepaintBoundary(
      key: genCardKey,
      child: Card(
        // genCardKey
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(data['public_url']),
              // AssetImage('assets/theme/${data['theme_id']}'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildOpts(document),
            ),
          ),
        ),
      ),
    );
  }
}
