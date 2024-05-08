import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_women_safety_app/db/db_services.dart';
import 'package:flutter_women_safety_app/models/contactsm.dart';
import 'package:flutter_women_safety_app/widgets/bottom%20screens/contactsScreen.dart';
import 'package:flutter_women_safety_app/widgets/login%20screen/myButton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';

class AddContacts extends StatefulWidget {
  const AddContacts({super.key});

  @override
  State<AddContacts> createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  DatabaseHelper databaseHelper=DatabaseHelper();
  List<TContact>? contactList;
  int count=0;

  void showList() {
    Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TContact>> contactListFuture =
          databaseHelper.getContactList();
      contactListFuture.then((value) {
        setState(() {
          this.contactList = value;
          this.count = value.length;
        });
      });
    });
  }

  void deleteContact(TContact contact) async {
  // Show confirmation dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete ${contact.name} ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog without deleting
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              int result = await databaseHelper.deleteContact(contact.id);
              Navigator.of(context).pop(); // Close dialog after delete
              if (result != 0) {
                Fluttertoast.showToast(msg: "Contact removed successfully");
                showList(); // Update your contact list UI
              }
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showList();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (contactList == null) {
      contactList = [];
    }
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 66, 14, 71),
        title: Text('My Emergency Contacts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: count,
                  itemBuilder:(BuildContext context,int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Card(
                        color: Color.fromARGB(255, 236, 209, 239),
                        child: ListTile(
                          title: Text(contactList![index].name,
                            style: TextStyle(color: Color.fromARGB(255, 66, 14, 71),
                                            fontWeight: FontWeight.bold),),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(onPressed: ()async{await FlutterPhoneDirectCaller.callNumber(contactList![index].number);},
                                 icon: Icon(Icons.call,color: Color.fromARGB(255, 66, 14, 71),)),
                                IconButton(onPressed: (){deleteContact(contactList![index]);},
                                 icon: Icon(Icons.delete,color: Color.fromARGB(255, 66, 14, 71),)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } ,
                ),
              ),
              MyButton(
                title: "Add contacts",
                onPressed: ()async {
                  bool result= await Navigator.push(context, MaterialPageRoute(
                      builder:(context) => ContactsScreen(),));
                  if(result==true){
                    showList();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}