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

      // var res2 =
      //     firestore.collection(collectName).withConverter<Map<String, dynamic>>(
      //           fromFirestore: (snapshots, _) => snapshots.data()!,
      //           toFirestore: (movie, _) => movie,
      //         );

      // var reee =  res2.get();

      return res;
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

  static Future<void> deleteCard(DocumentSnapshot doc) async {
    await firestore.collection(collectName).doc(doc.id).delete();
  }
}
