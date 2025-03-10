import 'package:flutter/material.dart';
import 'package:user_adelle/screens/cycle.dart';
import 'package:user_adelle/screens/editpassword.dart';
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
      ),
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
                title: Text('Change Password')),

            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Goal(),
                      ));
                },
                title: Text('Goal')),

            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Cycle(),
                      ));
                },
                title: Text('Cycle')),

            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Yob(),
                      ));
                },
                title: Text('Year of birth')),

            ListTile(title: Text('Notification Settings')),
            ListTile(
              title: Text('Complaints'),
            ),
            ListTile(title: Text('Feedbacks')),
            ListTile(title: Text('Delete Account')),
            ListTile(title: Text('Logout')),

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
