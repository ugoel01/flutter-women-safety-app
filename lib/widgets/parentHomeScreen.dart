import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/login_screen.dart';
import 'package:flutter_women_safety_app/utils/constants.dart';
import 'package:flutter_women_safety_app/widgets/bottom%20screens/chatWindow.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/myButton.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 66, 14, 71),
        title: Text('My Children'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('type', isEqualTo: 'child')
                  .where('guardiantEmail',
                      isEqualTo: FirebaseAuth.instance.currentUser!.email)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: loadingWheel(context));
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final d = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 236, 209, 239),
                          borderRadius: BorderRadius.circular(10.0), // Adjust as desired
                        ),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              d['name'],
                              style: TextStyle(
                                color: Color.fromARGB(255, 66, 14, 71),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatWindow(
                                    currentUserId: FirebaseAuth.instance.currentUser!.uid,
                                    friendId: d.id,
                                    friendName: d['name'],
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.chevron_right_outlined,
                              size: 40,
                              color: Color.fromARGB(255, 66, 14, 71),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Spacer(), // Add Spacer to push content up
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: MyButton(
                title: "Sign out",
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
            ),
          ],
        ),
      ),
    );
  }
}
