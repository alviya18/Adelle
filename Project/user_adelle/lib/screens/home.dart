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
  bool selectable = false;
  late CleanCalendarController calendarController;

  @override
  void initState() {
    super.initState();
    _initializeCalendarController();
  }

  void _initializeCalendarController() {
    calendarController = CleanCalendarController(
      rangeMode: false,
      readOnly: !selectable,
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 365)),
      onDayTapped: (date) {
        if (selectable) {
          print("Selected Date: $date");
        }
      },
      weekdayStart: DateTime.monday,
    );
  }

  void _toggleSelection() {
    setState(() {
      selectable = !selectable;
      _initializeCalendarController();
    });
  }

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
        Container(
          height: 610,
          margin: const EdgeInsets.all(12),
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.85),
          ),
          child: ScrollableCleanCalendar(
            daySelectedBackgroundColor: Color(0xFFDC010E),
            dayTextStyle: TextStyle(fontSize: 12),
            weekdayTextStyle: TextStyle(fontSize: 13),
            monthTextStyle: TextStyle(fontSize: 20),
            calendarController: calendarController,
            layout: Layout.BEAUTY,
            calendarCrossAxisSpacing: 0,
          ),
        ),
        GestureDetector(
          onTap: _toggleSelection,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 35),
              margin: EdgeInsets.symmetric(vertical: 1, horizontal: 15),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(2, 4),
                  ),
                ],
                color: selectable ? Color(0xFFDC010E) : Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                selectable ? "Edit Period" : "Mark Period",
                style: TextStyle(
                    color: selectable ? Colors.white : Color(0xFFDC010E)),
              ),
            ),
          ),
        )
      ],
    );
  }
}
