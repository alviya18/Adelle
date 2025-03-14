import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';

class AddSymptoms extends StatefulWidget {
  const AddSymptoms({super.key});

  @override
  State<AddSymptoms> createState() => _AddSymptomsState();
}

class _AddSymptomsState extends State<AddSymptoms> {
  List<Map<String, dynamic>> answers = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await supabase.from('tbl_symptoms').select();

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
      await supabase.from("tbl_userSymptoms").insert({
        'symptoms_id': symptom,
        'userSymptoms_month': DateTime.now().month,
        'userSymptoms_year': DateTime.now().year,
      });
      CherryToast.success(
        title: const Text(
          "Done!",
        ),
      ).show(context);
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
          "Symptoms",
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
                        print(data);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 4),
                          child: Card(
                            shadowColor: value == index
                                ? Color(0xFFDC010E)
                                : Colors.white,
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
                                print(data['symptom_id']);
                                setState(() {
                                  value = index;
                                  selectedValue = data['symptom_id'].toString();
                                });
                              },
                              child: Container(
                                height: 180,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  data['symptom_choice'],
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
            ),
          ])),
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
