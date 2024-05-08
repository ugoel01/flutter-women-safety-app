import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/utils/constants.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/myTextField.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  TextEditingController locationC = TextEditingController();
  TextEditingController viewsC = TextEditingController();
  bool isSaving = false;

  showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return SingleChildScrollView(
            child: AlertDialog(
              contentPadding: EdgeInsets.all(2.0),
              title: Text("Add a review"),
              content: Form(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTextField(
                      hintText: 'enter location',
                      controller: locationC,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTextField(
                      controller: viewsC,
                      hintText: 'enter review',
                      maxLines: 3,
                    ),
                  ),
                ],
              )),
              actions: [
                TextButton(
                    child: Text("Save"),
                    onPressed: () {
                      saveReview();
                      Navigator.pop(context);
                    }),
                TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }
  saveReview() async {
    setState(() {
      isSaving = true;
    });
    await FirebaseFirestore.instance.collection('reviews').add({
      'location': locationC.text,
      'views': viewsC.text,
    }).then((value) {
      setState(() {
        isSaving = false;
        Fluttertoast.showToast(msg: 'review uploaded successfully');
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 66, 14, 71),
        title: Text('Reviews'),
      ),
      body: isSaving == true
          ? Center(child: loadingWheel(context))
          : Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SafeArea(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('reviews')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: loadingWheel(context));
                    }
                              
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return Padding(padding: const EdgeInsets.only(top: 10.0));
                      },
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final data = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                            color: Color.fromARGB(255, 236, 209, 239),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Location : ${data['location']}",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  Text(
                                    "Comments : ${data['views']}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 66, 14, 71),
        foregroundColor: Colors.grey[200],
        onPressed: () {
          showAlert(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}