import "package:file_picker/file_picker.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "dart:developer";
import "dart:io";

class UploadFilePage extends StatefulWidget {
  const UploadFilePage({super.key});

  @override
  State<UploadFilePage> createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  Future selectFile() async {
    final selectedFile =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    if (selectedFile == null) return;

    final selectedFilePath = selectedFile.files.single.path!;
    final fileToUplaod = File(selectedFilePath);

    // Create the reference to Firebase
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref();

    final metadata = SettableMetadata(contentType: "image/jpeg");

    try {
      await storageRef.child("images/test.jpg").putFile(fileToUplaod, metadata);
    } on FirebaseException catch (e) {
      log("The current error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData =
        ThemeData(useMaterial3: true, brightness: Brightness.light);
    return MaterialApp(
        theme: themeData,
        home: Scaffold(
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    child: const Text("LOL"),
                    onPressed: () {
                      selectFile();
                    }))));
  }
}
