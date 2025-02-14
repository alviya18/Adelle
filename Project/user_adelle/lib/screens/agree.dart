import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/screens/trackingReason.dart';

class Agree extends StatefulWidget {
  const Agree({super.key});

  @override
  State<Agree> createState() => _AgreeState();
}

class _AgreeState extends State<Agree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // SizedBox(
                  //   height: 80,
                  // ),
                  SizedBox(
                    child: Image(
                      image: AssetImage("assets/user1.png"),
                      height: 400,
                    ),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Text(
                    '''To help us set up your account, could you please take a moment to answer a few questions? 

Your responses will allow us to personalize your experience.''',
                    style: GoogleFonts.sortsMillGoudy().copyWith(
                      color: const Color.fromARGB(255, 7, 7, 7),
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 250,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Trackingreason()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDC010E),
                      overlayColor: Color.fromARGB(255, 8, 8, 8),
                      shadowColor: Color(0xFFDC010E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      "GET STARTED ",
                      style: GoogleFonts.sortsMillGoudy().copyWith(
                        color: const Color.fromARGB(221, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ])));
  }
}
