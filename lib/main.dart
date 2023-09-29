import 'package:flutter/material.dart';
import 'SearchPage/search_page.dart';
import "firebase/firebase_options.dart";
import "package:firebase_core/firebase_core.dart";
import "upload_file_page.dart";
import "settings_page.dart";
import "package:yugi_dex/DuelPage/duel_page.dart";
import "package:yugi_dex/NewsPage/news_page.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const YugidexRoot());
}

class YugidexRoot extends StatelessWidget {
  const YugidexRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarWidget(),
    );
  }
}

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarState();
}

// TODO: Instead of using integer index to store and switch pages, use a map to direct to the page object
class _BottomNavigationBarState extends State<BottomNavigationBarWidget> {
  int _selectedBottomIndex = 0;
  int _selectedPageIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  late final List<Widget> _widgetOptions = <Widget>[
    const SearchBarApp(),
    const NewsPage(),
    const UploadFilePage(),
    const DuelPage(),
    SettingsPage(),
  ];

  void changePage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedBottomIndex = index;
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedPageIndex),
      ),
      appBar: AppBar(
        title: const Text('Yugidex'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
            backgroundColor: Colors.yellow,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style),
            label: 'Decks',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science),
            label: 'Duel',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedBottomIndex,
        selectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}
