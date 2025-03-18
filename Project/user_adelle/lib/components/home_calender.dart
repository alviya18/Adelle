import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/models/day_values_model.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:user_adelle/main.dart';

class HomeCalender extends StatefulWidget {
  const HomeCalender({super.key});

  @override
  State<HomeCalender> createState() => _HomeCalenderState();
}

class _HomeCalenderState extends State<HomeCalender> {
  bool selectable = false;
  late CleanCalendarController calendarController;
  DateTime? startDate; // Stores start of period
  DateTime? endDate; // Stores end of period
  int cycleDuration = 4; // Default duration in days

  // List to store all historical periods
  List<Map<String, dynamic>> historicalPeriods = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Load user data including cycle duration
  }

  Future<void> _fetchUserData() async {
    try {
      final user = await supabase
          .from('tbl_user')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .single();

      setState(() {
        cycleDuration = user['user_cycleDuration'] ?? 4;

        if (user['user_lastPeriod'] != null) {
          startDate = DateTime.parse(user['user_lastPeriod']);
          // Calculate end date based on cycle duration
          endDate = startDate!.add(Duration(days: cycleDuration - 1));
        }
      });

      // Fetch ALL historical periods from tbl_cycleDates
      final periods = await supabase
          .from('tbl_cycleDates')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('cycleDate_start', ascending: false);

      if (periods.isNotEmpty) {
        setState(() {
          historicalPeriods = List<Map<String, dynamic>>.from(periods);

          // Set the most recent period as the current one
          if (periods.isNotEmpty) {
            startDate = DateTime.parse(periods[0]['cycleDate_start']);
            endDate = DateTime.parse(periods[0]['cycleDate_end']);
          }
        });
      }

      _initializeCalendarController(); // Initialize controller after fetching data
    } catch (e) {
      print("Error fetching user data: $e");
      _initializeCalendarController(); // Initialize anyway to avoid errors
    }
  }

  // Check if a date is within any historical period
  bool isHistoricalPeriodDate(DateTime date) {
    final dateString = DateFormat('yyyy-MM-dd').format(date);

    for (var period in historicalPeriods) {
      final startDate = DateTime.parse(period['cycleDate_start']);
      final endDate = DateTime.parse(period['cycleDate_end']);

      if (date.isAtSameMomentAs(startDate) ||
          date.isAtSameMomentAs(endDate) ||
          (date.isAfter(startDate) && date.isBefore(endDate))) {
        return true;
      }
    }

    return false;
  }

  void _initializeCalendarController() {
    calendarController = CleanCalendarController(
      rangeMode: true, // Enable range selection
      readOnly: !selectable,
      minDate: DateTime.now()
          .subtract(const Duration(days: 365)), // Allow selecting past dates
      maxDate: DateTime.now().add(const Duration(days: 365)),
      initialDateSelected: startDate, // Set stored start date
      endDateSelected: endDate, // Set stored end date
      onRangeSelected: (start, end) {
        if (selectable && start != null) {
          // Calculate the end date based on cycle duration
          final calculatedEndDate =
              start.add(Duration(days: cycleDuration - 1));

          setState(() {
            startDate = start;
            endDate = calculatedEndDate;
          });

          // We need to reinitialize the controller with the new dates
          _reinitializeController();
        }
      },
      weekdayStart: DateTime.monday,
    );
    setState(() {}); // Rebuild widget after initializing controller
  }

  // Reinitialize the controller to update the date range
  void _reinitializeController() {
    calendarController = CleanCalendarController(
      rangeMode: true,
      readOnly: !selectable,
      minDate: DateTime.now().subtract(const Duration(days: 365)),
      maxDate: DateTime.now().add(const Duration(days: 365)),
      initialDateSelected: startDate,
      endDateSelected: endDate,
      onRangeSelected: (start, end) {
        if (selectable && start != null) {
          final calculatedEndDate =
              start.add(Duration(days: cycleDuration - 1));

          setState(() {
            startDate = start;
            endDate = calculatedEndDate;
          });

          _reinitializeController();
        }
      },
      weekdayStart: DateTime.monday,
    );

    // Force rebuild
    setState(() {});
  }

  void _toggleSelection() {
    setState(() {
      selectable = !selectable;
    });

    _initializeCalendarController();

    // If we're exiting selection mode, save the period
    if (!selectable && startDate != null && endDate != null) {
      _savePeriodToDB();
    }
  }

  Future<void> _savePeriodToDB() async {
    if (startDate != null && endDate != null) {
      try {
        // Update the last period in tbl_user
        await supabase.from('tbl_user').update({
          'user_lastPeriod': DateFormat('yyyy-MM-dd').format(startDate!),
        }).eq('user_id', supabase.auth.currentUser!.id);

        // Get the month number for the cycleDate_month field
        final month = startDate!.month;

        // Insert the new period into tbl_cycleDates
        await supabase.from('tbl_cycleDates').insert({
          'cycleDate_start': DateFormat('yyyy-MM-dd').format(startDate!),
          'cycleDate_end': DateFormat('yyyy-MM-dd').format(endDate!),
          'user_id': supabase.auth.currentUser!.id,
          'cycleDate_month': month.toString(),
        });

        // Add the new period to our historical periods list
        setState(() {
          historicalPeriods.insert(0, {
            'cycleDate_start': DateFormat('yyyy-MM-dd').format(startDate!),
            'cycleDate_end': DateFormat('yyyy-MM-dd').format(endDate!),
            'user_id': supabase.auth.currentUser!.id,
            'cycleDate_month': month.toString(),
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Period dates saved successfully')),
        );
      } catch (e) {
        print("Error saving period: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving period dates')),
        );
      }
    }
  }

  // Custom day widget builder to show historical periods
  // Custom day widget builder to show historical periods
  Widget _buildDayWidget(BuildContext context, DayValues dayValues) {
    final date = dayValues
        .day; // Use 'day' instead of 'date', assuming this is the property name
    bool isSelected = false;
    bool isInRange = false;

    // Check if date is in current selection
    if (startDate != null && endDate != null) {
      isSelected =
          date.isAtSameMomentAs(startDate!) || date.isAtSameMomentAs(endDate!);
      isInRange = date.isAfter(startDate!) && date.isBefore(endDate!);
    }

    // Check if date is in any historical period
    bool isHistorical = isHistoricalPeriodDate(date);

    // Default day style
    final dayStyle = TextStyle(
      fontSize: 12,
      color: isSelected || isInRange ? Colors.white : Colors.black,
    );

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isSelected || isInRange
            ? const Color(0xFFDC010E)
            : isHistorical
                ? const Color(0xFFFFCCCE) // Light red for historical periods
                : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          date.day.toString(),
          style: dayStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 550,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.85),
          ),
          child: calendarController != null
              ? ScrollableCleanCalendar(
                  daySelectedBackgroundColor: const Color(0xFFDC010E),
                  dayTextStyle: const TextStyle(fontSize: 12),
                  weekdayTextStyle: const TextStyle(fontSize: 13),
                  monthTextStyle: const TextStyle(fontSize: 20),
                  calendarController: calendarController,
                  layout: Layout.BEAUTY,
                  calendarCrossAxisSpacing: 0,
                  dayBuilder: _buildDayWidget, // Pass the updated function here
                )
              : const Center(child: CircularProgressIndicator()),
        ),
        if (startDate != null && endDate != null && !selectable)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today,
                    color: Color(0xFFDC010E), size: 18),
                const SizedBox(width: 8),
                Text(
                  'Last Period: ${DateFormat('MMM dd').format(startDate!)} - ${DateFormat('MMM dd').format(endDate!)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _toggleSelection,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 35),
              margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(2, 4),
                  ),
                ],
                color: selectable ? const Color(0xFFDC010E) : Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                selectable ? "Save Period" : "Mark Period",
                style: TextStyle(
                  color: selectable ? Colors.white : const Color(0xFFDC010E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
