import "package:flutter/material.dart";
import "package:firebase_cached_image/firebase_cached_image.dart";

class CardListItem extends StatelessWidget {
  CardListItem({required this.updatePage});

  late final Function updatePage;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.greenAccent),
            borderRadius: BorderRadius.circular(20.0)),
        child: InkWell(
            onTap: () => updatePage(4),
            child: Row(children: <Widget>[
              Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                          image: FirebaseImageProvider(
                              FirebaseUrl(
                                  "gs://yugidex-7169d.appspot.com/cards/yugioh/BlueEyesWhiteDragon.jpg"),
                              options: const CacheOptions(
                                  source: Source.cacheServer))))),
              const Expanded(
                  child: Column(children: <Widget>[
                Text("Blue Eyes White Dragon"),
                Text("Dragon / Normal")
              ])),
              Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/LevelStar.png")))),
              const Text("7")
            ])));
  }
}

class CardList extends StatefulWidget {
  late List<CardListItem> itemList;
  CardList({required Function updatePage, super.key}) {
    itemList =
        List.generate(20, (int index) => CardListItem(updatePage: updatePage));
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
