import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/screens/feedbackreg.dart';
import 'package:user_adelle/screens/myfeedbacks.dart';

class Feedbacks extends StatefulWidget {
  const Feedbacks({super.key});

  @override
  State<Feedbacks> createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Color(0xFFDC010E),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close_sharp),
            color: Colors.white,
          ),
          title: Text("Feedback",
              style:
                  GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white))),
      body: ListView(
        children: [
          ListTile(
            title: Text("Register a Complaint",
                style: GoogleFonts.sortsMillGoudy()),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterFeedback(),
                  ));
            },
          ),
          ListTile(
            title: Text("My Feedbacks", style: GoogleFonts.sortsMillGoudy()),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyFeedbacks(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
