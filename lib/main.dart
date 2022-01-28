import 'package:flutter/material.dart';
import 'package:movie_manager/pages/FavoritesPage.dart';
import 'package:movie_manager/pages/SearchPage.dart';
import 'package:movie_manager/pages/WatchListPage.dart';
import 'package:movie_manager/widgets/TabBar.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false, home: WelcomeScreen()));
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: MyApp(),
      title: Text(
        'Welcome',
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
      ),
      backgroundColor: Colors.white,
      loaderColor: Colors.red,
    );
  }
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
}
