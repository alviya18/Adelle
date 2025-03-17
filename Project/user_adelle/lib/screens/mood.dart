import 'package:cherry_toast/cherry_toast.dart';
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
        'userEmotions_month': DateTime.now().month,
        'userEmotions_year': DateTime.now().year,
      });
      CherryToast.success(title: const Text("Done!")).show(context);

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(81, 220, 1, 16),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          "Moods",
                          style: GoogleFonts.sortsMillGoudy().copyWith(
                            fontSize: 22,
                            // color: Color(0xFFDC010E),
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            answers.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFDC010E),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: answers.length,
                      itemBuilder: (context, index) {
                        final data = answers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 4),
                          child: Card(
                            surfaceTintColor: Colors.white,
                            shadowColor:
                                // value == index
                                //     ? Color(0xFFDC010E)
                                //     : Colors.white,
                                Color.fromARGB(64, 220, 1, 16),
                            color: value == index
                                ? Color(0xFFDC010E)
                                : Colors.white,
                            elevation: 10,
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
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          insert();
        },
        backgroundColor: Color(0xFFDC010E),

        // overlayColor: Color.fromARGB(255, 8, 8, 8),
        // shadowColor: Color(0xFFDC010E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
