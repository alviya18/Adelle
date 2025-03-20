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
  DateTime? startDate;
  DateTime? endDate;
  DateTime? nextCycleStart;
  DateTime? nextCycleEnd;
  DateTime? ovStart;
  DateTime? ovPeak;
  DateTime? ovEnd;

  int cycleDuration = 4;
  int cycleLength = 28;

  List<Map<String, dynamic>> cycleHistory = [];
  List<Map<String, dynamic>> ovulationHistory = [];

  @override
  void initState() {
    super.initState();
    calendarController = CleanCalendarController(
      rangeMode: true,
      readOnly: !selectable,
      minDate: DateTime(2024, 1, 1),
      maxDate: DateTime(2026, 12, 31),
      initialFocusDate: DateTime.now(),
      weekdayStart: DateTime.sunday,
    );
    _fetchUserDataAndPredict();
  }

  Future<void> _fetchUserDataAndPredict() async {
    try {
      final user = await supabase
          .from('tbl_user')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .single();

      final periods = await supabase
          .from('tbl_cycleDates')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('cycleDate_start', ascending: false);

      final ovulation = await supabase
          .from('tbl_ovulationCycle')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('ovulationCycle_peakDate', ascending: false);

      setState(() {
        cycleDuration = user['user_cycleDuration'] ?? 4;
        cycleLength = user['user_cycleLength'] ?? 28;
        cycleHistory = List<Map<String, dynamic>>.from(periods);
        ovulationHistory = List<Map<String, dynamic>>.from(ovulation);

        if (cycleHistory.isNotEmpty) {
          startDate = DateTime.parse(cycleHistory[0]['cycleDate_start']).toLocal();
          endDate = DateTime.parse(cycleHistory[0]['cycleDate_end']).toLocal();
        } else if (user['user_lastPeriod'] != null) {
          startDate = DateTime.parse(user['user_lastPeriod']).toLocal();
          endDate = startDate!.add(Duration(days: cycleDuration - 1));
          cycleHistory.add({
            'cycleDate_start': DateFormat('yyyy-MM-dd').format(startDate!),
            'cycleDate_end': DateFormat('yyyy-MM-dd').format(endDate!),
            'user_id': supabase.auth.currentUser!.id,
            'cycleDate_month': startDate!.month,
          });
        }

        if (startDate != null) {
          nextCycleStart = startDate!.add(Duration(days: cycleLength));
          nextCycleEnd = nextCycleStart!.add(Duration(days: cycleDuration - 1));
          ovPeak = nextCycleStart!.subtract(Duration(days: 14));
          ovStart = ovPeak!.subtract(Duration(days: 5));
          ovEnd = ovPeak!.add(Duration(days: 1));
        }

        print('Last Period: $startDate - $endDate');
        print('Predicted Cycle: $nextCycleStart - $nextCycleEnd');
        print('Predicted Ovulation: $ovStart - $ovEnd (Peak: $ovPeak)');
        print('Cycle History: $cycleHistory');
      });

      _initializeCalendarController();
    } catch (e) {
      print("Error fetching data: $e");
      _initializeCalendarController();
    }
  }

  void _initializeCalendarController() {
    calendarController = CleanCalendarController(
      rangeMode: true,
      readOnly: !selectable,
      minDate: DateTime(2024, 1, 1),
      maxDate: DateTime(2026, 12, 31),
      initialDateSelected: selectable ? null : startDate,
      endDateSelected: selectable ? null : endDate,
      initialFocusDate: startDate ?? DateTime(2025, 5, 1),
      onRangeSelected: (start, end) {
        if (selectable && start != null) {
          final calculatedEndDate = start.add(Duration(days: cycleDuration - 1));
          setState(() {
            startDate = start;
            endDate = calculatedEndDate; // Auto-set end date
          });
          _reinitializeController();
        }
      },
      weekdayStart: DateTime.monday,
    );
    setState(() {});
  }

  void _reinitializeController() {
    calendarController = CleanCalendarController(
      rangeMode: true,
      readOnly: !selectable,
      minDate: DateTime(2024, 1, 1),
      maxDate: DateTime(2026, 12, 31),
      initialDateSelected: selectable ? null : startDate,
      endDateSelected: selectable ? null : endDate,
      initialFocusDate: startDate ?? DateTime(2025, 5, 1),
      onRangeSelected: (start, end) {
        if (selectable && start != null) {
          final calculatedEndDate = start.add(Duration(days: cycleDuration - 1));
          setState(() {
            startDate = start;
            endDate = calculatedEndDate;
          });
          _reinitializeController();
        }
      },
      weekdayStart: DateTime.monday,
    );
    setState(() {});
  }

  Future<void> _editEndDate() async {
    if (startDate == null) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? startDate!.add(Duration(days: cycleDuration - 1)),
      firstDate: startDate!, // End date must be on or after start date
      lastDate: DateTime(2026, 12, 31),
      helpText: 'Select End Date of Period',
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
      _reinitializeController();
    }
  }

  void _cancelSelection() {
    setState(() {
      selectable = false;
      startDate = cycleHistory.isNotEmpty
          ? DateTime.parse(cycleHistory[0]['cycleDate_start']).toLocal()
          : null;
      endDate = cycleHistory.isNotEmpty
          ? DateTime.parse(cycleHistory[0]['cycleDate_end']).toLocal()
          : null;
    });
    _initializeCalendarController();
  }

  Future<void> _savePeriodToDB() async {
    if (startDate != null && endDate != null) {
      try {
        await supabase.from('tbl_user').update({
          'user_lastPeriod': DateFormat('yyyy-MM-dd').format(startDate!),
        }).eq('user_id', supabase.auth.currentUser!.id);

        final month = startDate!.month;
        await supabase.from('tbl_cycleDates').insert({
          'cycleDate_start': DateFormat('yyyy-MM-dd').format(startDate!),
          'cycleDate_end': DateFormat('yyyy-MM-dd').format(endDate!),
          'user_id': supabase.auth.currentUser!.id,
          'cycleDate_month': month,
        });

        cycleDuration = endDate!.difference(startDate!).inDays + 1;

        nextCycleStart = startDate!.add(Duration(days: cycleLength));
        nextCycleEnd = nextCycleStart!.add(Duration(days: cycleDuration - 1));
        ovPeak = nextCycleStart!.subtract(Duration(days: 14));
        ovStart = ovPeak!.subtract(Duration(days: 5));
        ovEnd = ovPeak!.add(Duration(days: 1));

        await supabase.from('tbl_ovulationCycle').insert({
          'ovulationCycle_start': DateFormat('yyyy-MM-dd').format(ovStart!),
          'ovulationCycle_end': DateFormat('yyyy-MM-dd').format(ovEnd!),
          'ovulationCycle_peakDate': DateFormat('yyyy-MM-dd').format(ovPeak!),
          'ovulationCycle_month': nextCycleStart!.month,
          'user_id': supabase.auth.currentUser!.id,
        });

        setState(() {
          cycleHistory.insert(0, {
            'cycleDate_start': DateFormat('yyyy-MM-dd').format(startDate!),
            'cycleDate_end': DateFormat('yyyy-MM-dd').format(endDate!),
            'user_id': supabase.auth.currentUser!.id,
            'cycleDate_month': month,
          });
          ovulationHistory.insert(0, {
            'ovulationCycle_start': DateFormat('yyyy-MM-dd').format(ovStart!),
            'ovulationCycle_end': DateFormat('yyyy-MM-dd').format(ovEnd!),
            'ovulationCycle_peakDate': DateFormat('yyyy-MM-dd').format(ovPeak!),
            'ovulationCycle_month': nextCycleStart!.month,
            'user_id': supabase.auth.currentUser!.id,
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Period and ovulation saved successfully')),
        );
      } catch (e) {
        print("Error saving period: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving period dates')),
        );
      }
    }
  }

  void _toggleSelection() {
    setState(() {
      selectable = !selectable;
    });
    _initializeCalendarController();
    if (!selectable && startDate != null && endDate != null) {
      _savePeriodToDB();
    }
  }

  bool _isDateInRange(DateTime date, DateTime? start, DateTime? end) {
    if (start == null || end == null) return false;
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    DateTime normalizedStart = DateTime(start.year, start.month, start.day);
    DateTime normalizedEnd = DateTime(end.year, end.month, end.day);
    return normalizedDate.isAtSameMomentAs(normalizedStart) ||
        normalizedDate.isAtSameMomentAs(normalizedEnd) ||
        (normalizedDate.isAfter(normalizedStart) && normalizedDate.isBefore(normalizedEnd));
  }

  Widget _buildDayWidget(BuildContext context, DayValues dayValues) {
    final date = dayValues.day;
    final today = DateTime.now();
    final isToday = date.year == today.year && date.month == today.month && date.day == today.day;

    bool isSelected = false;
    bool isInRange = false;

    if (selectable && startDate != null && endDate != null) {
      isSelected = _isDateInRange(date, startDate, endDate);
      isInRange = isSelected;
      if (isSelected) print('Selected Date: $date');
    }

    bool isHistoricalCycle = false;
    for (var period in cycleHistory) {
      final start = DateTime.parse(period['cycleDate_start']).toLocal();
      final end = DateTime.parse(period['cycleDate_end']).toLocal();
      if (_isDateInRange(date, start, end)) {
        isHistoricalCycle = true;
        print('Historical Cycle Date: $date');
        break;
      }
    }

    bool isOvulationWindow = false;
    bool isOvulationPeak = false;
    for (var ovulation in ovulationHistory) {
      final start = DateTime.parse(ovulation['ovulationCycle_start']).toLocal();
      final end = DateTime.parse(ovulation['ovulationCycle_end']).toLocal();
      final peak = DateTime.parse(ovulation['ovulationCycle_peakDate']).toLocal();
      if (_isDateInRange(date, start, end)) {
        isOvulationWindow = true;
        if (date.isAtSameMomentAs(peak)) {
          isOvulationPeak = true;
          print('Ovulation Peak Date: $date');
        } else {
          print('Ovulation Window Date: $date');
        }
        break;
      }
    }

    bool isPredictedCycle = _isDateInRange(date, nextCycleStart, nextCycleEnd);
    if (isPredictedCycle) print('Predicted Cycle Date: $date');

    bool isPredictedOvulation = _isDateInRange(date, ovStart, ovEnd);
    bool isPredictedOvulationPeak = ovPeak != null && date.isAtSameMomentAs(ovPeak!);
    if (isPredictedOvulation) {
      if (isPredictedOvulationPeak) {
        print('Predicted Ovulation Peak Date: $date');
      } else {
        print('Predicted Ovulation Date: $date');
      }
    }

    Color? backgroundColor;
    BoxDecoration decoration;

    if (isSelected || isInRange) {
      backgroundColor = Colors.red; // Solid red for current selection
    } else if (isPredictedOvulationPeak) {
      backgroundColor = Colors.green; // Solid green for predicted ovulation peak
    } else if (isPredictedOvulation) {
      backgroundColor = Colors.green.withOpacity(0.3); // Light green for predicted ovulation
    } else if (isPredictedCycle) {
      backgroundColor = Colors.orange.withOpacity(0.5); // Orange for predicted period
    } else if (isHistoricalCycle) {
      backgroundColor = Colors.redAccent.withOpacity(0.7); // Bright red for historical periods
    } else if (isOvulationPeak) {
      backgroundColor = Colors.purple; // Solid purple for ovulation peak
    } else if (isOvulationWindow) {
      backgroundColor = Colors.purple.withOpacity(0.3); // Light purple for ovulation window
    }

    decoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(4),
      border: isToday ? Border.all(color: Colors.black, width: 2) : null,
    );

    final dayStyle = TextStyle(
      fontSize: 12,
      color: (isSelected || isInRange || isOvulationPeak || isPredictedOvulationPeak) ? Colors.white : Colors.black,
    );

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: decoration,
      child: Center(
        child: Text(
          date.day.toString(),
          style: dayStyle,
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _legendItem(Colors.red, 'Current Selection'),
          _legendItem(Colors.redAccent.withOpacity(0.7), 'Historical Period'),
          _legendItem(Colors.purple, 'Ovulation Peak'),
          _legendItem(Colors.purple.withOpacity(0.3), 'Ovulation Window'),
          _legendItem(Colors.orange.withOpacity(0.5), 'Predicted Period'),
          _legendItem(Colors.green, 'Predicted Ovulation Peak'),
          _legendItem(Colors.green.withOpacity(0.3), 'Predicted Ovulation'),
          _legendItem(null, 'Today (Black Border)'),
        ],
      ),
    );
  }

  Widget _legendItem(Color? color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: color == null ? Border.all(color: Colors.black, width: 2) : null,
            ),
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 300,
          margin: const EdgeInsets.symmetric( horizontal: 12),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.85),
          ),
          child: ScrollableCleanCalendar(
            daySelectedBackgroundColor: Colors.red,
            dayTextStyle: const TextStyle(fontSize: 12),
            weekdayTextStyle: const TextStyle(fontSize: 13),
            monthTextStyle: const TextStyle(fontSize: 20),
            calendarController: calendarController,
            layout: Layout.BEAUTY,
            calendarCrossAxisSpacing: 0,
            dayBuilder: _buildDayWidget,
          ),
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
                const Icon(Icons.calendar_today, color: Colors.red, size: 18),
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
        _buildLegend(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (selectable && startDate != null && endDate != null)
              GestureDetector(
                onTap: _editEndDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Edit End Date",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            GestureDetector(
              onTap: _toggleSelection,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 35),
                margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(2, 4),
                    ),
                  ],
                  color: selectable ? Colors.red : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: selectable ? Icon(Icons.save, color: Colors.white) :
                Text("Mark Period",
                  style: TextStyle(
                    color: selectable ? Colors.white : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (selectable)
              GestureDetector(
                onTap: _cancelSelection,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
          ],
        ),
      ],
    );
  }
}