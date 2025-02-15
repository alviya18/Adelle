import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/components/form_validation.dart';
import 'package:user_adelle/main.dart';
import 'package:user_adelle/screens/agree.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController emailID = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmpass = TextEditingController();
  Future<void> signUp() async {
    try {
      final authentication = await supabase.auth
          .signUp(password: confirmpass.text, email: emailID.text);
      String uid = authentication.user!.id;
      insert(uid);
    } catch (e) {
      print("Error Authentication: $e");
    }
  }

  Future<void> insert(String uid) async {
    String email = emailID.text;
    String password = confirmpass.text;
    try {
      await supabase.from('tbl_user').insert(
          {'user_id': uid, 'user_email': email, 'user_password': password});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Acount Created!',
            style: GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white),
          )));
      emailID.clear();
      pass.clear();
      confirmpass.clear();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Agree(),
          ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            "failed",
            style: GoogleFonts.sortsMillGoudy().copyWith(color: Colors.red),
          )));
      print("insertion failed:$e");
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
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50)),
                    color: const Color(0xFFDC010E),
                    image: DecorationImage(
                        image: AssetImage("assets/userlogin4.webp"),
                        fit: BoxFit.cover)),
              ),
            ],
          ),
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
                      Text("Create Account.",
                          style: GoogleFonts.sortsMillGoudy().copyWith(
                            color: Color.fromARGB(255, 245, 60, 72),
                            fontSize: 36,
                            // fontWeight: FontWeight.bold
                          )),
                      SizedBox(
                        height: 50,
                      ),
                      SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            validator: (value) =>
                                FormValidation.validateEmail(value),
                            style: GoogleFonts.diphylleia().copyWith(
                                color: const Color.fromARGB(255, 4, 4, 4),
                                fontSize: 14),
                            controller: emailID,
                            cursorColor: Color.fromARGB(255, 7, 7, 7),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 245, 60, 72),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color.fromARGB(255, 245, 60, 72),
                              )),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 245, 60, 72),
                              ),
                              label: Text("email",
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
                                color: const Color.fromARGB(255, 4, 4, 4),
                                fontSize: 14),
                            controller: pass,
                            obscureText: isObscure,
                            cursorColor: Color.fromARGB(255, 7, 7, 7),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 245, 60, 72),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color.fromARGB(255, 245, 60, 72),
                              )),
                              prefixIcon: Icon(
                                Icons.key,
                                color: Color.fromARGB(255, 245, 60, 72),
                              ),
                              label: Text("password",
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
                                  color: Color.fromARGB(255, 245, 60, 72),
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
                            validator: (value) =>
                                FormValidation.validateConfirmPassword(
                                    value, pass.text),
                            style: GoogleFonts.diphylleia().copyWith(
                                color: const Color.fromARGB(255, 4, 4, 4),
                                fontSize: 14),
                            controller: confirmpass,
                            obscureText: hello,
                            cursorColor: Color.fromARGB(255, 7, 7, 7),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 245, 60, 72),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color.fromARGB(255, 245, 60, 72),
                              )),
                              prefixIcon: Icon(
                                Icons.lock_rounded,
                                color: Color.fromARGB(255, 245, 60, 72),
                              ),
                              label: Text("Confirm password",
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
                                  color: Color.fromARGB(255, 245, 60, 72),
                                ),
                                onPressed: () {
                                  setState(() {
                                    hello = !hello;
                                  });
                                },
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
                                signUp();
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
                              "CREATE",
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
