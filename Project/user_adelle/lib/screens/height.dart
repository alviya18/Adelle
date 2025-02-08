import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/screens/periodDuration.dart';

class Height extends StatefulWidget {
  const Height({super.key});

  @override
  State<Height> createState() => _HeightState();
}

class _HeightState extends State<Height> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(50)),
                    color: const Color(0xFFDC010E),
                    image: DecorationImage(
                        image: AssetImage("assets/userlogin4.webp"),
                        fit: BoxFit.cover)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 220,
                ),
                Text("Provide your height in cm.",
                    style: GoogleFonts.sortsMillGoudy().copyWith(
                      color: Color(0xFFDC010E),
                      fontSize: 24,
                    )),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Periodduration()));
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
                    "NEXT",
                    style: GoogleFonts.sortsMillGoudy().copyWith(
                      color: const Color.fromARGB(221, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
