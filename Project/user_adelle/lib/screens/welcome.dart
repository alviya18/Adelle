import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/screens/login.dart';
import 'package:user_adelle/screens/registration.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              child: Image(
                image: AssetImage("assets/rmbglogo.png"),
                // width: 150,
                height: 180,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.all(16.0), // Adjust the padding value as needed
              child: Text(
                '''Hi there, lovely soul! 🌷

I’m so excited you’ve chosen to join me on this journey! Tracking your cycle can be empowering, comforting, and even a little fun, and I’m here to make sure it’s an easy and enjoyable experience for you.

With Adelle, you’ll get personalized insights to help you better understand your body’s rhythm, stay on top of your health, and feel confident every day of the month. Whether you’re tracking periods, moods, symptoms, or fertility, I’ve got you covered!

Take a deep breath, relax, and feel supported as you start this new chapter. I’m here for you every step of the way. 🌙

I can’t wait to help you glow, thrive, and feel your best. 💖

Thank you for trusting me with your journey. 
          ''',
                style: GoogleFonts.sortsMillGoudy().copyWith(
                  color: const Color.fromARGB(255, 7, 7, 7),
                  fontSize: 13,
                  //   fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Registration()));
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
                      "CREATE AN ACCOUNT",
                      style: GoogleFonts.sortsMillGoudy().copyWith(
                        color: const Color.fromARGB(221, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
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
                      "ALREADY HAVE AN ACCOUNT",
                      style: GoogleFonts.sortsMillGoudy().copyWith(
                        color: const Color(0xFFDC010E),
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
