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
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> insert() async {
    if (formKey.currentState!.validate()) {
      String emotionText = emotion.text;
      try {
        await supabase.from("tbl_emotions").insert({
          'emotion_choice': emotionText,
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
      emotion.clear();
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_emotions').delete().eq('emotion_id', id);
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
      emotion.clear();
    }
  }

  Future<void> update() async {
    try {
      await supabase
          .from('tbl_emotions')
          .update({'emotion_choice': emotion.text}).eq('emotion_id', editId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Updated",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 3, 43, 156),
      ));

      fetchData();
      emotion.clear();
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
      emotion.clear();
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
                "Emotional States Management",
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
                    controller: emotion,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please insert emotion";
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
                        hintText: "Emotional State",
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
            SizedBox(
              height: 50,
            ),
            ListView.builder(
              itemCount: emotionList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final data = emotionList[index];
                return ListTile(
                    title: Text(
                      data['emotion_choice'],
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
                                editId = data['emotion_id'];
                                emotion.text = data['emotion_choice'];
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              delete(data['emotion_id']);
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
