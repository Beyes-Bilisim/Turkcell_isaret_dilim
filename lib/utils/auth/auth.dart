import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> userCheck() async {
    if (_auth.currentUser == null) {
      print("kullanıcı yok");
      return false;
    } else {
      print("kullanıcı var");
      return true;
    }
  }
}
