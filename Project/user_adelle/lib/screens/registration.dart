import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  void signUp() {}
  bool isObscure = true;
  bool hello = true;
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
                            style: GoogleFonts.diphylleia().copyWith(
                                color: const Color.fromARGB(255, 4, 4, 4),
                                fontSize: 14),
                            controller: emailID,
                            cursorColor: Color.fromARGB(255, 7, 7, 7),
                            decoration: InputDecoration(
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
                            style: GoogleFonts.diphylleia().copyWith(
                                color: const Color.fromARGB(255, 4, 4, 4),
                                fontSize: 14),
                            controller: pass,
                            obscureText: isObscure,
                            cursorColor: Color.fromARGB(255, 7, 7, 7),
                            decoration: InputDecoration(
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
                            style: GoogleFonts.diphylleia().copyWith(
                                color: const Color.fromARGB(255, 4, 4, 4),
                                fontSize: 14),
                            controller: confirmpass,
                            obscureText: hello,
                            cursorColor: Color.fromARGB(255, 7, 7, 7),
                            decoration: InputDecoration(
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Agree()));
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
