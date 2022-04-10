import 'dart:convert';

import 'package:flutter/material.dart';

import '../scan.dart';

class BookCard extends StatefulWidget {
  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  ScrollController cardScroll = ScrollController();
  List<Map<String, dynamic>> listOfCard = [
    // {
    //   'uuiId': 'Test9913',
    //   'image_src': '',
    // },
    // {
    //   'uuiId': 'Test9914',
    //   'image_src': '',
    // }
  ];
  @override
  void initState() {
    // TODO: implement initState
    listOfCard = [
      {
        'uuiId': 'Test9912',
        'image_src': '',
      },
    ];
    super.initState();
  }

  void scrollToBottom() {
    cardScroll.animateTo(
      cardScroll.position.maxScrollExtent + 200,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );

    // cardScroll.jumpTo(cardScroll.position.pixels);
  }

  // String? result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     SizedBox(height: 30),

            //     // Text(
            //     //   "(0)",
            //     //   style: TextStyle(
            //     //     fontSize: 17,
            //     //     color: Color.fromARGB(255, 1, 92, 90),
            //     //     fontWeight: FontWeight.bold,
            //     //   ),
            //     // ),
            //   ],
            // ),
            Text(
              "รายการจัดเก็บนามบัตรทั้งหมด\r(${listOfCard.length})",
              style: TextStyle(
                fontSize: 17,
                color: Color.fromARGB(255, 1, 92, 90),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                  controller: cardScroll,
                  itemCount: listOfCard.length,
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) {
                    var r = listOfCard[i];
                    return Container(
                      height: 200,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 233, 225, 225),
                        borderRadius: BorderRadius.circular(20),
                        // boxShadow: BoxShadow.lerp(a, b, t)
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 10,
                            top: 10,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    listOfCard.removeAt(i);
                                  });
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ),
                          Align(
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  r['uuiId'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(r['image_src'])
                        ],
                      ),
                    );
                  }),
            ),
            SizedBox(height: 20),
            // Card(
            //     child: Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Column(
            //     children: [
            //       Text("ผลการสแกน"),
            //     ],
            //   ),
            // ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => ScanQrBookCardPage()))
              .then((code) {
            // json

            Map<String, dynamic>? scanMap;
            print(code);
            try {
              scanMap = json.decode(code);
            } catch (e) {
              scanMap = null;
              print(e);
            } finally {}

            if (scanMap != null && scanMap['type'] == 'card') {
              print('print add card inapp');
              listOfCard.add(
                {
                  'uuiId': 'Test9912-${DateTime.now().millisecond}',
                  'image_src': '$code',
                },
              );
              scrollToBottom();
            } else {
              print('other scan');
            }

            setState(() {});

            // // Future.delayed(Duration(milliseconds: 500));
          });
        },
        child: Icon(
          Icons.badge_outlined,
          size: 35,
        ),
      ),
    );
  }
}
