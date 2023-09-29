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
  final TextStyle titleStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontFamily: "Proxima Nova", fontSize: 20);
  final TextStyle normalTextStyle = const TextStyle(
      fontWeight: FontWeight.normal, fontFamily: "Proxima Nova", fontSize: 15);
  final TextStyle monsterCardLabelStyle = const TextStyle(
      fontWeight: FontWeight.normal, fontFamily: "Proxima Nova", fontSize: 25);

  // TODO: Generalize the way of forming the monster card type
  Row monsterCardType(MonsterCard inputCard) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text(
            "${monsterTypeEnumToString[inputCard.type]} / ${monsterCardTypeEnumToString[inputCard.monsterCardType]}",
            style: monsterCardLabelStyle)
      ]),
    ]);
  }

  Row monsterCardLabel(MonsterCard inputCard) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: getMonsterSystemLogo(inputCard).image))),
        Text(inputCard.systemValue.toString(), style: monsterCardLabelStyle)
      ]),
      Text("ATK/ ${inputCard.atk}  DEF/ ${inputCard.def}",
          style: monsterCardLabelStyle),
      Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: getMonsterAttributeImage(inputCard).image))),
    ]);
  }

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
              children: <Widget>[Text(inputCard.name, style: titleStyle)]),
          inputCard is MonsterCard ? monsterCardType(inputCard) : const Row(),
          inputCard is MonsterCard ? monsterCardLabel(inputCard) : const Row(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text("Effect", textAlign: TextAlign.left)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(inputCard.effectText,
                  textAlign: TextAlign.left, style: normalTextStyle)
            ],
          )
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
