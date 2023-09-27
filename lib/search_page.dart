import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import "package:cached_network_image/cached_network_image.dart";
import 'package:yugi_dex/firebase/firebase_utils.dart';
import "package:firebase_cached_image/firebase_cached_image.dart";
import "firebase/firebase_options.dart";

// TODO: Creata a class for this and wrap the tap callback functions in the class
Card cardBuilder(String randomText, Function updatePage) {
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

class SearchBarApp extends StatefulWidget {
  late final Function updatePage;
  SearchBarApp({required this.updatePage, super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  bool isDark = false;

  void triggerSearch(String searchText) {
    log("Trying to search with $searchText");
  }

  List<ListTile> cardSearchSuggestionBuilder(
      BuildContext context, SearchController controller) {
    // TODO: Make these suggested names generated from the database
    List<String> suggestedCardNames = [
      "Blue Eyes White Dragon",
      "Dark Magician"
    ];

    return List<ListTile>.generate(2, (int index) {
      final currentCardName = suggestedCardNames[index];
      return ListTile(
        title: Text(currentCardName),
        onTap: () {
          setState(() {
            controller.closeView(currentCardName);
            triggerSearch(currentCardName);
          });
        },
      );
    });
  }

  SearchBar searchbarBuilder(
      BuildContext context, SearchController controller) {
    return SearchBar(
      controller: controller,
      hintText: "Input Card Name",
      padding: const MaterialStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 16.0)),
      onTap: () {
        controller.openView();
      },
      onChanged: (_) {
        controller.openView();
      },
      onSubmitted: (value) {
        controller.closeView(value);
        triggerSearch(value);
      },
      leading: const Icon(Icons.search),
      trailing: <Widget>[
        Tooltip(
          message: 'Change brightness mode',
          child: IconButton(
            isSelected: isDark,
            onPressed: () {
              setState(() {
                isDark = !isDark;
              });
            },
            icon: const Icon(Icons.wb_sunny_outlined),
            selectedIcon: const Icon(Icons.brightness_2_outlined),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light);

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchAnchor(
                    builder: (BuildContext context, controller) =>
                        searchbarBuilder(context, controller),
                    suggestionsBuilder:
                        (BuildContext context, SearchController controller) =>
                            cardSearchSuggestionBuilder(context, controller)),
              ),
              Flexible(
                  child: ListView(
                shrinkWrap: true,
                children: List.generate(
                    20, (int index) => cardBuilder("", widget.updatePage)),
              ))
            ],
          )),
    );
  }
}
