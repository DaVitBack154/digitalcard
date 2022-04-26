import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class Utils {
  Utils._();

  static Future<File> captureImagePostition(
      {required GlobalKey key, String? fileNameWithOutExtension}) async {
    RenderRepaintBoundary boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    var fileName = fileNameWithOutExtension == null
        ? 'card-${DateTime.now().millisecondsSinceEpoch}'
        : path.basenameWithoutExtension(fileNameWithOutExtension);

    File imgFile = File('$directory/$fileName.png');

    log('image path ${imgFile.path}');
    imgFile.writeAsBytes(pngBytes);
    return imgFile;
    // await uploadFileToStrong(imgFile);
  }

  static Future<void> shareFile(
    List<String> paths, {
    String? text,
  }) async {
    await Share.shareFiles(
      paths,
      mimeTypes: ["image/png"],
      text: text,
    );
  }

  static Future<TaskSnapshot?> uploadFileToStorage(File file) async {
    try {
      final String fileName = path.basename(file.path);

      // await storage
      Reference ref = FirebaseStorage.instance.ref().child('/$fileName');
      // .child('cards')

      final metaData = SettableMetadata(
        contentType: 'image/png',
      );

      var resUpload = await ref.putFile(file, metaData);
      return resUpload;
    } on FirebaseException catch (er) {
      print('firebase error $er');
      throw er;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<String> dowloadUrl(TaskSnapshot snapshot) async {
    var downloadUrl = await snapshot.ref.getDownloadURL();
    log('download url ======> $downloadUrl');
    return downloadUrl;
  }

  // Future<void> downloadFile(String url, {required String filename}) async {
  //   var httpClient = http.Client();
  //   var request = new http.Request('GET', Uri.parse(url));
  //   var response = httpClient.send(request);
  //   String dir = (await getApplicationDocumentsDirectory()).path;

  //   List<List<int>> chunks = [];
  //   int downloaded = 0;

  //   response.asStream().listen((http.StreamedResponse r) {
  //     r.stream.listen((List<int> chunk) {
  //       // Display percentage of completion
  //       debugPrint(
  //           'downloadPercentage: ${downloaded / r.contentLength! * 100}');

  //       chunks.add(chunk);
  //       downloaded += chunk.length;
  //     }, onDone: () async {
  //       // Display percentage of completion
  //       debugPrint(
  //           'downloadPercentage: ${downloaded / r.contentLength! * 100}');

  //       // Save the file
  //       File file = File('$dir/$filename');
  //       final Uint8List bytes = Uint8List(r.contentLength!);
  //       int offset = 0;
  //       for (List<int> chunk in chunks) {
  //         bytes.setRange(offset, offset + chunk.length, chunk);
  //         offset += chunk.length;
  //       }
  //       await file.writeAsBytes(bytes);
  //       return;
  //     });
  //   });
  // }

  static Future<File> downloadFile(String url, String filename) async {
    http.Client client = http.Client();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}
