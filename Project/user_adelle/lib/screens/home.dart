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
  bool selectable = false; // Initially, selection is disabled
  late CleanCalendarController calendarController;

  @override
  void initState() {
    super.initState();
    _initializeCalendarController();
  }

  void _initializeCalendarController() {
    calendarController = CleanCalendarController(
      rangeMode: false,
      readOnly: !selectable, // If selectable is true, readOnly should be false
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 365)),
      onDayTapped: (date) {
        if (selectable) {
          print("Selected Date: $date"); // You can store this if needed
        }
      },

      weekdayStart: DateTime.monday,
    );
  }

  void _toggleSelection() {
    setState(() {
      selectable = !selectable; // Toggle selection state
      _initializeCalendarController(); // Reinitialize the calendar controller
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/whitebg.webp', fit: BoxFit.cover),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with Logo
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

              // Mark Period Button
              GestureDetector(
                onTap: _toggleSelection, // Toggle selection mode
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 35),
                    margin: EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 1, // Spread radius
                            blurRadius: 5, // Blur radius
                            offset: Offset(
                                2, 4), // Changes position of shadow (x, y)
                          ),
                        ],
                        color: selectable
                            ? Colors.red
                            : Colors.white, // Color changes when active
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      selectable ? "Select Date" : "Mark Period",
                      style: TextStyle(color: Color(0xFFDC010E)),
                    ),
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
                color: Colors.white,
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
