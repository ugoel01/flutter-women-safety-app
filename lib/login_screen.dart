import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/db/share_pref.dart';
import 'package:flutter_women_safety_app/utils/constants.dart';
import 'package:flutter_women_safety_app/widgets/home%20screen/bottom_page.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/forgotPassword.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/myButton.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/myTextField.dart';
import 'package:flutter_women_safety_app/widgets/parentHomeScreen.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/parentRegistration.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/secondButton.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/userRegistration.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading=false;

  @override
  void initState() {
    super.initState();
  }

  _onSubmit() async{
    _formKey.currentState!.save();
    try {
      if(mounted){
        setState(() {
          isLoading=true;
        });
      }
        UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _formData['email'].toString(),
          password: _formData['password'].toString());
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          if (userCredential.user!=null){
            FirebaseFirestore.instance.collection('users')..doc(userCredential.user!.uid).get().then((value) {
            if(mounted){
              if (value['type']=='parent') {
                MySharedPrefference.saveUserType('parent');
                Navigator.push(context, MaterialPageRoute(
                            builder:(context) => ParentHomeScreen(),));
              }else{
                MySharedPrefference.saveUserType('child');
                Navigator.push(context, MaterialPageRoute(
                            builder:(context) => BottomPage(),));
              }
            }
            });
          }
        } on FirebaseAuthException catch(e){
          if(mounted){
            setState(() {
              isLoading=false;
            });
          }
          if(e.code == 'user-not-found'){
            Fluttertoast.showToast(msg: "No User Found for this Email");
          } else if(e.code == 'wrong-password'){
              Fluttertoast.showToast(msg: "Try again with correct details");
          }
        } 
    catch (e) {
      
    }
    print(_formData['email']);
    print(_formData['password']);
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
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text("USER LOGIN",style: TextStyle(
                        fontSize: 35,
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
                            hintText:"Enter email",
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.emailAddress,
                            prefix: Icon(Icons.person),
                            onsave: (email) {
                              _formData['email'] = email ?? "";
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
                            hintText:"Enter password",
                            isPassword: isPasswordShown,
                            prefix: Icon(Icons.lock),
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
                          MyButton(
                            title: "Login",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _onSubmit();
                              }
                              loadingWheel(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Forgot Password?",
                              style: TextStyle(fontSize: 18),
                            ),
                            SecondButton(
                              title: 'click here', onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder:(context) => ForgotPassword(),));
                              }),
                          ],
                        ),
                    ),
                    SecondButton(
                      title: "SignUp as Child",
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder:(context) => UserRegistration(),));
                      }
                    ),
                    SecondButton(
                      title: "SignUp as Parent",
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder:(context) => ParentRegistration(),));
                      }
                    )
                  ],
                ),
              ),
            ),
          ],
        )),
    );
  }
}