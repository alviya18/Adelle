// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:user_adelle/screens/lastPeriod.dart';

// class Periodduration extends StatefulWidget {
//   const Periodduration({super.key});

//   @override
//   State<Periodduration> createState() => _PerioddurationState();
// }

// class _PerioddurationState extends State<Periodduration> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 height: 150,
//                 decoration: BoxDecoration(
//                     borderRadius:
//                         BorderRadius.vertical(bottom: Radius.circular(50)),
//                     color: const Color(0xFFDC010E),
//                     image: DecorationImage(
//                         image: AssetImage("assets/userlogin4.webp"),
//                         fit: BoxFit.cover)),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(
//                   height: 220,
//                 ),
//                 Text("How long is does your period last?",
//                     style: GoogleFonts.sortsMillGoudy().copyWith(
//                       color: Color(0xFFDC010E),
//                       fontSize: 24,
//                     )),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => Lastperiod()));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         elevation: 0,
//                         backgroundColor: Color.fromARGB(255, 255, 255, 255),
//                         shape: RoundedRectangleBorder(
//                           side: BorderSide(
//                             color: const Color(0xFFDC010E),
//                           ),
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                       ),
//                       child: Text(
//                         "SKIP",
//                         style: GoogleFonts.sortsMillGoudy().copyWith(
//                           color: const Color(0xFFDC010E),
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => Lastperiod()));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFFDC010E),
//                         overlayColor: Color.fromARGB(255, 8, 8, 8),
//                         shadowColor: Color(0xFFDC010E),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                       ),
//                       child: Text(
//                         "NEXT",
//                         style: GoogleFonts.sortsMillGoudy().copyWith(
//                           color: const Color.fromARGB(221, 255, 255, 255),
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';
import 'package:user_adelle/screens/AverageCycle.dart';

class Periodduration extends StatefulWidget {
  const Periodduration({super.key});

  @override
  State<Periodduration> createState() => _PerioddurationState();
}

class _PerioddurationState extends State<Periodduration> {
  Future<void> update() async {
    try {
      String userId = supabase.auth.currentUser!.id;
      print("Weight: $selectedDuration");
      await supabase.from('tbl_user').update({
        'user_cycleDuration': selectedDuration,
      }).eq('user_id', userId);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Averagecycle(),
          ));
    } catch (e) {
      print("Error: $e");
    }
  }

  final ScrollController _scrollController = ScrollController();
  int selectedIndex = 0; // Default selected number
  int? selectedDuration;

  final List<int> numbers =
      List.generate(6, (index) => index + 2); // Odd numbers: [1, 3, 5, ..., 39]

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(selectedIndex);
    });
  }

  void _scrollToIndex(int index) {
    double itemWidth = 60.0;
    _scrollController.animateTo(
      index * itemWidth,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(50),
                  ),
                  color: const Color(0xFFDC010E),
                  image: const DecorationImage(
                    image: AssetImage("assets/userlogin4.webp"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 220),
                Text(
                  "How long does your period last?",
                  style: GoogleFonts.sortsMillGoudy().copyWith(
                    color: const Color(0xFFDC010E),
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 100),

                // Scrollable Picker
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 80,
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: numbers.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool isSelected = index == selectedIndex;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                selectedDuration = numbers[selectedIndex];
                              });
                              _scrollToIndex(index);
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Color(0xFFDC010E)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Color(0xFFDC010E),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                numbers[index].toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Triangle Pointer
                  ],
                ),

                SizedBox(height: 20),

                // Selected Value Display
                Center(
                  child: Text(
                    " ${numbers[selectedIndex]} days",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 250),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Color(0xFFDC010E)),
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
                        update();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC010E),
                        overlayColor: const Color.fromARGB(255, 8, 8, 8),
                        shadowColor: const Color(0xFFDC010E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        "NEXT",
                        style: GoogleFonts.sortsMillGoudy().copyWith(
                          color: Colors.white,
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
