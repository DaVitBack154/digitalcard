import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalcard/firebase/card_firebase.dart';
import 'package:flutter/material.dart';

import '../scan.dart';

class BookCard extends StatefulWidget {
  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  ScrollController cardScroll = ScrollController();
  Map<String, dynamic> myCard = {};
  DocumentSnapshot? documentId;
  final scKey = GlobalKey<ScaffoldState>();
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
    // listOfCard = [
    //   {
    //     'uuiId': 'Test9912',
    //     'image_src': '',
    //   },
    // ];
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
    var xbul = StreamBuilder<QuerySnapshot>(
      stream: CardFirebase.getCards(),
      builder: (ctx, snap) {
        if (snap.hasError) {
          return Center(
            child: Text(snap.error.toString()),
          );
        }

        if (snap.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        if (!snap.hasData) return Text('data not found');

        var list = snap.data!.docs;
        var myCards = list.isNotEmpty
            ? list.map((e) => e.data()! as Map<String, dynamic>).first
            : null;

        if (myCards != null) {
          documentId = list.first;

          myCard = myCards;
        }

        List cardIds = List.from(myCards?['card_refs'] ?? []).toSet().toList();

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "รายการจัดเก็บนามบัตรทั้งหมด\r(${cardIds.length})",
              style: TextStyle(
                fontSize: 17,
                color: Color.fromARGB(255, 1, 92, 90),
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: CardFirebase.getCards(),
                  builder: (ctx, snap) {
                    if (snap.hasError) {
                      return Center(
                        child: Text(snap.error.toString()),
                      );
                    }

                    if (snap.connectionState == ConnectionState.waiting) {
                      return Text("Loading...");
                    }

                    if (!snap.hasData) return Text('data not found');

                    var list = snap.data!.docs;
                    var myCards = list.isNotEmpty
                        ? list
                            .map((e) => e.data()! as Map<String, dynamic>)
                            .first
                        : null;

                    if (myCards != null) {
                      documentId = list.first;

                      myCard = myCards;
                    }

                    List<String> cardIds =
                        List.from(myCards?['card_refs'] ?? []);

                    return ListView.builder(
                      controller: cardScroll,
                      itemCount: (cardIds.length),
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) {
                        var row = cardIds[i];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(row),
                              // AssetImage('assets/theme/${row['theme_id']}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );

    return Scaffold(
      key: scKey,
      backgroundColor: Color.fromARGB(255, 243, 240, 231),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: xbul,
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(10.0),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         "รายการจัดเก็บนามบัตรทั้งหมด\r(${listOfCard.length})",
      //         style: TextStyle(
      //           fontSize: 17,
      //           color: Color.fromARGB(255, 1, 92, 90),
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //       SizedBox(height: 10),
      //       Expanded(
      //         child: StreamBuilder<QuerySnapshot>(
      //             stream: CardFirebase.getCards(),
      //             builder: (ctx, snap) {
      //               if (snap.hasError) {
      //                 return Center(
      //                   child: Text(snap.error.toString()),
      //                 );
      //               }

      //               if (snap.connectionState == ConnectionState.waiting) {
      //                 return Text("Loading...");
      //               }

      //               if (!snap.hasData) return Text('data not found');

      //               var list = snap.data!.docs;
      //               var myCards = list.isNotEmpty
      //                   ? list
      //                       .map((e) => e.data()! as Map<String, dynamic>)
      //                       .first
      //                   : null;

      //               if (myCards != null) {
      //                 documentId = list.first;

      //                 myCard = myCards;
      //               }

      //               List<String> cardIds =
      //                   List.from(myCards?['card_refs'] ?? []);

      //               return ListView.builder(
      //                 controller: cardScroll,
      //                 itemCount: (cardIds.length),
      //                 shrinkWrap: true,
      //                 itemBuilder: (ctx, i) {
      //                   var row = cardIds[i];
      //                   return Container(
      //                     margin: EdgeInsets.symmetric(vertical: 5),
      //                     width: MediaQuery.of(context).size.width,
      //                     height: 200,
      //                     decoration: BoxDecoration(
      //                       image: DecorationImage(
      //                         image: NetworkImage(row),
      //                         // AssetImage('assets/theme/${row['theme_id']}'),
      //                         fit: BoxFit.cover,
      //                       ),
      //                     ),
      //                     // child: Stack(
      //                     //   children: [
      //                     //     Positioned(
      //                     //       right: 10,
      //                     //       top: 10,
      //                     //       child: IconButton(
      //                     //           onPressed: () {
      //                     //             setState(() {
      //                     //               // listOfCard.removeAt(i);
      //                     //               var curentRow = documentId!.data()
      //                     //                   as Map<String, dynamic>;
      //                     //               var r =
      //                     //                   List.from(curentRow['card_refs']);
      //                     //               r.removeAt(i);
      //                     //               curentRow['card_refs'] = r;
      //                     //               CardFirebase.updateCard(
      //                     //                   documentId!, curentRow);
      //                     //             });
      //                     //           },
      //                     //           icon: Icon(
      //                     //             Icons.delete,
      //                     //             color: Colors.red,
      //                     //           )),
      //                     //     ),
      //                     //     Align(
      //                     //       child: Column(
      //                     //         mainAxisAlignment: MainAxisAlignment.center,
      //                     //         children: [
      //                     //           Text(
      //                     //             row['theme_id'],
      //                     //             style: TextStyle(
      //                     //               fontSize: 20,
      //                     //               fontWeight: FontWeight.bold,
      //                     //             ),
      //                     //           ),
      //                     //         ],
      //                     //       ),
      //                     //     ),
      //                     //     Text(row['name'])
      //                     //   ],
      //                     // ),
      //                   );
      //                 },
      //               );

      //               // return FutureBuilder<List<Map<String, dynamic>>?>(
      //               //   future: CardFirebase.getCardsbyIds2(cardIds),
      //               //   builder: (ctx, snapRef) {
      //               //     if (snapRef.connectionState ==
      //               //         ConnectionState.waiting) {
      //               //       return Text("Loading...");
      //               //     }

      //               //     if (!snapRef.hasData) return Text('data not found');

      //               //     var cardRefs = snapRef.data;

      //               //     return ListView.builder(
      //               //       controller: cardScroll,
      //               //       itemCount: (cardRefs?.length ?? 0),
      //               //       shrinkWrap: true,
      //               //       itemBuilder: (ctx, i) {
      //               //         var row = cardRefs![i];
      //               //         return Container(
      //               //           margin: EdgeInsets.symmetric(vertical: 5),
      //               //           width: MediaQuery.of(context).size.width,
      //               //           height: 200,
      //               //           decoration: BoxDecoration(
      //               //             image: DecorationImage(
      //               //               image: AssetImage(
      //               //                   'assets/theme/${row['theme_id']}'),
      //               //               fit: BoxFit.cover,
      //               //             ),
      //               //           ),
      //               //           child: Stack(
      //               //             children: [
      //               //               Positioned(
      //               //                 right: 10,
      //               //                 top: 10,
      //               //                 child: IconButton(
      //               //                     onPressed: () {
      //               //                       setState(() {
      //               //                         // listOfCard.removeAt(i);
      //               //                         var curentRow = documentId!.data()
      //               //                             as Map<String, dynamic>;
      //               //                         var r = List.from(
      //               //                             curentRow['card_refs']);
      //               //                         r.removeAt(i);
      //               //                         curentRow['card_refs'] = r;
      //               //                         CardFirebase.updateCard(
      //               //                             documentId!, curentRow);
      //               //                       });
      //               //                     },
      //               //                     icon: Icon(
      //               //                       Icons.delete,
      //               //                       color: Colors.red,
      //               //                     )),
      //               //               ),
      //               //               Align(
      //               //                 child: Column(
      //               //                   mainAxisAlignment:
      //               //                       MainAxisAlignment.center,
      //               //                   children: [
      //               //                     Text(
      //               //                       row['theme_id'],
      //               //                       style: TextStyle(
      //               //                         fontSize: 20,
      //               //                         fontWeight: FontWeight.bold,
      //               //                       ),
      //               //                     ),
      //               //                   ],
      //               //                 ),
      //               //               ),
      //               //               Text(row['name'])
      //               //             ],
      //               //           ),
      //               //         );
      //               //       },
      //               //     );
      //               //   },
      //               // );

      //               // var listOfCard = myCards['card_refs'] ?? [];

      //               // return ListView.builder(
      //               //   controller: cardScroll,
      //               //   itemCount: listOfCard.length,
      //               //   shrinkWrap: true,
      //               //   itemBuilder: (ctx, i) {
      //               //     var r = listOfCard[i];
      //               //     return Container(
      //               //       height: 200,
      //               //       margin: EdgeInsets.symmetric(vertical: 5),
      //               //       width: MediaQuery.of(context).size.width,
      //               //       decoration: BoxDecoration(
      //               //         color: Color.fromARGB(255, 233, 225, 225),
      //               //         borderRadius: BorderRadius.circular(20),
      //               //         // boxShadow: BoxShadow.lerp(a, b, t)
      //               //       ),
      //               //       child: Stack(
      //               //         children: [
      //               //           // Positioned(
      //               //           //   right: 10,
      //               //           //   top: 10,
      //               //           //   child: IconButton(
      //               //           //       onPressed: () {
      //               //           //         setState(() {
      //               //           //           listOfCard.removeAt(i);
      //               //           //         });
      //               //           //       },
      //               //           //       icon: Icon(
      //               //           //         Icons.delete,
      //               //           //         color: Colors.red,
      //               //           //       )),
      //               //           // ),
      //               //           // Align(
      //               //           //   child: Column(
      //               //           //     mainAxisAlignment: MainAxisAlignment.center,
      //               //           //     children: [
      //               //           //       Text(
      //               //           //         r['uuiId'],
      //               //           //         style: TextStyle(
      //               //           //           fontSize: 20,
      //               //           //           fontWeight: FontWeight.bold,
      //               //           //         ),
      //               //           //       ),
      //               //           //     ],
      //               //           //   ),
      //               //           // ),
      //               //           // Text(r['image_src'])
      //               //         ],
      //               //       ),
      //               //     );
      //               //   },
      //               // );
      //             }),
      //       ),
      //       SizedBox(height: 20),
      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // print(myCard);
          Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => ScanQrBookCardPage()))
              .then((code) {
            // json

            // Map<String, dynamic>? scanMap;
            // print(code);
            // try {
            //   scanMap = json.decode(code);
            // } catch (e) {
            //   scanMap = null;
            //   print(e);
            // } finally {}

            // if (scanMap != null && scanMap['type'] == 'card') {
            //   // {"type":"card","userId":"yWKnfdeoyzczx01yrvt6FpyHzkt2","refId":"FJYUdCXlhILejoLWTV5Y"}
            //   print('print add card inapp ${scanMap.toString()}');
            //   var curentRow = documentId!.data() as Map<String, dynamic>;
            //   var listDupId = List.from(curentRow['card_refs']);
            //   if (listDupId.contains(scanMap['refId'])) {
            //     // scKey.currentState.showSnackBar(snackbar)
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text('นามบัตรนี้มีอยู่แล้ว'),
            //         duration: Duration(seconds: 3),
            //       ),
            //     );
            //     return;
            //   }

            //   curentRow['card_refs'].add(scanMap['refId']);
            //   CardFirebase.updateCards(documentId!, curentRow);

            if (code != null) {
              // {"type":"card","userId":"yWKnfdeoyzczx01yrvt6FpyHzkt2","refId":"FJYUdCXlhILejoLWTV5Y"}

              var curentRow = documentId!.data() as Map<String, dynamic>;
              var listDupId = List.from(curentRow['card_refs']);
              if (listDupId.contains(code)) {
                // scKey.currentState.showSnackBar(snackbar)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('นามบัตรนี้มีอยู่แล้ว'),
                    duration: Duration(seconds: 3),
                  ),
                );
                return;
              }

              curentRow['card_refs'].add(code);
              CardFirebase.updateCards(documentId!, curentRow);

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
