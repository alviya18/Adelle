import 'package:admin_adelle/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  TextEditingController query = TextEditingController();
  TextEditingController answer = TextEditingController();
  int editId = 0;

  List<Map<String, dynamic>> chatBotList = [];

  Future<void> fetchData() async {
    try {
      final response = await supabase.from('tbl_chatBot').select();
      setState(() {
        chatBotList = response;
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
      String chatQuery = query.text;
      String chatAnswer = answer.text;
      try {
        await supabase.from("tbl_chatBot").insert({
          'chatBot_query': chatQuery,
          'chatBot_response': chatAnswer,
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
      query.clear();
      answer.clear();
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_chatBot').delete().eq('chatBot_id', id);
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
      query.clear();
      answer.clear();
    }
  }

  Future<void> update() async {
    try {
      await supabase.from('tbl_chatBot').update({
        'chatBot_query': query.text,
        'chatBot_response': answer.text
      }).eq('chatBot_id', editId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Updated",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 3, 43, 156),
      ));

      fetchData();
      query.clear();
      answer.clear();
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
      query.clear();
      answer.clear();
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
                "ChatBot Management",
                style: GoogleFonts.quicksand().copyWith(
                    fontSize: 36,
                    // fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 3, 3, 3)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 800,
              child: TextFormField(
                style: GoogleFonts.quicksand().copyWith(
                    color: Color.fromARGB(221, 6, 6, 6),
                    fontWeight: FontWeight.bold),
                controller: query,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please insert the question";
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
                        borderSide:
                            BorderSide(color: Color.fromARGB(221, 6, 6, 6))),
                    label: Text("Enter the Query"),
                    labelStyle: GoogleFonts.quicksand().copyWith(
                        color: Color.fromARGB(221, 6, 6, 6),
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 800,
              child: TextFormField(
                style: GoogleFonts.quicksand().copyWith(
                    color: Color.fromARGB(221, 6, 6, 6),
                    fontWeight: FontWeight.bold),
                controller: answer,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please insert the response";
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
                        borderSide:
                            BorderSide(color: Color.fromARGB(221, 6, 6, 6))),
                    label: Text("Enter the Response"),
                    labelStyle: GoogleFonts.quicksand().copyWith(
                        color: Color.fromARGB(221, 6, 6, 6),
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 48,
              width: 800,
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
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),

            // Column headers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(221, 6, 6, 6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      " Slno.",
                      style: GoogleFonts.quicksand().copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 250), // Space between headers
                    Text(
                      "Query",
                      style: GoogleFonts.quicksand().copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 500,
                    ), // Space between headers
                    Text(
                      "Response",
                      style: GoogleFonts.quicksand().copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ListView.builder(
              itemCount: chatBotList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final data = chatBotList[index];
                return ListTile(
                    title: Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            (index + 1).toString(),
                            style: GoogleFonts.quicksand().copyWith(
                                color: const Color.fromARGB(221, 6, 6, 6),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          SizedBox(
                            width: 500,
                            child: Text(
                              data['chatBot_query'] ?? 'No Query',
                              style: GoogleFonts.quicksand().copyWith(
                                  color: const Color.fromARGB(221, 6, 6, 6),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          SizedBox(
                            width: 500,
                            child: Text(
                              data['chatBot_response'] ?? 'No Response',
                              style: GoogleFonts.quicksand().copyWith(
                                  color: const Color.fromARGB(221, 6, 6, 6),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: SizedBox(
                      width: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: const Color.fromARGB(255, 0, 60, 226),
                            ),
                            onPressed: () {
                              setState(() {
                                editId = data['chatBot_id'];
                                query.text = data['chatBot_query'];
                                answer.text = data['chatBot_response'];
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              delete(data['chatBot_id']);
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
