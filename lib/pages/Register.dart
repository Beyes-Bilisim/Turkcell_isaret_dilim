import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_validator/the_validator.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String _email;
  late String _sifre;
  late String _sifreConfirm;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 70,
          centerTitle: true,
          title: Text("Register"),
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
                child: Column(
              children: [
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
                        errorMessage:
                            "Minimum 8 Karakter uzunluğunda Olmalıdır!",
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
                    TextFormField(
                      onSaved: (value) {
                        _sifreConfirm = value!;
                      },
                      obscureText: true,
                      validator: FieldValidator.password(
                        minLength: 8,
                        shouldContainNumber: true,
                        errorMessage:
                            "Minimum 8 Karakter uzunluğunda Olmalıdır!",
                        onNumberNotPresent: () {
                          return "Rakam İçermelidir!";
                        },
                      ),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          errorStyle: TextStyle(fontSize: 15),
                          labelText: "Password confirm",
                          labelStyle: TextStyle(fontSize: 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.purple))),
                    ),
                    SizedBox(height: 20),
                    Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 150,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          child:
                              Text('Register!', style: TextStyle(fontSize: 20)),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ))),
                          onPressed: register,
                        )),
                  ]),
                ),
              ],
            ))));
  }

  void register() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (_sifre != _sifreConfirm) {
        final snackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: const Text('Şifreler Uyuşmuyor'),
          backgroundColor: (Colors.black45),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        var _firebaseUser = await _auth
            .createUserWithEmailAndPassword(email: _email, password: _sifre)
            .catchError((onError) => null);
        if (_firebaseUser != null) {
          final snackBar = SnackBar(
            duration: Duration(seconds: 3),
            content: const Text('Kayıt Oldunuz Lütfen E-postanızı Doğrulayın'),
            backgroundColor: (Colors.black45),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          formKey.currentState!.reset();
          _firebaseUser.user!.sendEmailVerification()
          .then((value)=>null)
          .catchError((onError) => null);
        }else{
          final snackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: const Text('Kayıtlı bir E-posta adresi ile girdiniz'),
          backgroundColor: (Colors.black45),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
  }
}
