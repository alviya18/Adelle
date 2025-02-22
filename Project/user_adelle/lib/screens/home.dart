import 'package:flutter/material.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/userlogin4.webp",
              fit: BoxFit.cover,
            ),
          ),

          // Semi-transparent Overlay for better contrast
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),

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
                      horizontal: 18.0, vertical: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Image.asset('assets/logo1.jpg', height: 40, width: 200),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: 150,
                margin: const EdgeInsets.all(12),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [],
                    ),
                    Image.asset('assets/test.png'),
                  ],
                ),
              ),
              // Calendar Container
              Container(
                height: 450,
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
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                  buildNavItem(Icons.home, 0),
                  buildNavItem(Icons.mood, 1),
                  buildNavItem(Icons.face_3, 2),
                  buildNavItem(Icons.wechat_rounded, 3),
                  buildNavItem(Icons.person_sharp, 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Navigation Item
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
          color: isSelected
              ? Color(0xFFDC010E)
              : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }
}
