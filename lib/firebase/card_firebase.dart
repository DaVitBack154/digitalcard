import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CardFirebase {
  CardFirebase._();

  static const String collectName = 'cards';

  static FirebaseFirestore get firestore => FirebaseFirestore.instance;

  static Stream<QuerySnapshot>? getCards() {
    try {
      var auth = FirebaseAuth.instance;

      final res = firestore
          .collection(collectName)
          .where('uuid', isEqualTo: auth.currentUser!.uid)
          .snapshots();
      // print('response ${res.}');

      return res;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // static Stream<QuerySnapshot>? getCardsbyIds(List<String> ids) {
  //   try {
  //     var auth = FirebaseAuth.instance;

  //     final res = firestore.collection(collectName)
  //         // .where('uuid', isEqualTo: auth.currentUser!.uid)
  //         // .where(field)
  //         // .where(field)
  //         // .doc()
  //         .where('id', whereIn: ['FJYUdCXlhILejoLWTV5Y']).snapshots();
  //     // // print('response ${res.}');
  //     // var rrr =
  //     //     firestore.collection(collectName).startAtDocument('FJYUdCXlhILejoLWTV5Y').snapshots()

  //     return res;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  static Future<List<Map<String, dynamic>>?>? getCardsbyIds2(
      List<String> ids) async {
    try {
      // var auth = FirebaseAuth.instance;

      List<Map<String, dynamic>> listOutput = [];

      for (var id in ids) {
        var resById = await firestore.collection(collectName).doc(id).get();

        var mapItem = resById.data()!;
        mapItem['documentId'] = id;
        listOutput.add(mapItem);
      }

      return Future.value(listOutput);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> getCardsFureture() async {
    try {
      List<Map<String, dynamic>>? res;
      await firestore.collection(collectName).snapshots().listen((qSnap) {
        qSnap.docs.forEach((element) {
          var rr = element.data();
        });
        // res = qSnap.docs.map((d) {
        //   d.data()
        // });
      });
      // print('response ${res.}');
      return res;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<void> addCard(Map<String, dynamic> itemToUpdate) async {
    await firestore.collection(collectName).add(itemToUpdate);
  }

  static Future<void> updateCard(
    DocumentSnapshot doc,
    Map<String, dynamic> itemToUpdate,
  ) async {
    await firestore.collection(collectName).doc(doc.id).update(itemToUpdate);
  }

  static Future<void> updateCards(
    DocumentSnapshot doc,
    Map<String, dynamic> itemToUpdate,
  ) async {
    await firestore.collection(collectName).doc(doc.id).update(itemToUpdate);
    // var rrrrrr = await res.get();
    // await firestore.collection(collectName).doc(doc.id).update(itemToUpdate);
  }

  static Future<void> deleteCard(DocumentSnapshot doc) async {
    await firestore.collection(collectName).doc(doc.id).delete();
  }

  static Future<void> deleteCardByDocument(DocumentSnapshot doc) async {
    await firestore.collection(collectName).doc(doc.id).delete();
  }
}
