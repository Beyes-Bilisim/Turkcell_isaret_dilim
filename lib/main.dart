import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WelcomeScreen()
  ));
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: MyApp(),
      title:  Text(
        'Welcome',
        style:  TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
      ),
      backgroundColor: Colors.white,
      loaderColor: Colors.red,
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('data')
        ),
        body: Container(
          child: Column(

            children: [
              Text("data")
            ],
          ),
        ),
      ),
    );
  }
}