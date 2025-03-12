import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';
import 'package:user_adelle/screens/bmi.dart';
import 'package:user_adelle/screens/complaint.dart';

import 'package:user_adelle/screens/cycle.dart';
import 'package:user_adelle/screens/editheight.dart';
import 'package:user_adelle/screens/editpassword.dart';
import 'package:user_adelle/screens/editweight.dart';
import 'package:user_adelle/screens/feeback.dart';
import 'package:user_adelle/screens/goal.dart';
import 'package:user_adelle/screens/login.dart';
import 'package:user_adelle/screens/notification.dart';
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
                    Text('Year of Birth', style: GoogleFonts.sortsMillGoudy())),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditHeight(),
                      ));
                },
                title: Text('Height', style: GoogleFonts.sortsMillGoudy())),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditWeight(),
                      ));
                },
                title: Text('Weight', style: GoogleFonts.sortsMillGoudy())),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Bmi(),
                      ));
                },
                title: Text('Body Mass Index',
                    style: GoogleFonts.sortsMillGoudy())),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationSetting(),
                      ));
                },
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
              title: Text('Complaint', style: GoogleFonts.sortsMillGoudy()),
            ),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Feedbacks(),
                      ));
                },
                title: Text('Feedback', style: GoogleFonts.sortsMillGoudy())),
            // ListTile(
            //     title: Text('Delete Account',
            //         style: GoogleFonts.sortsMillGoudy())),
            ListTile(
              onTap: () {
                logout();
              },
              title: Text('Logout', style: GoogleFonts.sortsMillGoudy()),
            ),
          ]),
        ),
      ),
    );
  }
}
