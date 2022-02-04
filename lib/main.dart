import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_manager/pages/FavoritesPage.dart';
import 'package:movie_manager/pages/SearchPage.dart';
import 'package:movie_manager/pages/WatchListPage.dart';
import 'package:movie_manager/utils/auth/AuthController.dart';
import 'package:movie_manager/widgets/TabBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AuthController());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  final pages = [SearchPage(), WatchListPage(), FavoritesPage()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      extendBodyBehindAppBar: true,
      bottomNavigationBar: TabBarWidget(
        index: index,
        onChangeTab: onChangeTab,
      ),
    );
  }

  void onChangeTab(int value) {
    setState(() {
      this.index = value;
    });
  }

  void init() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var favorites = sharedPreferences.getStringList("favorites") ?? null;
    var favorites_offline =
        sharedPreferences.getStringList("favorites_offline") ?? null;
    var list = sharedPreferences.getStringList("list") ?? null;
    var list_offline = sharedPreferences.getStringList("list_offline") ?? null;
    if (favorites == null) {
      sharedPreferences.setStringList("favorites", []);
    }
    if (list == null) {
      sharedPreferences.setStringList("list", []);
    }
    if (list_offline == null) {
      sharedPreferences.setStringList("list_offline", []);
    }
    if (favorites_offline == null) {
      sharedPreferences.setStringList("favorites_offline", []);
    }
  }
}
