import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_manager/utils/texts/Texts.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 70,
          centerTitle: true,
          title: Text(Texts.reset_password_page_title),
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
                    child: Column(
                      children: [
                        TextFormField(
                          onSaved: (newValue) {
                            setState(() {
                              _email = newValue!;
                            });
                          },
                          autofocus: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return Texts.required_to_be_filled;
                            } else {
                              if (EmailValidator.validate(value) != true) {
                                return Texts.enter_a_valid_email;
                              } else {
                                return null;
                              }
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              errorStyle: TextStyle(fontSize: 15),
                              labelText: Texts.email_label_text,
                              labelStyle: TextStyle(fontSize: 20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.purple))),
                        ),
                        SizedBox(height: 40),
                        Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 150,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ElevatedButton(
                              child: Text(Texts.reset_password_button_text,
                                  style: TextStyle(fontSize: 20)),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ))),
                              onPressed: resetPassword,
                            )),
                      ],
                    ))
              ],
            ))));
  }

  void resetPassword() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        await _auth.sendPasswordResetEmail(email: _email);
        final snackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: Text(Texts.check_your_email),
          backgroundColor: (Colors.black45),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
      } catch (e) {
        final snackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: Text(Texts.no_users),
          backgroundColor: (Colors.black45),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
