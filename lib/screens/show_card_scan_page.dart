import 'package:flutter/material.dart';

class ShowCardScanPage extends StatelessWidget {
  const ShowCardScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(),
          ],
        ),
      ),
    );
  }
}
