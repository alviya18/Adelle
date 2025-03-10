import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/screens/complaint.dart';

import 'package:user_adelle/screens/cycle.dart';
import 'package:user_adelle/screens/editpassword.dart';
import 'package:user_adelle/screens/feeback.dart';
import 'package:user_adelle/screens/goal.dart';
import 'package:user_adelle/screens/yearofbirth.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int selectedIndex = -1;

  List<String> pageName = [
    'Edit Profile',
    'Goal',
    'Cycle',
    'Year of birth',
    'Notification Settings',
    'Complaint',
    'Feedback',
    'Delete Account',
    'Logout',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Color(0xFFDC010E),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_rounded),
            color: Colors.white,
          ),
          title: Text("Account",
              style:
                  GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white))),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(children: [
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePassword(),
                      ));
                },
                title: Text('Change Password',
                    style: GoogleFonts.sortsMillGoudy())),

            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Goal(),
                      ));
                },
                title: Text('Goal', style: GoogleFonts.sortsMillGoudy())),

            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Cycle(),
                      ));
                },
                title: Text('Cycle', style: GoogleFonts.sortsMillGoudy())),

            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Yob(),
                      ));
                },
                title:
                    Text('Year of birth', style: GoogleFonts.sortsMillGoudy())),

            ListTile(
                title: Text('Notification Settings',
                    style: GoogleFonts.sortsMillGoudy())),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Complaint(),
                    ));
              },
              title: Text('Complaints', style: GoogleFonts.sortsMillGoudy()),
            ),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Feedbacks(),
                      ));
                },
                title: Text('Feedbacks', style: GoogleFonts.sortsMillGoudy())),
            ListTile(
                title: Text('Delete Account',
                    style: GoogleFonts.sortsMillGoudy())),
            ListTile(
              title: Text('Logout', style: GoogleFonts.sortsMillGoudy()),
            ),

            // style: TextStyle(
            //   fontSize: 16,
            //   color: selectedIndex == index
            //       ? const Color(0xFFDC010E)
            //       : Colors.black,
          ]),
        ),
      ),
    );
  }
}
