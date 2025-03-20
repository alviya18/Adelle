import 'package:flutter/material.dart';
import 'package:user_adelle/main.dart'; // Assuming supabase is initialized here

class PeriodPage extends StatefulWidget {
  const PeriodPage({super.key});

  @override
  State<PeriodPage> createState() => _PeriodPageState();
}

class _PeriodPageState extends State<PeriodPage> {
  DateTime? selectedStartDate;
  DateTime? lastCycleStart;
  DateTime? lastCycleEnd;
  DateTime? nextCycleStart;
  DateTime? nextCycleEnd;
  DateTime? ovStart;
  DateTime? ovPeak;
  DateTime? ovEnd;

  // Lists to store cycle and ovulation history
  List<Map<String, dynamic>> cycleHistory = [];
  List<Map<String, dynamic>> ovulationHistory = [];

  @override
  void initState() {
    super.initState();
    predictCycles();
    fetchCycleHistory(); // Fetch history on initialization
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
        print("From cycle table: $lastCycle");
        lastStart = DateTime.parse(lastCycle['cycleDate_start']);
        lastEnd = DateTime.parse(lastCycle['cycleDate_end']);
      } else {
        print("From user table: ${user['user_lastPeriod']}");
        lastStart = DateTime.parse(user['user_lastPeriod']);
        lastEnd = lastStart.add(Duration(days: cycleDuration - 1));
      }

      DateTime predictedNextStart = lastStart.add(Duration(days: cycleLength));
      DateTime predictedNextEnd = predictedNextStart.add(Duration(days: cycleDuration - 1));
      DateTime predictedOvPeak = predictedNextStart.subtract(Duration(days: 14));
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
    } catch (e) {
      print('Error predicting cycles: $e');
    }
  }

  // Fetch cycle and ovulation history
  Future<void> fetchCycleHistory() async {
    try {
      final cycleResponse = await supabase
          .from('tbl_cycleDates')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('cycleDate_start', ascending: false); // Most recent first

      final ovulationResponse = await supabase
          .from('tbl_ovulationCycle')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('ovulationCycle_peakDate', ascending: false); // Most recent first

      setState(() {
        cycleHistory = List<Map<String, dynamic>>.from(cycleResponse);
        ovulationHistory = List<Map<String, dynamic>>.from(ovulationResponse);
      });
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
      final lastCycleResponse = await supabase
          .from('tbl_cycleDates')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('cycleDate_end', ascending: false)
          .limit(1);

      int cycleDuration = user['user_cycleDuration'];
      int cycleLength = user['user_cycleLength'];

      // Current period cycle
      DateTime endDate = startDate.add(Duration(days: cycleDuration - 1));
      await supabase.from('tbl_cycleDates').upsert([
        {
          'user_id': supabase.auth.currentUser!.id,
          'cycleDate_start': startDate.toIso8601String(),
          'cycleDate_end': endDate.toIso8601String(),
          'cycleDate_month': startDate.month,
        }
      ]);

      // Recalculate next cycle and ovulation
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

      // Refresh history after adding a new cycle
      await fetchCycleHistory();
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
      setState(() {
        selectedStartDate = picked;
      });
      await addCycle(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Period Tracker')),
      body: SingleChildScrollView( // Wrap in SingleChildScrollView for scrolling
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: pickDate,
              child: Text(selectedStartDate == null
                  ? 'Log New Period Start Date'
                  : 'Selected: ${selectedStartDate!.toString().substring(0, 10)}'),
            ),
            const SizedBox(height: 20),
            const Text('Previous Cycle:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(lastCycleStart != null
                ? 'Start: ${lastCycleStart!.toString().substring(0, 10)}'
                : 'No data'),
            Text(lastCycleEnd != null
                ? 'End: ${lastCycleEnd!.toString().substring(0, 10)}'
                : ''),
            const SizedBox(height: 20),
            const Text('Predicted Upcoming Cycle:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(nextCycleStart != null
                ? 'Start: ${nextCycleStart!.toString().substring(0, 10)}'
                : 'No data'),
            Text(nextCycleEnd != null
                ? 'End: ${nextCycleEnd!.toString().substring(0, 10)}'
                : ''),
            const SizedBox(height: 20),
            const Text('Predicted Ovulation Window:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(ovStart != null
                ? 'Start: ${ovStart!.toString().substring(0, 10)}'
                : 'No data'),
            Text(ovPeak != null
                ? 'Peak: ${ovPeak!.toString().substring(0, 10)}'
                : ''),
            Text(ovEnd != null
                ? 'End: ${ovEnd!.toString().substring(0, 10)}'
                : ''),
            const SizedBox(height: 20),
            const Text('Cycle History:', style: TextStyle(fontWeight: FontWeight.bold)),
            cycleHistory.isEmpty
                ? const Text('No cycle history available')
                : SizedBox(
                    height: 150, // Fixed height for scrollable list
                    child: ListView.builder(
                      itemCount: cycleHistory.length,
                      itemBuilder: (context, index) {
                        final cycle = cycleHistory[index];
                        return ListTile(
                          title: Text(
                              'Start: ${DateTime.parse(cycle['cycleDate_start']).toString().substring(0, 10)}'),
                          subtitle: Text(
                              'End: ${DateTime.parse(cycle['cycleDate_end']).toString().substring(0, 10)}'),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 20),
            const Text('Ovulation History:', style: TextStyle(fontWeight: FontWeight.bold)),
            ovulationHistory.isEmpty
                ? const Text('No ovulation history available')
                : SizedBox(
                    height: 150, // Fixed height for scrollable list
                    child: ListView.builder(
                      itemCount: ovulationHistory.length,
                      itemBuilder: (context, index) {
                        final ovulation = ovulationHistory[index];
                        return ListTile(
                          title: Text(
                              'Peak: ${DateTime.parse(ovulation['ovulationCycle_peakDate']).toString().substring(0, 10)}'),
                          subtitle: Text(
                              'Start: ${DateTime.parse(ovulation['ovulationCycle_start']).toString().substring(0, 10)} - '
                              'End: ${DateTime.parse(ovulation['ovulationCycle_end']).toString().substring(0, 10)}'),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}