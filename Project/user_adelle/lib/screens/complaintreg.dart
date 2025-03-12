import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/components/form_validation.dart';
import 'package:user_adelle/main.dart';

class RegisterComplaint extends StatefulWidget {
  const RegisterComplaint({super.key});

  @override
  State<RegisterComplaint> createState() => _RegisterComplaintState();
}

class _RegisterComplaintState extends State<RegisterComplaint> {
  TextEditingController titleController = TextEditingController();
  TextEditingController issueController = TextEditingController();

  Future<void> insert() async {
    if (formKey.currentState!.validate()) {
      String title = titleController.text;
      String issue = issueController.text;
      try {
        await supabase.from("tbl_complaint").insert({
          'user_id': supabase.auth.currentUser!.id,
          'complaint_title': title,
          'complaint_content': issue,
          'complaint_date': DateTime.now().toUtc().toIso8601String(),
          'complaint_status': 0
        });
        CherryToast.success(
          title: const Text(
            "Complaint Registered!",
          ),
        ).show(context);
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
      titleController.clear();
      issueController.clear();
    }
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Color(0xFFDC010E),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close_sharp),
            color: Colors.white,
          ),
          title: Text("Register a Complaint",
              style:
                  GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white))),
      body: ListView(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150,
                      ),
                      SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 245, 60, 72)
                                            .withOpacity(0.2), // Shadow color
                                    spreadRadius:
                                        2, // How much the shadow spreads
                                    blurRadius: 5, // How blurry the shadow is
                                    offset:
                                        Offset(0, 3), // Shadow position (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      TextFormField(
                                        validator: (value) => FormValidation
                                            .validateComplaintTitle(value),
                                        style: GoogleFonts.diphylleia()
                                            .copyWith(
                                                color: const Color.fromARGB(
                                                    255, 4, 4, 4),
                                                fontSize: 14),
                                        controller: titleController,
                                        cursorColor:
                                            Color.fromARGB(255, 7, 7, 7),
                                        decoration: InputDecoration(
                                          errorStyle:
                                              TextStyle(color: Colors.black),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 245, 60, 72),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 245, 60, 72),
                                          )),
                                          label: Text("Complaint title",
                                              style: GoogleFonts.diphylleia()),
                                          labelStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 245, 60, 72),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        validator: (value) => FormValidation
                                            .validateComplaintIssue(value),
                                        style: GoogleFonts.diphylleia()
                                            .copyWith(
                                                color: const Color.fromARGB(
                                                    255, 4, 4, 4),
                                                fontSize: 14),
                                        controller: issueController,
                                        cursorColor:
                                            Color.fromARGB(255, 7, 7, 7),
                                        decoration: InputDecoration(
                                          errorStyle:
                                              TextStyle(color: Colors.black),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 245, 60, 72),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 245, 60, 72),
                                          )),
                                          label: Text("Complaint in detail",
                                              style: GoogleFonts.diphylleia()),
                                          labelStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 245, 60, 72),
                                            fontSize: 13,
                                          ),
                                        ),
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 5,
                                        minLines: 1,
                                      ),
                                    ]),
                              )),
                          SizedBox(
                            height: 60,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (formKey.currentState!.validate()) {
                                insert();
                              }
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
                              "SUBMIT",
                              style: GoogleFonts.sortsMillGoudy().copyWith(
                                color: const Color.fromARGB(221, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
