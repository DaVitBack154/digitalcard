import 'package:flutter/material.dart';

class VeiwPage extends StatelessWidget {
  const VeiwPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var orital = MediaQuery.of(context).orientation;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: Colors.black87,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: size.height * 0.7,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.network(
                        args['public_url'],
                        fit: BoxFit.cover,
                      ),
                      // child: Image.asset(
                      //   "assets/theme/${args['theme_id']}",
                      // ),
                      // child: Image.network(
                      //   'https://helpx.adobe.com/content/dam/help/en/photoshop/using/convert-color-image-black-white/jcr_content/main-pars/before_and_after/image-before/Landscape-Color.jpg',
                      //   fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
