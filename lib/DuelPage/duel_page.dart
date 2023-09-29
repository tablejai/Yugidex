import "package:flutter/material.dart";

class DuelPage extends StatefulWidget {
  // final Card cardToDisplay;
  const DuelPage({super.key});

  @override
  State<DuelPage> createState() => _DuelPageState();
}

class _DuelPageState extends State<DuelPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData =
        ThemeData(useMaterial3: true, brightness: Brightness.light);
    return MaterialApp(
        theme: themeData,
        home: Scaffold(
            body: Column(
          children: <Widget>[
            TextButton(
                onPressed: () {}, child: Text("You are at the duel page"))
          ],
        )));
  }
}
