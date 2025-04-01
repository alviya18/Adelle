import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:user_adelle/main.dart'; // Assuming supabase is initialized here

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  DateTime? lastCycleStart;
  DateTime? lastCycleEnd;
  DateTime? nextCycleStart;
  DateTime? nextCycleEnd;
  DateTime? ovStart;
  DateTime? ovPeak;
  DateTime? ovEnd;

  List<Map<String, dynamic>> cycleHistory = [];
  List<Map<String, dynamic>> ovulationHistory = [];

  @override
  void initState() {
    super.initState();
    predictCycles();
    fetchCycleHistory();
  }

  Future<void> predictCycles() async {
    try {
      final user = await supabase
          .from('tbl_user')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .single();
      final lastCycleResponse = await supabase
          .from('tbl_cycleDates')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('cycleDate_end', ascending: false)
          .limit(1);

      int cycleLength = user['user_cycleLength'];
      int cycleDuration = user['user_cycleDuration'];

      DateTime lastStart;
      DateTime lastEnd;

      if (lastCycleResponse.isNotEmpty) {
        final lastCycle = lastCycleResponse[0];
        lastStart = DateTime.parse(lastCycle['cycleDate_start']).toLocal();
        lastEnd = DateTime.parse(lastCycle['cycleDate_end']).toLocal();
        print('Last Cycle from tbl_cycleDates: Start $lastStart, End $lastEnd');
      } else {
        lastStart = DateTime.parse(user['user_lastPeriod']).toLocal();
        lastEnd = lastStart.add(Duration(days: cycleDuration - 1));
        print('Last Cycle from tbl_user: Start $lastStart, End $lastEnd');
      }

      DateTime predictedNextStart = lastStart.add(Duration(days: cycleLength));
      DateTime predictedNextEnd =
          predictedNextStart.add(Duration(days: cycleDuration - 1));
      DateTime predictedOvPeak =
          predictedNextStart.subtract(Duration(days: 14));
      DateTime predictedOvStart = predictedOvPeak.subtract(Duration(days: 5));
      DateTime predictedOvEnd = predictedOvPeak.add(Duration(days: 1));

      setState(() {
        lastCycleStart = lastStart;
        lastCycleEnd = lastEnd;
        nextCycleStart = predictedNextStart;
        nextCycleEnd = predictedNextEnd;
        ovStart = predictedOvStart;
        ovPeak = predictedOvPeak;
        ovEnd = predictedOvEnd;
      });

      print('Predicted Next Cycle: Start $nextCycleStart, End $nextCycleEnd');
      print('Predicted Ovulation: Start $ovStart, Peak $ovPeak, End $ovEnd');
    } catch (e) {
      print('Error predicting cycles: $e');
    }
  }

  Future<void> fetchCycleHistory() async {
    try {
      final cycleResponse = await supabase
          .from('tbl_cycleDates')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('cycleDate_start', ascending: false);

      final ovulationResponse = await supabase
          .from('tbl_ovulationCycle')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('ovulationCycle_peakDate', ascending: false);

      setState(() {
        cycleHistory = List<Map<String, dynamic>>.from(cycleResponse);
        ovulationHistory = List<Map<String, dynamic>>.from(ovulationResponse);
      });

      print('Cycle History: $cycleHistory');
      print('Ovulation History: $ovulationHistory');
    } catch (e) {
      print('Error fetching history: $e');
    }
  }

  Future<void> addCycle(DateTime startDate) async {
    try {
      final user = await supabase
          .from('tbl_user')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .single();
      int cycleDuration = user['user_cycleDuration'];
      int cycleLength = user['user_cycleLength'];

      DateTime endDate = startDate.add(Duration(days: cycleDuration - 1));
      await supabase.from('tbl_cycleDates').upsert([
        {
          'user_id': supabase.auth.currentUser!.id,
          'cycleDate_start': startDate.toIso8601String(),
          'cycleDate_end': endDate.toIso8601String(),
          'cycleDate_month': startDate.month,
        }
      ]);

      DateTime nextStart = startDate.add(Duration(days: cycleLength));
      DateTime nextEnd = nextStart.add(Duration(days: cycleDuration - 1));
      DateTime ovPeak = nextStart.subtract(Duration(days: 14));
      DateTime ovStartDay = ovPeak.subtract(Duration(days: 5));
      DateTime ovEndDay = ovPeak.add(Duration(days: 1));

      await supabase.from('tbl_ovulationCycle').insert({
        'ovulationCycle_start': ovStartDay.toIso8601String(),
        'ovulationCycle_end': ovEndDay.toIso8601String(),
        'ovulationCycle_peakDate': ovPeak.toIso8601String(),
        'ovulationCycle_month': nextStart.month,
      });

      setState(() {
        lastCycleStart = startDate;
        lastCycleEnd = endDate;
        nextCycleStart = nextStart;
        nextCycleEnd = nextEnd;
        ovStart = ovStartDay;
        ovPeak = ovPeak;
        ovEnd = ovEndDay;
      });

      await fetchCycleHistory();
      await predictCycles();
    } catch (e) {
      print('Error adding cycle: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save cycle: $e')),
      );
    }
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      await addCycle(picked);
      setState(() {
        _selectedDay = picked;
        _focusedDay = picked; // Focus on the selected month
      });
    }
  }

  List<String> _getEventsForDay(DateTime day) {
    List<String> events = [];
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);

    // Add cycle history
    for (var cycle in cycleHistory) {
      DateTime start = DateTime.parse(cycle['cycleDate_start']).toLocal();
      DateTime end = DateTime.parse(cycle['cycleDate_end']).toLocal();
      for (DateTime d = start;
          d.isBefore(end.add(Duration(days: 1)));
          d = d.add(Duration(days: 1))) {
        DateTime normalizedD = DateTime(d.year, d.month, d.day);
        if (isSameDay(normalizedD, normalizedDay)) {
          events.add('Menstrual Cycle');
        }
      }
    }

    // Add ovulation history
    for (var ovulation in ovulationHistory) {
      DateTime start =
          DateTime.parse(ovulation['ovulationCycle_start']).toLocal();
      DateTime end = DateTime.parse(ovulation['ovulationCycle_end']).toLocal();
      DateTime peak =
          DateTime.parse(ovulation['ovulationCycle_peakDate']).toLocal();
      for (DateTime d = start;
          d.isBefore(end.add(Duration(days: 1)));
          d = d.add(Duration(days: 1))) {
        DateTime normalizedD = DateTime(d.year, d.month, d.day);
        if (isSameDay(normalizedD, normalizedDay)) {
          events.add(isSameDay(normalizedD, peak)
              ? 'Ovulation Peak'
              : 'Ovulation Window');
        }
      }
    }

    // Add predicted upcoming cycle
    if (nextCycleStart != null && nextCycleEnd != null) {
      for (DateTime d = nextCycleStart!;
          d.isBefore(nextCycleEnd!.add(Duration(days: 1)));
          d = d.add(Duration(days: 1))) {
        DateTime normalizedD = DateTime(d.year, d.month, d.day);
        if (isSameDay(normalizedD, normalizedDay)) {
          events.add('Predicted Cycle');
        }
      }
    }

    // Add predicted ovulation window
    if (ovStart != null && ovEnd != null && ovPeak != null) {
      for (DateTime d = ovStart!;
          d.isBefore(ovEnd!.add(Duration(days: 1)));
          d = d.add(Duration(days: 1))) {
        DateTime normalizedD = DateTime(d.year, d.month, d.day);
        if (isSameDay(normalizedD, normalizedDay)) {
          events.add(isSameDay(normalizedD, ovPeak!)
              ? 'Predicted Ovulation Peak'
              : 'Predicted Ovulation');
        }
      }
    }

    if (events.isNotEmpty) {
      print('Events for $normalizedDay: $events');
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cycle Calendar')),
      body: Container(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader:
                  _getEventsForDay, // Simplified to return List<String> directly
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: events.map((event) {
                          Color color;
                          switch (event) {
                            case 'Menstrual Cycle':
                              color = Colors.red;
                              break;
                            case 'Ovulation Window':
                              color = Colors.blue.withOpacity(0.5);
                              break;
                            case 'Ovulation Peak':
                              color = Colors.blue;
                              break;
                            case 'Predicted Cycle':
                              color = Colors.red.withOpacity(0.5);
                              break;
                            case 'Predicted Ovulation':
                              color = Colors.blue.withOpacity(0.3);
                              break;
                            case 'Predicted Ovulation Peak':
                              color = Colors.blue.withOpacity(0.7);
                              break;
                            default:
                              color = Colors.grey;
                          }
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickDate,
              child: const Text('Log New Period Start Date'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: (_getEventsForDay(_selectedDay ?? _focusedDay))
                    .map((event) => ListTile(title: Text(event)))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
