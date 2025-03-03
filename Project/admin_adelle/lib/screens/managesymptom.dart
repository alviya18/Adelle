import 'package:admin_adelle/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Symptoms extends StatefulWidget {
  const Symptoms({super.key});

  @override
  State<Symptoms> createState() => _SymptomsState();
}

class _SymptomsState extends State<Symptoms> {
  TextEditingController symptoms = TextEditingController();

  int editId = 0;

  List<Map<String, dynamic>> symptomsList = [];

  Future<void> fetchData() async {
    try {
      final response = await supabase.from('tbl_symptoms').select();
      setState(() {
        symptomsList = response;
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
    if (formKey.currentState!.validate()) {
      String disease = symptoms.text;
      try {
        await supabase.from("tbl_symptoms").insert({
          'symptom_choice': disease,
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
      symptoms.clear();
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_symptoms').delete().eq('symptom_id', id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Deleted!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red));

      fetchData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed",
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.black,
      ));
      symptoms.clear();
    }
  }

  Future<void> update() async {
    try {
      await supabase
          .from('tbl_symptoms')
          .update({'symptom_choice': symptoms.text}).eq('symptom_id', editId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Updated",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 3, 43, 156),
      ));

      fetchData();
      symptoms.clear();
      setState(() {
        editId = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed",
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Colors.black,
        ),
      );
      symptoms.clear();
      setState(() {
        editId = 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: LayoutBuilder(
        builder: (context, constraints) => Form(
          key: formKey,
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Symptoms Management",
                style: GoogleFonts.quicksand().copyWith(
                    fontSize: 36, color: const Color.fromARGB(255, 3, 3, 3)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    style: GoogleFonts.quicksand().copyWith(
                        color: Color.fromARGB(221, 6, 6, 6),
                        fontWeight: FontWeight.bold),
                    controller: symptoms,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please insert symptoms";
                      }
                      return null;
                    },
                    cursorColor: Color.fromARGB(221, 6, 6, 6),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(221, 6, 6, 6)),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(221, 6, 6, 6))),
                        hintText: "Symptoms",
                        hintStyle: GoogleFonts.quicksand().copyWith(
                          color: Color.fromARGB(221, 6, 6, 6),
                          fontSize: 13,
                        )),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 100,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (editId == 0) {
                        insert();
                      } else {
                        update();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(221, 240, 63, 63),
                        overlayColor: Color.fromARGB(255, 40, 41, 42),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: Text(
                      "ENTER",
                      style: GoogleFonts.quicksand().copyWith(
                        color: const Color.fromARGB(221, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            ListView.builder(
              itemCount: symptomsList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final data = symptomsList[index];
                return ListTile(
                    title: Text(
                      data['symptom_choice'],
                      style: GoogleFonts.quicksand().copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: const Color.fromARGB(255, 0, 60, 226),
                            ),
                            onPressed: () {
                              setState(() {
                                editId = data['symptom_id'];
                                symptoms.text = data['symptom_choice'];
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              delete(data['symptom_id']);
                            },
                          ),
                        ],
                      ),
                    ));
              },
            )
          ]),
        ),
      ),
    );
  }
}
