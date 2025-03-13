import 'package:admin_adelle/main.dart';
import 'package:admin_adelle/screens/complaints.dart';
import 'package:admin_adelle/screens/dashboard.dart';
import 'package:admin_adelle/screens/feedback.dart';
import 'package:admin_adelle/screens/login.dart';
import 'package:admin_adelle/screens/managebc.dart';
import 'package:admin_adelle/screens/managechatbot.dart';
import 'package:admin_adelle/screens/manageemotion.dart';
import 'package:admin_adelle/screens/managegd.dart';
import 'package:admin_adelle/screens/managesymptom.dart';
import 'package:admin_adelle/screens/managetrackingreason.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;

  List<String> pageName = [
    'Dashboard',
    'Tracking Reason',
    'Birth Control',
    'Gynacological Disease',
    'Symtoms',
    'Moods',
    'Chat Bot',
    'Complaints',
    'Feedback'
  ];

  List<IconData> pageIcon = [
    Icons.widgets,
    Icons.track_changes,
    Icons.medical_services_outlined,
    Icons.health_and_safety,
    Icons.woman_2_rounded,
    Icons.emoji_emotions_outlined,
    Icons.wechat_rounded,
    Icons.headset_mic_rounded,
    Icons.feedback_outlined,
  ];

  List<Widget> pages = [
    Dashboard(),
    TrackingReason(),
    BirthControl(),
    GD(),
    Symptoms(),
    Emotion(),
    ChatBot(),
    Complaints(),
    Feedbacks()
  ];
  Future<void> logout() async {
    await supabase.auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Welcome Admin!",
            style: GoogleFonts.quicksand().copyWith(
              color: Color.fromARGB(255, 255, 255, 255),
            )),
        backgroundColor: const Color.fromARGB(255, 3, 3, 3),
        actions: [
          IconButton(
            icon: Icon(Icons.logout,
                color: Colors.white), // Change icon as needed
            onPressed: () {
              logout();

              // Add your logout function or any action
              print("Logout button pressed");
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/adbg6.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView.builder(
                itemCount: pageName.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? const Color.fromARGB(189, 106, 213, 248)
                              : null),
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            pageIcon[index],
                            color: selectedIndex == index
                                ? const Color.fromARGB(255, 255, 254, 254)
                                : Colors.white,
                            size: 26,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            pageName[index],
                            style: GoogleFonts.quicksand().copyWith(
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.blueGrey,
                ),
                // color: const Color.fromARGB(255, 255, 255, 255),
                child: pages[selectedIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
