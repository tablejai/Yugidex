import "package:firebase_storage/firebase_storage.dart";
import "dart:io";
import "dart:developer";

import "package:flutter/material.dart";

Reference getStorageRef() {
  return FirebaseStorage.instance.ref();
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadFromStorage(
      BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}

Future uploadFileToFirebase(
    File fileToUpload, String uploadPath, SettableMetadata metadata) async {
  try {
    await getStorageRef()
        .child("images/test.jpg")
        .putFile(fileToUpload, metadata);
    return 1;
  } on FirebaseException catch (e) {
    log("Upload Error: $e");
    return -1;
  }
}

Future downlaodFileFromFirebase(String downloadPath) async {
  try {
    final downloadedData =
        await getStorageRef().child(downloadPath).getDownloadURL();
    return downloadedData;
  } on FirebaseException catch (e) {
    log("Download Error: $e");
    return "A";
  }
}

Future<Widget> getImage(BuildContext context, String image) async {
  Image m = const Image(image: AssetImage('images/SpongeBob.jpg'));
  await FireStorageService.loadFromStorage(context, image).then((downloadUrl) {
    m = Image.network(
      downloadUrl.toString(),
      fit: BoxFit.scaleDown,
    );
  });

  return m;
}
