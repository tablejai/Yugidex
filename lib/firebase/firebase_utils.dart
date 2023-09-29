import "package:firebase_storage/firebase_storage.dart";
import "dart:io";
import "dart:developer";

Reference getStorageRef() {
  return FirebaseStorage.instance.ref();
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
