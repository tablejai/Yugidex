import "package:flutter/material.dart";
import "package:yugi_dex/Card/base_card.dart";
import "package:firebase_cached_image/firebase_cached_image.dart";
import "package:yugi_dex/Card/monster_card.dart";
import "package:yugi_dex/example_card.dart";

class CardViewPage extends StatefulWidget {
  // final Card cardToDisplay;
  const CardViewPage({super.key});

  @override
  State<CardViewPage> createState() => _CardViewPageState();
}

class _CardViewPageState extends State<CardViewPage> {
  Column cardParser(BaseCard inputCard) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // The Card Image
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 5.0, color: Colors.orangeAccent),
                    borderRadius: BorderRadius.circular(10.0)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image(
                        image: FirebaseImageProvider(
                            FirebaseUrl(inputCard.imageUrl)))))
          ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text(inputCard.name)])
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData =
        ThemeData(useMaterial3: true, brightness: Brightness.light);
    return MaterialApp(
        theme: themeData,
        home: Scaffold(
            appBar: AppBar(
                leading: BackButton(
                  color: Colors.black,
                  onPressed: () => Navigator.pop(context),
                ),
                centerTitle: true),
            body: cardParser(blueEyes)));
  }
}
