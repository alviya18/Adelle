import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/screens/complaintreg.dart';
import 'package:user_adelle/screens/complaintreplies.dart';
import 'package:user_adelle/screens/mycomplaint.dart';

class Complaint extends StatefulWidget {
  const Complaint({super.key});

  @override
  State<Complaint> createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
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
          title: Text("Complaint",
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
                    builder: (context) => RegisterComplaint(),
                  ));
            },
          ),
          ListTile(
            title: Text("My Complaints", style: GoogleFonts.sortsMillGoudy()),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Mycomplaint(),
                  ));
            },
          ),
          ListTile(
            title:
                Text("Complaint Replies", style: GoogleFonts.sortsMillGoudy()),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComplaintReplies(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
