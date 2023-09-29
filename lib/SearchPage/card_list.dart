import "package:flutter/material.dart";
import "package:firebase_cached_image/firebase_cached_image.dart";
import "package:yugi_dex/Card/base_card.dart";
import "package:yugi_dex/Card/monster_card.dart";
import "dart:developer";
import "package:yugi_dex/SearchPage/page_route.dart";

MainDeckMonsterCard blueEyes = MainDeckMonsterCard(
    "gs://yugidex-7169d.appspot.com/cards/yugioh/BlueEyesWhiteDragon.jpg",
    "Blue Eyes White Dragon",
    MonsterCardType.normal,
    MonsterAttribute.dark,
    MonsterType.dragon,
    false,
    3000,
    2500,
    "Very Strong",
    7);

class CardListItem extends StatelessWidget {
  const CardListItem({super.key});

  static final cardSystemMapping = {
    "Level": Image.asset("images/LevelStar.png").image,
    "Rank": Image.asset("images/RankStar.png").image,
    "Link": Image.asset("images/LinkCircuit.png").image
  };

  String cardTypeParser(BaseCard inputCard) {
    log("Card type = $inputCard.runtimeType");
    return "Dragon/ Normal";
  }

  Row cardSystemParser(BaseCard inputCard) {
    return inputCard is MonsterCard
        ? Row(children: <Widget>[
            Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    image:
                        DecorationImage(image: cardSystemMapping["Level"]!))),
            const Text("8")
          ])
        : const Row();
  }

  // Parses Card to the row object
  Row cardParser(BaseCard inputCard) {
    DecorationImage cardImage = DecorationImage(
        image: FirebaseImageProvider(FirebaseUrl(inputCard.imageUrl),
            options: const CacheOptions(source: Source.cacheServer)));
    return Row(children: <Widget>[
      // Leftmost part of the card's brief view (image)
      Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), image: cardImage)),
      // Middle part of the card's brief view
      Expanded(
          child: Column(children: <Widget>[
        Text(inputCard.name),
        Text(cardTypeParser(inputCard))
      ])),
      // TODO: Generate this last part only if the card is a monter card
      // End part of the card's brief view (levels, rank, link)
      cardSystemParser(inputCard)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.greenAccent),
            borderRadius: BorderRadius.circular(20.0)),
        child: InkWell(
            onTap: () => Navigator.of(context).push(createCardViewPageRoute()),
            child: cardParser(blueEyes)));
  }
}

class CardList extends StatefulWidget {
  late List<CardListItem> itemList;
  CardList({super.key}) {
    itemList = List.generate(20, (int index) => const CardListItem());
  }

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: widget.itemList);
  }
}
