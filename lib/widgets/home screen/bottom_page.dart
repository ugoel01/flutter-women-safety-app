import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/home_screen.dart';
import 'package:flutter_women_safety_app/widgets/bottom%20screens/add_contacts.dart';
import 'package:flutter_women_safety_app/widgets/bottom%20screens/chatScreen.dart';
import 'package:flutter_women_safety_app/widgets/bottom%20screens/profileScreen.dart';
import 'package:flutter_women_safety_app/widgets/bottom%20screens/reviewScreen.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int currentIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    AddContacts(),
    ChatScreen(),
    ReviewScreen(),
    ProfileScreen()
  ];
  onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: currentIndex,
      length: pages.length,
      child: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.grey[200],
          unselectedItemColor: Colors.grey,
          backgroundColor: Color.fromARGB(255, 66, 14, 71),
          onTap: onTapped,
          items: [
          BottomNavigationBarItem(label:'Home',icon: Icon(Icons.home)),
          BottomNavigationBarItem(label:'Contacts',icon: Icon(Icons.contacts)),
          BottomNavigationBarItem(label:'Chats',icon: Icon(Icons.chat)),
          BottomNavigationBarItem(label:'Reviews',icon: Icon(Icons.reviews)),
          BottomNavigationBarItem(label:'Profile',icon: Icon(Icons.person)),
        ]),
      ),
    );
  }
}