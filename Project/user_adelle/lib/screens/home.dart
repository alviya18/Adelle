import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/rmbglogo1.png"),
                )),
              )
            ],
          ),
        ),
        body: Center()
        // Container(
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage(
        //           'assets/userlogin4.webp'), // Your background image
        //       fit: BoxFit.cover, // Makes the image cover the entire screen
        //     ),
        //   ),

        );
  }
}
