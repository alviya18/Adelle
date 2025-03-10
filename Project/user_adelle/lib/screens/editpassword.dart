import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_adelle/components/form_validation.dart';
import 'package:user_adelle/main.dart';
import 'package:cherry_toast/cherry_toast.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldpass = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmpass = TextEditingController();

  Future<void> update() async {
    try {
      final user = supabase.auth.currentUser!.id;
      final response =
          await supabase.from('tbl_user').select().eq('user_id', user).single();
      String password = response['user_password'];
      if (password == oldpass.text) {
        if (oldpass.text != confirmpass.text) {
          if (pass.text == confirmpass.text) {
            await supabase.auth.updateUser(
              UserAttributes(
                password: confirmpass.text,
              ),
            );
            await supabase.from('tbl_user').update({
              'user_password': confirmpass.text,
            }).eq('user_id', user);
            pass.clear();
            confirmpass.clear();
            oldpass.clear();
            CherryToast.success(
              title: const Text(
                "Password Updated!",
              ),
            ).show(context);
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                title: Text("Password Mismatch",
                    style: GoogleFonts.sortsMillGoudy()),
                content: Text(
                    "Your confirm password is incorrect. Please try again.",
                    style: GoogleFonts.sortsMillGoudy()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the popup
                      },
                      child: Text("OK",
                          style: GoogleFonts.sortsMillGoudy()
                              .copyWith(color: Color(0xFFDC010E)))),
                ],
              ),
            );
          }
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Failed", style: GoogleFonts.sortsMillGoudy()),
              content: Text(
                  "Your new password cannot be same as your current password . Please try again.",
                  style: GoogleFonts.sortsMillGoudy()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the popup
                    },
                    child: Text("OK",
                        style: GoogleFonts.sortsMillGoudy()
                            .copyWith(color: Color(0xFFDC010E)))),
              ],
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title:
                Text("Password Mismatch", style: GoogleFonts.sortsMillGoudy()),
            content: Text(
                "Your current password does not match. Please try again.",
                style: GoogleFonts.sortsMillGoudy()),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the popup
                  },
                  child: Text("OK",
                      style: GoogleFonts.sortsMillGoudy()
                          .copyWith(color: Color(0xFFDC010E)))),
            ],
          ),
        );
      }

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(
      //     "Password Updated!",
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: Colors.green,
      // ));
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

  bool isObscure = true;
  bool hello = true;
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
          title: Text("Change Password",
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
                      // Text("Change Password.",
                      //     style: GoogleFonts.sortsMillGoudy().copyWith(
                      //       color: Color.fromARGB(255, 245, 60, 72),
                      //       fontSize: 36,
                      //       // fontWeight: FontWeight.bold
                      //     )),
                      // SizedBox(
                      //   height: 80,
                      // ),
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
                                  color: const Color.fromARGB(255, 245, 60, 72)
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your old password";
                                      }
                                      return null;
                                    },
                                    style: GoogleFonts.diphylleia().copyWith(
                                        color:
                                            const Color.fromARGB(255, 4, 4, 4),
                                        fontSize: 14),
                                    controller: oldpass,
                                    cursorColor: Color.fromARGB(255, 7, 7, 7),
                                    decoration: InputDecoration(
                                      errorStyle:
                                          TextStyle(color: Colors.black),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 245, 60, 72),
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Color.fromARGB(255, 245, 60, 72),
                                      )),
                                      // prefixIcon: Icon(
                                      //   Icons.person,
                                      //   color: Color.fromARGB(255, 245, 60, 72),
                                      // ),
                                      label: Text("Current password",
                                          style: GoogleFonts.diphylleia()),
                                      labelStyle: TextStyle(
                                        color: Color.fromARGB(255, 245, 60, 72),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    validator: (value) =>
                                        FormValidation.validatePassword(value),
                                    style: GoogleFonts.diphylleia().copyWith(
                                        color:
                                            const Color.fromARGB(255, 4, 4, 4),
                                        fontSize: 14),
                                    controller: pass,
                                    obscureText: isObscure,
                                    cursorColor: Color.fromARGB(255, 7, 7, 7),
                                    decoration: InputDecoration(
                                      errorStyle:
                                          TextStyle(color: Colors.black),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 245, 60, 72),
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Color.fromARGB(255, 245, 60, 72),
                                      )),
                                      // prefixIcon: Icon(
                                      //   Icons.key,
                                      //   color: Color.fromARGB(255, 245, 60, 72),
                                      // ),
                                      label: Text("New password",
                                          style: GoogleFonts.diphylleia()),
                                      labelStyle: TextStyle(
                                        color: Color.fromARGB(255, 245, 60, 72),
                                        fontSize: 13,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isObscure
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color:
                                              Color.fromARGB(255, 245, 60, 72),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isObscure = !isObscure;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    // validator: (value) =>
                                    //     FormValidation.validateConfirmPassword(
                                    //         value, pass.text),
                                    style: GoogleFonts.diphylleia().copyWith(
                                        color:
                                            const Color.fromARGB(255, 4, 4, 4),
                                        fontSize: 14),
                                    controller: confirmpass,
                                    obscureText: hello,
                                    cursorColor: Color.fromARGB(255, 7, 7, 7),
                                    decoration: InputDecoration(
                                      errorStyle:
                                          TextStyle(color: Colors.black),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 245, 60, 72),
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Color.fromARGB(255, 245, 60, 72),
                                      )),
                                      // prefixIcon: Icon(
                                      //   Icons.lock_rounded,
                                      //   color: Color.fromARGB(255, 245, 60, 72),
                                      // ),
                                      label: Text("Confirm new password",
                                          style: GoogleFonts.diphylleia()),
                                      labelStyle: TextStyle(
                                        color: Color.fromARGB(255, 245, 60, 72),
                                        fontSize: 13,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          hello
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color:
                                              Color.fromARGB(255, 245, 60, 72),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            hello = !hello;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (formKey.currentState!.validate()) {
                                update();
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
                              "UPDATE",
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
