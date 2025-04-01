import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';
import 'package:user_adelle/screens/gd.dart';

class Birthcontrol extends StatefulWidget {
  const Birthcontrol({super.key});

  @override
  State<Birthcontrol> createState() => _BirthcontrolState();
}

class _BirthcontrolState extends State<Birthcontrol> {
  int selectedAnswerIndex = -1;
  List<Map<String, dynamic>> answers = [];

  int? selectedBc;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await supabase.from('tbl_bc').select();
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

  Future<void> update() async {
    try {
      String userId = supabase.auth.currentUser!.id;

      await supabase.from('tbl_user').update({
        'bc_id': selectedBc,
      }).eq('user_id', userId);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GynacologicalDisease(),
          ));
    } catch (e) {
      print("Error : $e");
    }
  }

  int? value;
  String? selectedValue;

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
                Text("Are you currently on any form of Birth Control?",
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
                                  width: 80,
                                  child: Text(data['bc_choice'],
                                      style: GoogleFonts.sortsMillGoudy()
                                          .copyWith(
                                              color: value == index
                                                  ? Colors.white
                                                  : Color.fromARGB(
                                                      255, 0, 0, 0),
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
                                    selectedBc = data['bc_id'];
                                  });
                                },
                              );
                            },
                          ).toList(),
                        ),
                ),
                SizedBox(
                  height: 320,
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
