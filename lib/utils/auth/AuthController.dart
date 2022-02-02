import 'package:flutter/material.dart';
import 'package:movie_manager/main.dart';
import 'package:movie_manager/pages/Login.dart';
import 'package:movie_manager/utils/auth/auth.dart';

class AuthController extends StatefulWidget {
  const AuthController({Key? key}) : super(key: key);

  @override
  _AuthControllerState createState() => _AuthControllerState();
}

class _AuthControllerState extends State<AuthController> {
  AuthService _service = AuthService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _service.userCheck(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data as bool;
          if (data) {
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                  (r) => false);
            });
          } else {
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                  (r) => false);
            });
          }
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
