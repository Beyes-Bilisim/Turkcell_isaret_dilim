import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_manager/main.dart';
import 'package:movie_manager/pages/Register.dart';
import 'package:movie_manager/pages/ResetPassword.dart';
import 'package:the_validator/the_validator.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String _email;
  late String _sifre;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 70,
          centerTitle: true,
          title: Text("Login"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
                gradient: LinearGradient(
                    colors: [Colors.blue, Colors.cyan],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter)),
          ),
        ),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(children: [
              Form(
                key: formKey,
                child: Column(children: [
                  TextFormField(
                    onSaved: (newValue) {
                      setState(() {
                        _email = newValue!;
                      });
                    },
                    autofocus: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Doldurulması Zorunludur";
                      } else {
                        if (EmailValidator.validate(value) != true) {
                          return "Geçerli Bir E-posta giriniz";
                        } else {
                          return null;
                        }
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        errorStyle: TextStyle(fontSize: 15),
                        labelText: "Email",
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(width: 1, color: Colors.purple))),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    onSaved: (value) {
                      _sifre = value!;
                    },
                    obscureText: true,
                    validator: FieldValidator.password(
                      minLength: 8,
                      shouldContainNumber: true,
                      errorMessage: "Minimum 8 Karakter uzunluğunda Olmalıdır!",
                      onNumberNotPresent: () {
                        return "Rakam İçermelidir!";
                      },
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        errorStyle: TextStyle(fontSize: 15),
                        labelText: "Password",
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(width: 1, color: Colors.purple))),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          textColor: Colors.blue,
                          child: Text(
                            'Register',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register()));
                          },
                        ),
                        FlatButton(
                          textColor: Colors.blue,
                          child: Text(
                            'Reset Password',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPassword()));
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 150,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child:
                            Text('Giriş Yap', style: TextStyle(fontSize: 20)),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ))),
                        onPressed: login,
                      )),
                ]),
              ),
            ]))));
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        await _auth
            .signInWithEmailAndPassword(email: _email, password: _sifre)
            .then((user) {
          if (user.user!.emailVerified == false) {
            _auth.signOut();
            final snackBar = SnackBar(
              duration: Duration(seconds: 3),
              content: const Text('Lütfen E-postanızı doğrulayın'),
              backgroundColor: (Colors.black45),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                  (r) => false);
            });
            formKey.currentState!.reset();
          }
        });
      } catch (e) {
        final snackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: const Text('Yanlış Şifre'),
          backgroundColor: (Colors.black45),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
