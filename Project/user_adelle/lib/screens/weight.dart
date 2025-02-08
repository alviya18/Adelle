import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/screens/height.dart';

class Weight extends StatefulWidget {
  const Weight({super.key});

  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  int selectedYear = 2000; // Default year

  void _changeYear(int direction) {
    setState(() {
      selectedYear += direction;
    });
  }

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
                Text(
                    "For more personalized insights, kindly share your weight.",
                    style: GoogleFonts.sortsMillGoudy().copyWith(
                      color: Color(0xFFDC010E),
                      fontSize: 24,
                    )),
                GestureDetector(
                  // Detect swipe left or right
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {
                      // Swipe right: Increase year
                      _changeYear(1);
                    } else if (details.primaryVelocity! < 0) {
                      // Swipe left: Decrease year
                      _changeYear(-1);
                    }
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Left Arrow Button
                        IconButton(
                          icon: Icon(Icons.arrow_left),
                          onPressed: () {
                            _changeYear(-1); // Decrease year
                          },
                        ),
                        // Display the current selected year
                        Text(
                          selectedYear.toString(),
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        // Right Arrow Button
                        IconButton(
                          icon: Icon(Icons.arrow_right),
                          onPressed: () {
                            _changeYear(1); // Increase year
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Height()));
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
