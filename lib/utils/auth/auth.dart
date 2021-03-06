import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> userCheck() async {
    if (_auth.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }
}
