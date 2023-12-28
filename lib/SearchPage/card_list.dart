import "package:flutter/material.dart";
import "package:firebase_cached_image/firebase_cached_image.dart";
import "package:yugi_dex/Card/base_card.dart";
import "package:yugi_dex/Card/monster_card.dart";
import "dart:developer";
import "package:yugi_dex/SearchPage/page_route.dart";
import "package:yugi_dex/example_card.dart";
import "package:yugi_dex/firebase/firebase_utils.dart";

class CardListItem extends StatefulWidget {
  const CardListItem({super.key});

  @override
  State<CardListItem> createState() => _CardListItemState();
}

class _CardListItemState extends State<CardListItem> {
  static final cardSystemLogoMapping = {
    "Level": Image.asset("images/LevelStar.png").image,
    "Rank": Image.asset("images/RankStar.png").image,
    "Link": Image.asset("images/LinkCircuit.png").image
  };

  String monsterCardSystemMapping(BaseCard inputCard) {
    if (inputCard is LinkMonsterCard) {
      return "Link";
    } else if (inputCard is XYZMonsterCard) {
      return "Rank";
    } else {
      return "Level";
    }
  }

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
                    image: DecorationImage(
                  image: getMonsterSystemLogo(inputCard).image,
                ))),
            Text(inputCard.systemValue.toString())
          ])
        : const Row();
  }

  // Parses Card to the row object
  Row cardParser(BaseCard inputCard) {
    DecorationImage cardImage = DecorationImage(
        image: FirebaseImageProvider(FirebaseUrl(inputCard.imageUrl),
            options: const CacheOptions(source: Source.cacheServer)));
    return Row(children: <Widget>[
      FutureBuilder(
          future: getImage(context, inputCard.imageUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(height: 100, width: 100, child: snapshot.data);
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  height: 100, width: 100, child: CircularProgressIndicator());
            }
            return Container(height: 100, width: 100);
          }),
      // Leftmost part of the card's brief view (image)
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
