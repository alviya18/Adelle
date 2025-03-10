import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';

class AddMood extends StatefulWidget {
  const AddMood({super.key});

  @override
  State<AddMood> createState() => _AddMoodState();
}

class _AddMoodState extends State<AddMood> {
  List<Map<String, dynamic>> answers = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await supabase.from('tbl_emotions').select();

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

  Future<void> insert() async {
    String? symptom = selectedValue;
    try {
      await supabase.from("tbl_userEmotions").insert({
        'emotion_id': symptom,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Added!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
      fetchData();
    } catch (e) {
      print(e);
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
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFFDC010E),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close_sharp),
          color: Colors.white,
        ),
        title: Text(
          "Moods",
          style: GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            answers.isEmpty
                ? CircularProgressIndicator(
                    color: Color(0xFFDC010E),
                  )
                : Wrap(
                    // Vertical spacing
                    children: List.generate(
                      answers.length,
                      (int index) {
                        final data = answers[index];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 2 -
                              20, // Two in a row
                          child: Card(
                            color: value == index
                                ? Color(0xFFDC010E)
                                : Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Color(0xFFDC010E)),
                            ),
                            child: InkWell(
                              onTap: () {
                                print(data['emotion_id']);
                                setState(() {
                                  value = index;
                                  selectedValue = data['emotion_id'].toString();
                                });
                              },
                              child: Container(
                                height: 180,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  data['emotion_choice'],
                                  style: GoogleFonts.sortsMillGoudy().copyWith(
                                    color: value == index
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            IconButton(
                style: IconButton.styleFrom(
                    backgroundColor: Color(0xFFDC010E),
                    overlayColor: Color.fromARGB(255, 8, 8, 8),
                    shadowColor: Color(0xFFDC010E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    )),
                onPressed: () {
                  insert();
                  print("SELECTED: $selectedValue");
                },
                icon: Icon(
                  Icons.done,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}
