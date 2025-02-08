import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';
import 'package:user_adelle/screens/yob.dart';

class GynacologicalDisease extends StatefulWidget {
  const GynacologicalDisease({super.key});

  @override
  State<GynacologicalDisease> createState() => _GynacologicalDiseaseState();
}

class _GynacologicalDiseaseState extends State<GynacologicalDisease> {
  int selectedAnswerIndex = -1;
  List<Map<String, dynamic>> answers = [];

  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await supabase.from('tbl_gd').select();
      setState(() {
        answers = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  int? value;

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
                    "Please select any of the following health issues you may have.",
                    style: GoogleFonts.sortsMillGoudy().copyWith(
                      color: Color(0xFFDC010E),
                      fontSize: 24,
                    )),
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: answers.isEmpty
                      ? CircularProgressIndicator(
                          color: Color(0xFFDC010E),
                        ) // Show loading while waiting for data
                      : Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          spacing: 15.0,
                          children: List<Widget>.generate(
                            answers.length,
                            (int index) {
                              final data = answers[index];
                              return ChoiceChip(
                                backgroundColor: Colors.white,
                                showCheckmark: false,
                                label: SizedBox(
                                  width: 130,
                                  child: Text(data['gd_choice'],
                                      style: GoogleFonts.sortsMillGoudy()
                                          .copyWith(
                                              color: value == index
                                                  ? Colors.white
                                                  : Color(0xFFDC010E),
                                              fontSize: 16),
                                      textAlign: TextAlign.center),
                                ),
                                selected: value == index,
                                selectedColor: Color(0xFFDC010E),
                                side: BorderSide(color: Color(0xFFDC010E)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                onSelected: (bool selected) {
                                  setState(() {
                                    value = selected ? index : null;
                                  });
                                },
                              );
                            },
                          ).toList(),
                        ),
                ),
                SizedBox(
                  height: 200,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => YearofBirth()));
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
                                builder: (context) => YearofBirth()));
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
