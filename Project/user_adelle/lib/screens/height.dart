// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:user_adelle/screens/periodDuration.dart';

// class Height extends StatefulWidget {
//   const Height({super.key});

//   @override
//   State<Height> createState() => _HeightState();
// }

// class _HeightState extends State<Height> {
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
//                 Text("Provide your height in cm.",
//                     style: GoogleFonts.sortsMillGoudy().copyWith(
//                       color: Color(0xFFDC010E),
//                       fontSize: 24,
//                     )),

//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => Periodduration()));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFFDC010E),
//                     overlayColor: Color.fromARGB(255, 8, 8, 8),
//                     shadowColor: Color(0xFFDC010E),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                   ),
//                   child: Text(
//                     "NEXT",
//                     style: GoogleFonts.sortsMillGoudy().copyWith(
//                       color: const Color.fromARGB(221, 255, 255, 255),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';
import 'package:user_adelle/screens/lastperiod.dart';
import 'package:user_adelle/screens/periodduration.dart';

class Height extends StatefulWidget {
  const Height({super.key});

  @override
  State<Height> createState() => _HeightState();
}

class _HeightState extends State<Height> {
  List<int> height =
      List.generate(101, (index) => 120 + index); // 120cm to 220cm
  int selectedHeight = 150;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(
        initialItem: height.indexOf(selectedHeight));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String? heightSelected;

  Future<void> update() async {
    try {
      String userId = supabase.auth.currentUser!.id;

      await supabase.from('tbl_user').update({
        'user_height': heightSelected, // Corrected field name
      }).eq('user_id', userId);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Lastperiod(),
        ),
      );
    } catch (e) {
      print("Error: $e");
    }
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
                SizedBox(height: 220),
                Text(
                  "Provide your height in cm.",
                  style: GoogleFonts.sortsMillGoudy().copyWith(
                    color: Color(0xFFDC010E),
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(100),
                  child: Column(
                    children: [
                      Text(
                        selectedHeight < height.last
                            ? "${selectedHeight + 1}.0 "
                            : "",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(81, 220, 1, 16),
                        ),
                      ),
                      Divider(
                          color: Color.fromARGB(113, 40, 40, 40),
                          thickness: 1.2),
                      SizedBox(
                        height: 50,
                        child: ListWheelScrollView.useDelegate(
                          controller: _scrollController,
                          itemExtent: 50,
                          physics: FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedHeight = height[index];
                              heightSelected = height[index].toString();
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              return Center(
                                child: Text(
                                  "${height[index]}.0",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: selectedHeight == height[index]
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: Color(0xFFDC010E),
                                  ),
                                ),
                              );
                            },
                            childCount: height.length,
                          ),
                        ),
                      ),
                      Divider(
                          color: Color.fromARGB(113, 40, 40, 40),
                          thickness: 1.2),
                      Text(
                        selectedHeight > height.first
                            ? "${selectedHeight - 1}.0 "
                            : "",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(81, 220, 1, 16),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 110),
                ElevatedButton(
                  onPressed: () {
                    update();
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
                      color: Colors.white,
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
