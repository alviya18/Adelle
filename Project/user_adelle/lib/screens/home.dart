import 'package:flutter/material.dart';
import 'package:user_adelle/components/home_calender.dart';
import 'package:user_adelle/periods.dart';
import 'package:user_adelle/screens/calenderpage.dart';
import 'package:user_adelle/screens/chatbot.dart';
import 'package:user_adelle/screens/mood.dart';
import 'package:user_adelle/screens/profile.dart';
import 'package:user_adelle/screens/statistics.dart';
import 'package:user_adelle/screens/symptom.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    HomePageContent(),
    AddMood(),
    AddSymptoms(),
    CycleStatistics(),
    Chatbot(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(81, 220, 1, 16),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildNavItem(Icons.home, 0),
            buildNavItem(Icons.mood, 1),
            buildNavItem(Icons.face_4, 2),
            buildNavItem(Icons.bar_chart_outlined, 3),
            buildNavItem(Icons.wechat_rounded, 4),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(IconData icon, int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          size: isSelected ? 30 : 20,
          color: isSelected ? Color(0xFFDC010E) : Colors.black,
        ),
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(81, 220, 1, 16),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/logo1.jpg', height: 45, width: 200),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                    ),
                    child: const Icon(Icons.account_circle_rounded,
                        size: 35, color: Color(0xFFDC010E)),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()));
                  },
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 5),
        HomeCalender()
        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (context) => PeriodPage()));
        //   },
        //   child: Text('Calender'),
        // ),
        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (context) => CalendarPage()));
        //   },
        //   child: Text('show Calender'),
        // ),
      ],
    );
  }
}
