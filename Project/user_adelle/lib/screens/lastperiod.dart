import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';
import 'package:user_adelle/screens/home.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:intl/intl.dart';

class Lastperiod extends StatefulWidget {
  const Lastperiod({super.key});

  @override
  State<Lastperiod> createState() => _LastperiodState();
}

class _LastperiodState extends State<Lastperiod> {
  DateTime _selectedDate = DateTime.now(); // Default to today's date

  void _updateLastPeriod() async {
    try {
      String userId = supabase.auth.currentUser!.id;

      await supabase.from('tbl_user').update({
        'user_lastPeriod': DateFormat('yyyy-MM-dd').format(_selectedDate),
      }).eq('user_id', userId);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEADER IMAGE
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(50)),
                color: const Color(0xFFDC010E),
                image: DecorationImage(
                  image: AssetImage("assets/userlogin4.webp"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 40),

            // TITLE
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "When's your last period?",
                style: GoogleFonts.sortsMillGoudy().copyWith(
                  color: Color(0xFFDC010E),
                  fontSize: 24,
                ),
              ),
            ),

            SizedBox(height: 10),

            // CALENDAR DISPLAY
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    height: 400,
                    child: CalendarCarousel(
                      maxSelectedDate: DateTime.now(), // Restrict future dates
                      onDayPressed: (DateTime date, List events) {
                        if (date
                            .isBefore(DateTime.now().add(Duration(days: 1)))) {
                          // Ensure it's not a future date
                          setState(() {
                            _selectedDate = date;
                          });
                        }
                      },
                      selectedDateTime: _selectedDate,
                      weekendTextStyle: TextStyle(
                        color: Colors.red,
                      ),
                      selectedDayBorderColor: Colors.transparent,
                      thisMonthDayBorderColor: Colors.grey,
                      selectedDayButtonColor: Color(0xFFDC010E),
                      selectedDayTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      daysHaveCircularBorder: false,
                      showHeaderButton: true,
                      customDayBuilder: (bool isSelectable,
                          int index,
                          bool isSelectedDay,
                          bool isToday,
                          bool isPrevMonthDay,
                          TextStyle textStyle,
                          bool isNextMonthDay,
                          bool isThisMonthDay,
                          DateTime day) {
                        if (day.isAfter(DateTime.now())) {
                          // Disable future dates
                          return Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                  color: Colors.grey), // Grey out future dates
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 70),

            // FINISH BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  _updateLastPeriod();
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
                  "FINISH",
                  style: GoogleFonts.sortsMillGoudy().copyWith(
                    color: const Color.fromARGB(221, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            
          ],
        ),
      ),
    );
  }
}
