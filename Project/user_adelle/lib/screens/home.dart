import 'package:flutter/material.dart';

import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
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
  final calendarController = CleanCalendarController(
    minDate: DateTime.now(),
    maxDate: DateTime.now().add(const Duration(days: 365)),
    onRangeSelected: (firstDate, secondDate) {},
    onDayTapped: (date) {},
    onPreviousMinDateTapped: (date) {},
    onAfterMaxDateTapped: (date) {},
    weekdayStart: DateTime.monday,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 220, 1, 16),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              // "assets/userlogin4.webp",
              'assets/test.png',
              fit: BoxFit.scaleDown,
            ),
          ),

          // Semi-transparent Overlay for better contrast
          // Positioned.fill(
          //   child: Container(
          //     color: Colors.black.withOpacity(0.2),
          //   ),
          // ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with Logo
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: const BorderRadius.only(
                  //   bottomLeft: Radius.circular(40),
                  //   bottomRight: Radius.circular(40),
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(81, 220, 1, 16),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 25),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset('assets/logo1.jpg',
                              height: 45, width: 200),
                          GestureDetector(
                            child: const Icon(Icons.person_outline_rounded,
                                size: 35, color: Color(0xFFDC010E)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Profile()));
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),

              // Calendar Container
              Container(
                height: 610,
                margin: const EdgeInsets.all(12),
                padding: EdgeInsetsDirectional.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.85),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.white,
                  //     blurRadius: 10,
                  //     spreadRadius: 2,
                  //   ),
                  // ],
                ),
                child: ScrollableCleanCalendar(
                  dayTextStyle: TextStyle(fontSize: 12),
                  weekdayTextStyle: TextStyle(fontSize: 13),
                  monthTextStyle: TextStyle(fontSize: 20),
                  calendarController: calendarController,
                  layout: Layout.BEAUTY,
                  calendarCrossAxisSpacing: 0,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 35),
                    margin: EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Text("Mark Period"),
                  ),
                ),
              )
            ],
          ),

          // Bottom Navigation Bar - Positioned at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white, // Semi-transparent
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(40)),
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
                  buildNavItem(Icons.home, 0, HomePage()),
                  buildNavItem(Icons.mood, 1, AddMood()),
                  buildNavItem(Icons.face_3, 2, AddSymptoms()),
                  buildNavItem(Icons.bar_chart_outlined, 3, CycleStatistics()),
                  buildNavItem(Icons.wechat_rounded, 4, Chatbot()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Navigation Item
  Widget buildNavItem(IconData icon, int index, Widget destinationPage) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          size: isSelected ? 30 : 20,
          color: isSelected
              ? Color(0xFFDC010E)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }
}
