import 'package:admin_adelle/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Emotion extends StatefulWidget {
  const Emotion({super.key});

  @override
  State<Emotion> createState() => _EmotionState();
}

class _EmotionState extends State<Emotion> {
  TextEditingController emotion = TextEditingController();

  int editId = 0;

  List<Map<String, dynamic>> emotionList = [];

  Future<void> fetchData() async {
    try {
      final response = await supabase.from('tbl_emotions').select();
      setState(() {
        emotionList = response;
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
      String emotionText = emotion.text.trim().toLowerCase();

      try {
        // Check if the emotion already exists (case-insensitive)
        final existingEmotion = await supabase
            .from('tbl_emotions')
            .select()
            .ilike('emotion_choice', emotionText) // Case-insensitive match
            .maybeSingle();

        if (existingEmotion != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "This emotion already exists!",
                style: GoogleFonts.quicksand().copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          await supabase.from("tbl_emotions").insert({
            'emotion_choice': emotionText,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Emotion Added!",
                style: GoogleFonts.quicksand().copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );

          fetchData();
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to insert emotion!",
              style: GoogleFonts.quicksand().copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }

      emotion.clear();
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_emotions').delete().eq('emotion_id', id);
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
      emotion.clear();
    }
  }

  Future<void> update() async {
    String emotionText = emotion.text.trim().toLowerCase();

    try {
      // Check if another record (excluding the current one) has the same emotion
      final existingEmotion = await supabase
          .from('tbl_emotions')
          .select()
          .ilike('emotion_choice', emotionText) // Case-insensitive search
          .neq('emotion_id', editId) // Exclude the current emotion
          .maybeSingle();

      if (existingEmotion != null) {
        // If an emotion with the same name already exists, show an error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "This emotion already exists!",
              style: GoogleFonts.quicksand().copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Proceed with the update
        await supabase
            .from('tbl_emotions')
            .update({'emotion_choice': emotionText}).eq('emotion_id', editId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Updated successfully!",
              style: GoogleFonts.quicksand().copyWith(color: Colors.white),
            ),
            backgroundColor: Color.fromARGB(255, 3, 43, 156),
          ),
        );

        fetchData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to update!",
            style: GoogleFonts.quicksand().copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
      );
    }

    // Reset fields after update attempt
    emotion.clear();
    setState(() {
      editId = 0;
    });
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
                  "Emotional States Management",
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
                          controller: emotion,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please insert emotion";
                            }
                            return null;
                          },
                          cursorColor: Color.fromARGB(221, 6, 6, 6),
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueGrey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Emotional State",
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
                              //  Color.fromARGB(221, 6, 6, 6),
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
                  child: Column(
                    children: [
                      ListView.builder(
                        itemCount: emotionList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final data = emotionList[index];
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
                                    data['emotion_choice'],
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
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                                editId = data['emotion_id'];
                                                emotion.text =
                                                    data['emotion_choice'];
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
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                              delete(data['emotion_id']);
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
                    ],
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
