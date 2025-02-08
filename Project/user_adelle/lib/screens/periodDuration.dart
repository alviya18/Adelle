import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/screens/AverageCycle.dart';

class Periodduration extends StatefulWidget {
  const Periodduration({super.key});

  @override
  State<Periodduration> createState() => _PerioddurationState();
}

class _PerioddurationState extends State<Periodduration> {
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
                Text("How long does your periods normaly last?",
                    style: GoogleFonts.sortsMillGoudy().copyWith(
                      color: Color(0xFFDC010E),
                      fontSize: 24,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Averagecycle()));
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: const Color(0xFFDC010E),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        "SKIP",
                        style: GoogleFonts.sortsMillGoudy().copyWith(
                          color: const Color(0xFFDC010E),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Averagecycle()));
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
