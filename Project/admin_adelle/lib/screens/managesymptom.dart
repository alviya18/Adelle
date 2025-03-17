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
          style: GoogleFonts.quicksand().copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> insert() async {
    if (formKey.currentState!.validate()) {
      String disease = symptoms.text.trim(); // Trim to avoid unnecessary spaces

      try {
        // Check if the symptom already exists in the database
        final existingSymptom = await supabase
            .from("tbl_symptoms")
            .select()
            .eq('symptom_choice', disease)
            .maybeSingle(); // Returns null if no record found

        if (existingSymptom != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Symptom already exists!",
              style: GoogleFonts.quicksand().copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.orange,
          ));
          return; // Exit without inserting
        }

        // Insert new symptom if not a duplicate
        await supabase.from("tbl_symptoms").insert({
          'symptom_choice': disease,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Added!",
            style: GoogleFonts.quicksand().copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ));

        fetchData();
        symptoms.clear();
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Failed",
            style: GoogleFonts.quicksand().copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_symptoms').delete().eq('symptom_id', id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Deleted!",
            style: GoogleFonts.quicksand().copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red));

      fetchData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed",
          style: GoogleFonts.quicksand().copyWith(color: Colors.red),
        ),
        backgroundColor: Colors.black,
      ));
      symptoms.clear();
    }
  }

  Future<void> update() async {
    String newSymptom = symptoms.text.trim(); // Trim to avoid extra spaces

    try {
      // Check if the symptom name already exists (excluding the current entry)
      final existingSymptom = await supabase
          .from('tbl_symptoms')
          .select()
          .eq('symptom_choice', newSymptom)
          .neq('symptom_id',
              editId) // Ensure it's not the same record being updated
          .maybeSingle(); // Returns null if no duplicate exists

      if (existingSymptom != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Symptom already exists!",
            style: GoogleFonts.quicksand().copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
        ));
        return; // Exit without updating
      }

      // Proceed with update if no duplicate found
      await supabase
          .from('tbl_symptoms')
          .update({'symptom_choice': newSymptom}).eq('symptom_id', editId);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Updated!",
          style: GoogleFonts.quicksand().copyWith(color: Colors.white),
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
            style: GoogleFonts.quicksand().copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
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
    return Container(
      child: LayoutBuilder(
        builder: (context, constraints) => Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Symptoms Management",
                  style: GoogleFonts.quicksand()
                      .copyWith(fontSize: 36, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          style: GoogleFonts.quicksand().copyWith(
                              color: Colors.blueGrey,
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
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueGrey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Symptoms",
                              hintStyle: GoogleFonts.quicksand().copyWith(
                                color: Colors.blueGrey,
                                fontSize: 13,
                              ),
                              errorStyle: GoogleFonts.quicksand()),
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
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                    itemCount: symptomsList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final data = symptomsList[index];
                      return Card(
                        surfaceTintColor: Colors.white,
                        color: Colors.white,
                        elevation: 4,
                        // shadowColor: Color(0xFFDC010E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          // side: BorderSide(color: Color(0xFFDC010E)),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: ListTile(
                              leading: Text(
                                "${index + 1}",
                                style: GoogleFonts.quicksand().copyWith(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              title: Text(
                                data['symptom_choice'],
                                style: GoogleFonts.quicksand().copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Tooltip(
                                      message: "Edit",
                                      textStyle:
                                          GoogleFonts.quicksand().copyWith(
                                        color: const Color.fromARGB(
                                            255, 0, 60, 226),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: const Color.fromARGB(
                                              255, 0, 60, 226),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            editId = data['symptom_id'];
                                            symptoms.text =
                                                data['symptom_choice'];
                                          });
                                        },
                                      ),
                                    ),
                                    Tooltip(
                                      message: "Delete",
                                      textStyle:
                                          GoogleFonts.quicksand().copyWith(
                                        color: Colors.red,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.delete_outline_outlined,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          delete(data['symptom_id']);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      );
                    },
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
