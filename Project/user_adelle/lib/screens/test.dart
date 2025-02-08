import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/screens/weight.dart';

class RealYEar extends StatefulWidget {
  const RealYEar({super.key});

  @override
  State<RealYEar> createState() => _RealYEarState();
}

class _RealYEarState extends State<RealYEar> {
  int selectedYear = 2005; // Default year
  final List<int> years =
      List.generate(50, (index) => 1980 + index); // Years from 1980 to 2029

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Use Positioned to provide constraints and position the container
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(50)),
                  color: const Color(0xFFDC010E),
                  image: DecorationImage(
                      image: AssetImage("assets/userlogin4.webp"),
                      fit: BoxFit.cover)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 220,
                ),
                Text("Which year were you born?",
                    style: GoogleFonts.sortsMillGoudy().copyWith(
                      color: Color(0xFFDC010E),
                      fontSize: 24,
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Select Year of Birth",
                      style: GoogleFonts.sortsMillGoudy().copyWith(
                        fontSize: 24,
                        color: Color(0xFFDC010E),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        perspective: 0.01,
                        diameterRatio: .3,
                        physics: FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedYear = years[index];
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            return Center(
                              child: Text(
                                years[index].toString(),
                                style: TextStyle(
                                  fontSize:
                                      selectedYear == years[index] ? 22 : 18,
                                  fontWeight: selectedYear == years[index]
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: selectedYear == years[index]
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            );
                          },
                          childCount: years.length,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Year: ${selectedYear.toInt()}',
                      style: GoogleFonts.sortsMillGoudy().copyWith(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Weight()));
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
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Weight()));
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
          ),
        ],
      ),
    );
  }
}
