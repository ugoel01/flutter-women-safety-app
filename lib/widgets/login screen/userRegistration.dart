import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/login_screen.dart';
import 'package:flutter_women_safety_app/models/user_model.dart';
import 'package:flutter_women_safety_app/utils/constants.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/myButton.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/myTextField.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/secondButton.dart';

class UserRegistration extends StatefulWidget {
  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading=false;

  _onSubmit() async{
    _formKey.currentState!.save();
    if (_formData['password']!=_formData['rpassword']) {
      showDialogueBox(context, "Password and Retype Password must be same");
    }
    else{
    loadingWheel(context);
    try {
      setState(() {
        isLoading=true;
      });
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _formData['cemail'].toString(),
        password: _formData['password'].toString()
      );
      if(userCredential.user!=null){
        setState(() {
          isLoading=true;
        });
        final v=userCredential.user!.uid;
        DocumentReference<Map<String, dynamic>> db
          = FirebaseFirestore.instance.collection('users').doc(v);
        final user = UserModel(
            name: _formData['name'].toString(),
            phone: _formData['phone'].toString(),
            childEmail: _formData['cemail'].toString(),
            guardianEmail: _formData['gemail'].toString(),
            id: v,
            type: 'child',
          );
        final jsonData = user.toJson();
        await db.set(jsonData).whenComplete(() {
                Navigator.push(context, MaterialPageRoute(
                            builder:(context) => LoginScreen(),));
        setState(() {
          isLoading=false;
        });
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading=false;
      });
      if (e.code == 'weak-password') {
        showDialogueBox(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showDialogueBox(context, 'The account already exists for that email.');
      }
    } catch (e) {
      setState(() {
        isLoading=false;
      });
      showDialogueBox(context, e.toString());
    }
     
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            isLoading ? loadingWheel(context)
            : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Text("CHILD REGISTRATION",style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 66, 14, 71),
                        ),
                      ),
                    ),
                    Image.asset('assets/logo.png',
                    height: 200,
                    width: 150,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          MyTextField(
                            hintText:"Enter name",
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.name,
                            prefix: Icon(Icons.person),
                            onsave: (name) {
                              _formData['name'] = name ?? "";
                            },
                            validate: (name) {
                              if (name!.isEmpty ||
                                name.length < 3 ) {
                                return 'enter correct name';
                              }
                              return null;
                              },
                          ),
                          MyTextField(
                            hintText:"Enter mobile No",
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.phone,
                            prefix: Icon(Icons.phone),
                            onsave: (phone) {
                              _formData['phone'] = phone ?? "";
                            },
                            validate: (phone) {
                              if (phone!.isEmpty ||
                                phone.length < 10 ) {
                                return 'enter correct mobile No';
                                }
                              return null;
                            },
                          ),
                          MyTextField(
                            hintText:"Enter email",
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.emailAddress,
                            prefix: Icon(Icons.email),
                            onsave: (email) {
                              _formData['cemail'] = email ?? "";
                            },
                            validate: (email) {
                              if (email!.isEmpty ||
                                email.length < 3 ||
                                !email.contains("@")) {
                                return 'enter correct email';
                                }
                              return null;
                              },
                          ),
                          MyTextField(
                            hintText:"Enter guardian email",
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.emailAddress,
                            prefix: Icon(Icons.email),
                            onsave: (gemail) {
                              _formData['gemail'] = gemail ?? "";
                            },
                            validate: (gemail) {
                              if (gemail!.isEmpty ||
                                gemail.length < 3 ||
                                !gemail.contains("@")) {
                                return 'enter correct guardian email';
                                }
                              return null;
                              },
                          ),
                          MyTextField(
                            hintText:"Enter password",
                            isPassword: isPasswordShown,
                            prefix: Icon(Icons.vpn_key_rounded),
                            validate: (password) {
                              if (password!.isEmpty ||
                                password.length < 7) {
                                return 'enter correct password';
                                }
                                return null;
                            },
                            onsave: (password) {
                              _formData['password'] = password ?? "";
                            },
                            suffix: IconButton(onPressed: () {
                              setState(() {
                                isPasswordShown = !isPasswordShown;
                              });
                            },
                            icon: isPasswordShown
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off)),
                          ),
                          MyTextField(
                            hintText:"ReEnter password",
                            prefix: Icon(Icons.vpn_key_rounded),
                            validate: (password) {
                              if (password!.isEmpty ||
                                password.length < 7) {
                                return 'enter correct password';
                                }
                                return null;
                            },
                            onsave: (password) {
                              _formData['rpassword'] = password ?? "";
                            },
                          ),
                          MyButton(
                            title: "Register",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _onSubmit();
                              }
                            },
                          ),
                          SecondButton(
                            title: "SignIn",
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder:(context) => LoginScreen(),)
                              );
                      }
                    )
                        ]
                      ))
                    ],
                  ))
                  ),
          ],
        )));
  }
}