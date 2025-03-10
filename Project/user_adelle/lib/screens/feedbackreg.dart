import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/components/form_validation.dart';
import 'package:user_adelle/main.dart';

class RegisterFeedback extends StatefulWidget {
  const RegisterFeedback({super.key});

  @override
  State<RegisterFeedback> createState() => _RegisterFeedbackState();
}

class _RegisterFeedbackState extends State<RegisterFeedback> {
  TextEditingController issueController = TextEditingController();

  Future<void> insert() async {
    if (formKey.currentState!.validate()) {
      String issue = issueController.text;
      try {
        await supabase.from("tbl_feedback").insert({
          'user_id': supabase.auth.currentUser!.id,
          'feedback_content': issue,
          'feedback_date': DateTime.now().toUtc().toIso8601String(),
        });
        CherryToast.success(
          title: const Text(
            "Feedback submitted successfully!",
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
          title: Text("Feedback",
              style:
                  GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white))),
      body: Column(
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
                                        validator: (value) =>
                                            FormValidation.validateFeedback(
                                                value),
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
                                          label: Text("Provide Feedback",
                                              style: GoogleFonts.diphylleia()),
                                          labelStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 245, 60, 72),
                                            fontSize: 13,
                                          ),
                                        ),
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
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
                              "SUMBIT",
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
