import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_adelle/components/form_validation.dart';
import 'package:user_adelle/main.dart';
import 'package:user_adelle/screens/home.dart';
import 'package:user_adelle/screens/registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signIn() async {
    try {
      String email = emailController.text;
      String password = passwordController.text;

      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final User? user = res.user;
      if (user!.id.isNotEmpty) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
      }
    } catch (e) {
      print("Error Sign In: $e");
    }
  }

  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDC010E),
      resizeToAvoidBottomInset:
          false, // Prevents layout resizing when keyboard appears
      body: Stack(
        children: [
          SizedBox(
            height: 250,
            width: 500,
            child: Image(
              image: AssetImage("assets/userlogin4.webp"),
              fit: BoxFit.fitWidth,
            ),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage("assets/userlogin5.jpg"),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          SingleChildScrollView(
            // Wrap ListView inside SingleChildScrollView
            child: Form(
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: const Color.fromARGB(186, 250, 250, 250),
                      //     blurRadius: 20,
                      //     spreadRadius: 10,
                      //     offset: Offset(0, 5),
                      //   ),
                      // ],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 150,
                            child: Image(
                              image: AssetImage("assets/rmbglogo.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                          TextFormField(
                            validator: (value) =>
                                FormValidation.validateEmail(value),
                            style: GoogleFonts.diphylleia().copyWith(
                                color: const Color.fromARGB(255, 4, 4, 4),
                                fontSize: 14),
                            controller: emailController,
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
                                Icons.person_outline,
                                color: Color.fromARGB(255, 245, 60, 72),
                              ),
                              label: Text("username",
                                  style: GoogleFonts.diphylleia()),
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 245, 60, 72),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            validator: (value) =>
                                FormValidation.validatePassword(value),
                            style: GoogleFonts.diphylleia().copyWith(
                                color: const Color.fromARGB(221, 5, 5, 5),
                                fontSize: 14),
                            controller: passwordController,
                            obscureText: isObscure,
                            cursorColor: Color.fromARGB(255, 0, 0, 0),
                            decoration: InputDecoration(
                              // filled: true,
                              // fillColor: Color.fromARGB(255, 255, 255, 255),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 245, 60, 72),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 245, 60, 72),
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                color: Color.fromARGB(255, 245, 60, 72),
                              ),
                              label: Text("password",
                                  style: GoogleFonts.sortsMillGoudy()),
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 245, 60, 72),
                                fontSize: 13,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isObscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
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
                          SizedBox(height: 40),
                          SizedBox(
                            width: 400,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                signIn();
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
                                "LOGIN",
                                style: GoogleFonts.sortsMillGoudy().copyWith(
                                  color:
                                      const Color.fromARGB(221, 255, 255, 255),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Registration()));
                              },
                              child: Text(
                                "New User",
                                style: GoogleFonts.sortsMillGoudy().copyWith(
                                  color: Color.fromARGB(255, 245, 60, 72),
                                ),
                              )),
                          SizedBox(
                            height: 200,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
