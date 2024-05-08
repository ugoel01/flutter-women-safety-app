//import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_women_safety_app/login_screen.dart';
import 'package:flutter_women_safety_app/utils/constants.dart';
import 'package:flutter_women_safety_app/widgets/home%20screen/bottom_page.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/myButton.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/myTextField.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/secondButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
//import 'package:flutter_women_safety_app/login_screen.dart';
//import 'package:flutter_women_safety_app/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameC = TextEditingController();

  final key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  String? downloadUrl;
  bool isSaving = false;
  getDate() async {
    await await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
          setState(() {
            nameC.text = value.docs.first['name'];
            id = value.docs.first.id;
            profilePic = value.docs.first['profilePic'];
          });
        });
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 66, 14, 71),
              title: Text('Update Profile'),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                      } on FirebaseAuthException catch (e) {
                          showDialogueBox(context, e.toString());
                      }
                  },
                ),
              ],
            ),
            body: isSaving == true
                ? Center(
                    child: loadingWheel(context))
            : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Form(child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final XFile? pickImage = await ImagePicker()
                                        .pickImage(
                                            source: ImageSource.gallery,
                                            imageQuality: 50);
                                    if (pickImage != null) {
                                      setState(() {
                                        profilePic = pickImage.path;
                                      });
                                    }
                        },
                        child: Container(
                          child: profilePic == null ?
                          CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 66, 14, 71),
                            radius: 80,
                            child: Center(
                              child: Image.asset(
                                'assets/add_pic.png',
                                height: 80,
                                width: 80,
                              )),
                          )
                          : profilePic!.contains('http')
                              ? CircleAvatar(
                                  backgroundColor: Color.fromARGB(255, 66, 14, 71),
                                  radius: 80,
                                  backgroundImage: NetworkImage(profilePic!),
                                )
                              : CircleAvatar(
                                  backgroundColor: Color.fromARGB(255, 66, 14, 71),
                                  radius: 80,
                                  backgroundImage: FileImage(File(profilePic!))),
                        ),
                      ),
                      MyTextField(
                        controller: nameC,
                        hintText: nameC.text,
                        validate: (v) {
                                    if (v!.isEmpty) {
                                      return 'please enter your updated name';
                                    }
                                    return null;
                                  },
                      ),
                      SizedBox(height: 25),
                      MyButton(title: "Update", onPressed: () async {
                        
                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                          if (profilePic == null) {
                            Fluttertoast.showToast(msg: 'please select profile picture');
                          } else {
                            await update(); // Wait for update to finish
                            Fluttertoast.showToast(msg: "Profile updated successfully!"); // Or show another success message
                            // Optionally navigate to another screen here
                          }
                        
                      })
                    ],
                  ))
                ),
              ),
            )
          );
        } else {
          return Center(
            child: SecondButton(title: "Sign IN", onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                            builder:(context) => LoginScreen(),));
            })
          );
        }
      });
     
  }
  Future<String?> uploadImage(String filePath) async {
    try {
      final filenName = Uuid().v4();
      final Reference fbStorage =
          FirebaseStorage.instance.ref('profile').child(filenName);
      final UploadTask uploadTask = fbStorage.putFile(File(filePath));
      await uploadTask.then((p0) async {
        downloadUrl = await fbStorage.getDownloadURL();
      });
      return downloadUrl;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return null;
  }

  update() async {
    setState(() {
      isSaving = true;
    });
    uploadImage(profilePic!).then((value) {
      Map<String, dynamic> data = {
        'name': nameC.text,
        'profilePic': downloadUrl,
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);
      setState(() {
        isSaving = false;
        Navigator.push(context, MaterialPageRoute(
                            builder:(context) => BottomPage(),));
      });
    });
  }
}