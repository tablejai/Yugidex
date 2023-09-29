import 'package:flutter/material.dart';
import 'dart:developer';
import 'card_list.dart';

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

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
              Flexible(child: CardList())
            ],
          )),
    );
  }
}
