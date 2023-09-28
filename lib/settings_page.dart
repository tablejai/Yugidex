import "package:flutter/material.dart";
import "package:section_view/section_view.dart";

class SettingsItem {
  SettingsItem({required this.settingsName, required this.callback});

  late void Function() callback;
  final String settingsName;
}

class SettingsSection {
  SettingsSection({required this.sectionName, required this.settingItems});

  String sectionName;
  List<SettingsItem> settingItems;
}

class SettingsPage extends StatefulWidget {
  // final Card cardToDisplay;
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void parseCardDetails() {}

  void changeLanguage() {}

  void contactUsPopUp() {}

  void faqPopUp() {}

  late List<SettingsSection> settingsSection = [
    SettingsSection(sectionName: "Language Settings", settingItems: [
      SettingsItem(settingsName: "Card Language", callback: changeLanguage),
      SettingsItem(settingsName: "Search Language", callback: changeLanguage),
    ]),
    SettingsSection(sectionName: "Help", settingItems: [
      SettingsItem(settingsName: "Contact us", callback: contactUsPopUp),
      SettingsItem(settingsName: "FAQ", callback: faqPopUp),
    ])
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData =
        ThemeData(useMaterial3: true, brightness: Brightness.light);
    return MaterialApp(
        theme: themeData,
        home: Scaffold(
            body: Column(children: [
          Expanded(
            flex: 1,
            child: SectionView<SettingsSection, SettingsItem>(
                source: settingsSection,
                onFetchListData: (header) => header.settingItems,
                headerBuilder: getDefaultHeaderBuilder((d) => d.sectionName,
                    bkColor: Colors.green,
                    style: const TextStyle(fontSize: 18, color: Colors.white)),
                itemBuilder:
                    (context, itemData, itemIndex, headerData, headerIndex) =>
                        ListTile(
                            title: Text(itemData.settingsName),
                            onTap: itemData.callback)),
          )
        ])));
  }
}
