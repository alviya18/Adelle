import 'package:admin_adelle/components/form_validation.dart';
import 'package:admin_adelle/main.dart';
import 'package:admin_adelle/screens/repliedcomplaints.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Complaints extends StatefulWidget {
  const Complaints({super.key});

  @override
  State<Complaints> createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  List<Map<String, dynamic>> answers = [];
  TextEditingController replyController = TextEditingController();
  int updateId = 0;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> update() async {
    try {
      await supabase.from('tbl_complaint').update({
        'complaint_reply': replyController.text,
        'complaint_status': 1,
        'complaint_replyDate': DateTime.now().toUtc().toString()
      }).eq('complaint_id', updateId);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Replied",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));

      fetchData();
      replyController.clear();

      setState(() {
        updateId = 0;
      });

      Navigator.pop(
        context,
        MaterialPageRoute(builder: (context) => Complaints()),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 255, 10, 71),
      ));
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await supabase
          .from('tbl_complaint')
          .select()
          .neq('complaint_status', 1);

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

  void reply(int id) {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            child: SizedBox(
              width: 500,
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Form(
                        key: formkey,
                        child: TextFormField(
                          style: GoogleFonts.quicksand().copyWith(
                              color: Color.fromARGB(221, 6, 6, 6),
                              fontWeight: FontWeight.bold),
                          controller: replyController,
                          validator: (value) =>
                              FormValidation.validateComplaintReply(value),
                          cursorColor: Color.fromARGB(221, 6, 6, 6),
                          decoration: InputDecoration(
                              errorStyle: TextStyle(
                                  color: Color.fromARGB(221, 6, 6, 6)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(221, 6, 6, 6)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              label: Text("Complaint Reply"),
                              labelStyle: GoogleFonts.quicksand().copyWith(
                                color: Colors.green,
                                fontSize: 13,
                              )),
                        ),
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
                          if (formkey.currentState!.validate()) {
                            update();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(221, 240, 63, 63),
                            overlayColor: Color.fromARGB(255, 40, 41, 42),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: Text(
                          "SEND ",
                          style: GoogleFonts.quicksand().copyWith(
                            color: const Color.fromARGB(221, 255, 255, 255),
                            // fontWeight: FontWeight.bold,
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
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "Complaints",
              style: GoogleFonts.quicksand().copyWith(
                  fontSize: 36,
                  // fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: answers.isEmpty
                ? Center(
                    child: Text(
                      "No Unreplied Complaints",
                      style: GoogleFonts.quicksand().copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: answers.length,
                          itemBuilder: (context, index) {
                            final data = answers[index];
                            return Card(
                                surfaceTintColor: Colors.white,
                                color: Colors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10),
                                  child: ListTile(
                                    leading: Tooltip(
                                      message: "Tap to reply this complaint",
                                      textStyle:
                                          GoogleFonts.quicksand().copyWith(
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.black,
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
                                          onPressed: () {
                                            updateId = data['complaint_id'];
                                            reply(data['complaint_id']);
                                          },
                                          icon: Icon(
                                            Icons.message_rounded,
                                            color: Colors.green,
                                          )),
                                    ),
                                    title: Text(
                                      data['complaint_title'],
                                      style: GoogleFonts.quicksand().copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        // fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      data['complaint_content'],
                                      style: GoogleFonts.quicksand().copyWith(
                                        color: Colors.black,
                                        // fontSize: 16,
                                      ),
                                    ),
                                    trailing: Tooltip(
                                      message: "date posted",
                                      textStyle:
                                          GoogleFonts.quicksand().copyWith(
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.black,
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
                                      child: Text(
                                        data['complaint_date'],
                                        style: GoogleFonts.quicksand().copyWith(
                                          color: Colors.black,
                                          // fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                          }),
                    ),
                  ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Repliedcomplaints()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Adjust color

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "REPLIED COMPLAINTS",
                  style: GoogleFonts.quicksand().copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
