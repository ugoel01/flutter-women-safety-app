import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/myButton.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/myTextField.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatelessWidget {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 66, 14, 71),
        title: Text('Forgot Password'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ 
          MyTextField(
            controller: emailController,
            hintText:"Enter email",
            keyboardtype: TextInputType.emailAddress,
            prefix: Icon(Icons.person),
            validate: (email) {
              if (email!.isEmpty || email.length < 3 || !email.contains("@")) {
                return 'enter correct email';
              }
              return null;
            },
          ),
          MyButton(
            title: "Reset Password",
            onPressed: () {
              auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
                Fluttertoast.showToast(msg: "Reset Password Email Sent");
              }).onError((error, stackTrace) {
                Fluttertoast.showToast(msg: error.toString());
              });
            },
          )
        ]
      ),
    );
  }
}