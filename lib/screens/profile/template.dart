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

  bool get itemChecked => itemThemes.where((e) => e.isChecked).length > 0;

  Future<void> loadData() async {
    try {
      isLoading = true;
      await Future.delayed(Duration(seconds: 1));
      int itemCount = 4;
      for (var i = 0; i < 4; i++) {
        String prefix = (i + 1).toString();
        itemThemes.add(ThemeCard(id: prefix, name: 'theme-00$prefix.jpg'));
      }
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CARD"),
      ),
      body: isLoading
          ? Center(
              child: Text("loding..."),
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
                              // color: Color.fromARGB(255, 243, 33, 173),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 2,
                                  color: item.isChecked
                                      ? Colors.blue
                                      : Colors.grey.shade200),
                              image: DecorationImage(
                                image: AssetImage('assets/theme/${item.name}'),
                                fit: BoxFit.cover,
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
            primary: Colors.green.shade400,
            padding: EdgeInsets.all(10),
          ),
          onPressed: itemChecked
              ? () async {
                  var getTheme =
                      itemThemes.firstWhereOrNull((d) => d.isChecked);

                  FirebaseAuth auth = FirebaseAuth.instance;

                  await CardFirebase.addCard({
                    'name': auth.currentUser!.displayName,
                    'email': auth.currentUser!.email,
                    'uuid': auth.currentUser!.uid,
                    'card_refs': [],
                    'theme_id': getTheme!.name,
                  });
                  Navigator.pop(context);

                  print('use this theme');
                }
              : null,
          child: Text('Use theme'),
        ),
      ),
    );
  }
}
