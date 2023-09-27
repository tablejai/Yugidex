import "package:flutter/material.dart";
import "dart:developer";
import "dart:io";

class CardViewPage extends StatefulWidget {
  const CardViewPage({super.key});

  @override
  State<CardViewPage> createState() => _CardViewPageState();
}

class _CardViewPageState extends State<CardViewPage> {
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
                    child: const Text("A Card"),
                    onPressed: () {
                      log("So you clicked a card");
                    }))));
  }
}
