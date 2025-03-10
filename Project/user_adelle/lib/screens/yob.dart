import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';
import 'package:user_adelle/screens/weight.dart';

class YearofBirth extends StatefulWidget {
  @override
  _YearofBirthState createState() => _YearofBirthState();
}

class _YearofBirthState extends State<YearofBirth> {
  int selectedYear = DateTime.now().year - 20; // Default to 20 years old
  int currentYear = DateTime.now().year;
  late FixedExtentScrollController _scrollController;
  List<int> years = List.generate(63, (index) => DateTime.now().year - index);

  @override
  void initState() {
    super.initState();
    _scrollController =
        FixedExtentScrollController(initialItem: years.indexOf(selectedYear));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String yearSelected = (DateTime.now().year - 20).toString();

  String? yobSelected;

  Future<void> update() async {
    try {
      String userId = supabase.auth.currentUser!.id;

      await supabase.from('tbl_user').update({
        'user_yob': yearSelected,
      }).eq('user_id', userId);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Weight(),
          ));
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            // HEADER IMAGE
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

            SizedBox(height: 80),

            // TITLE TEXT
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Which year were you born?",
                      style: GoogleFonts.sortsMillGoudy().copyWith(
                        color: Color(0xFFDC010E),
                        fontSize: 24,
                      )),
                ],
              ),
            ),

            // SizedBox(height: 20),

            // YEAR PICKER UI
            Padding(
              padding: const EdgeInsets.all(100.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selectedYear < currentYear ? "${selectedYear + 1}" : "",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(81, 220, 1, 16),
                    ),
                  ),
                  Divider(
                      color: Color.fromARGB(113, 40, 40, 40), thickness: 1.2),
                  SizedBox(
                    height: 50,
                    child: ListWheelScrollView.useDelegate(
                      controller: _scrollController,
                      itemExtent: 50,
                      physics: FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedYear =
                              years[index]; // ✅ Update selectedYear dynamically
                          yearSelected = years[index].toString();
                          print(years[index].toString());
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          return Center(
                            child: Text(
                              "${years[index]}",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: selectedYear == years[index]
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: Color(0xFFDC010E),
                              ),
                            ),
                          );
                        },
                        childCount: years.length,
                      ),
                    ),
                  ),
                  Divider(
                      color: Color.fromARGB(113, 40, 40, 40), thickness: 1.2),
                  Text(
                    selectedYear > 8 ? "${selectedYear - 1}" : "",
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(81, 220, 1, 16)),
                  ),
                ],
              ),
            ),

            SizedBox(height: 110),

            // BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      MaterialPageRoute(builder: (context) => Weight());
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
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
            ),

            SizedBox(height: 20),
          ],
        ));
  }
}
