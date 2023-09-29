import "package:flutter/material.dart";

class NewsPage extends StatefulWidget {
  // final Card cardToDisplay;
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
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
                onPressed: () {}, child: Text("You are at the news page"))
          ],
        )));
  }
}
