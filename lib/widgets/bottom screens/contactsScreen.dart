import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/db/db_services.dart';
import 'package:flutter_women_safety_app/models/contactsm.dart';
import 'package:flutter_women_safety_app/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  TextEditingController searchController = TextEditingController();
  DatabaseHelper _databaseHelper = DatabaseHelper();

  void initState() {
    super.initState();
    askPermissions();
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  void filterContact() {
  List<Contact> _contacts = [];
  _contacts.addAll(contacts); // Create a copy of the original list

  if (searchController.text.isNotEmpty) {
    String searchTerm = searchController.text.toLowerCase().trim(); // Ensure trimmed search term

    _contacts.retainWhere((element) {
      String contactName = element.displayName?.toLowerCase() ?? ""; // Handle null display names gracefully
      String phoneNumber = "";

      // Check if phone numbers exist
      if (element.phones != null && element.phones!.isNotEmpty) {
        phoneNumber = element.phones!.first.value!.toLowerCase().replaceAll(RegExp(r'[^\d+]'), ''); // Extract first number, remove non-digits
      }

      // Search logic using toLowerCase() and contains()
      return contactName.contains(searchTerm) || phoneNumber.contains(searchTerm);
    });
  }

  setState(() {
    contactsFiltered = _contacts;
  });
}


  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermissions();
    if (permissionStatus == PermissionStatus.granted) {
       getAllContacts();
      searchController.addListener(() {
        filterContact();
      });
    } else {
      handInvaliedPermissions(permissionStatus);
    }
  }

  handInvaliedPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      showDialogueBox(context, "Access to the contacts denied by the user");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      showDialogueBox(context, "May contact does exist in this device");
    }
  }

  Future<PermissionStatus> getContactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  getAllContacts() async {
    List<Contact> _contacts =
        await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemExist = (contactsFiltered.length > 0 || contacts.length > 0);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 66, 14, 71),
        title: Text('Select Contacts'),
      ),
      body: contacts.length == 0 
      ? loadingWheel(context)
      : SafeArea(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                        autofocus: true,
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: "Search contact",
                          prefixIcon: Icon(Icons.search)),
              ),
            ),
            listItemExist==true
            ? Expanded(
              child: ListView.builder(
                itemCount: isSearching==true? contactsFiltered.length : contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = isSearching==true? contactsFiltered[index] : contacts[index];
                  return ListTile(
                    title: Text(contact.displayName ?? 'No Name'),
                    subtitle: contact.phones?.isNotEmpty == true
                            ? Text(contact.phones!.elementAt(0).value!)
                            : Text('No phone number available'),
                    leading: CircleAvatar(child: Icon(Icons.person,color: Color.fromARGB(255, 216, 201, 229),),
                                          backgroundColor: Color.fromARGB(255, 66, 14, 71),),
                    onTap: () {
                      if (contact.phones!.length > 0) {
                        final String phoneNum = contact.phones!.elementAt(0).value!;
                        final String name = contact.displayName!;
                        _addContact(TContact(phoneNum, name));
                      } else {
                        Fluttertoast.showToast(msg:"Oops! phone number of this contact doesn't exist");
                      }
                    },
                  );
                },
                   ),
            )
            : Container(child: Text("searching"),),
          ],
        ),
      ),
    );
  }
  void _addContact(TContact newContact) async {
  // Check if contact already exists using phoneNumber
  final existingContact = await _databaseHelper.getContactByPhoneNumber(newContact.number);

  if (existingContact == null) {
    int result = await _databaseHelper.insertContact(newContact);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact added successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contact");
    }
  } else {
    Fluttertoast.showToast(msg: "Contact already exists");
  }

  Navigator.of(context).pop(true); // Assuming you're using a dialog or form
}


}