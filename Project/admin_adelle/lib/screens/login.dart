import 'package:admin_adelle/components/form_validation.dart';
import 'package:admin_adelle/main.dart';
import 'package:admin_adelle/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  Future<void> signIn() async {
    try {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final User? user = res.user;

      if (user != null && user.id.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(),
          ),
        );
      } else {
        // Show error message if user is null
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Invalid email or password. Please try again.",
            style: GoogleFonts.quicksand().copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      // Show error message when exception occurs
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed to sign in. Check your credentials and try again.",
          style: GoogleFonts.quicksand().copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/adbg6.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Form(
          child: Center(
        child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: const Color.fromARGB(131, 0, 0, 0),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(36, 7, 7, 7),
                    blurRadius: 20,
                    spreadRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(20)),
            width: 400,
            height: 380,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome",
                    style: GoogleFonts.quicksand().copyWith(
                        color: const Color.fromARGB(221, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                        fontSize: 48)),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  style: GoogleFonts.quicksand().copyWith(
                      color: const Color.fromARGB(221, 255, 255, 255),
                      fontSize: 14),
                  validator: (value) => FormValidation.validateEmail(value),
                  controller: emailController,
                  cursorColor: Color.fromARGB(255, 255, 255, 255),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 255, 255, 255))),
                    // border: OutlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(133, 255, 255, 255))),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: const Color.fromARGB(133, 255, 255, 255),
                    ),
                    label: Text("username", style: GoogleFonts.quicksand()),
                    labelStyle: TextStyle(
                        color: const Color.fromARGB(133, 255, 255, 255),
                        fontSize: 13),
                  ),
                ),
                Sizedbox(),
                TextFormField(
                  style: GoogleFonts.quicksand().copyWith(
                      color: const Color.fromARGB(221, 255, 255, 255),
                      fontSize: 14),
                  validator: (value) => FormValidation.validatePassword(value),
                  controller: passwordController,
                  obscureText: isObscure,
                  cursorColor: Color.fromARGB(255, 255, 255, 255),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 255, 255, 255))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(133, 255, 255, 255))),
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: const Color.fromARGB(133, 255, 255, 255),
                    ),
                    label: Text("password", style: GoogleFonts.quicksand()),
                    labelStyle: TextStyle(
                        color: const Color.fromARGB(133, 255, 255, 255),
                        fontSize: 13),
                    suffixIcon: IconButton(
                        icon: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Color.fromARGB(133, 255, 255, 255),
                        ),
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        }),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 400,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      signIn();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(221, 240, 63, 63),
                        overlayColor: Color.fromARGB(255, 40, 41, 42),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2))),
                    child: Text(
                      "LOGIN",
                      style: GoogleFonts.quicksand().copyWith(
                        color: const Color.fromARGB(221, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                // GestureDetector(
                //   onTap: () {
                //     submit();
                //   },
                //   child: Container(
                //     width: 400,
                //     height: 35,
                //     decoration: BoxDecoration(
                //       color: const Color.fromARGB(255, 0, 125, 208),
                //       boxShadow: [
                //         BoxShadow(
                //           color: const Color.fromARGB(91, 0, 125, 208),
                //           blurRadius: 10,
                //           spreadRadius: 5,
                //           offset: Offset(0, 3),
                //         ),
                //       ],
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 25, vertical: 5),
                //       child: Text("LOGIN",
                //           textAlign: TextAlign.center,
                //           style: GoogleFonts.quicksand().copyWith(
                //             color: Color.fromARGB(133, 255, 255, 255),
                //             fontWeight: FontWeight.bold,
                //           )),
                //     ),
                //   ),
                // ),
              ],
            )),
      )),
    ));
  }
}

class Sizedbox extends StatelessWidget {
  const Sizedbox({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
    );
  }
}
