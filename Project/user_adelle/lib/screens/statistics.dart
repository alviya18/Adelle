import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:user_adelle/main.dart';
import 'package:pdf/pdf.dart'; // Added import for PdfColor
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class CycleStatistics extends StatefulWidget {
  const CycleStatistics({super.key});

  @override
  State<CycleStatistics> createState() => _CycleStatisticsState();
}

class _CycleStatisticsState extends State<CycleStatistics> {
  DateTime? firstPeriodDate; // Add this property to store first period date
  DateTime? nextCycleStart; // Add this property

  List<Map<String, dynamic>> userEmotion = [];
  List<Map<String, dynamic>> symptomStats = [];
  Map<String, double> emotionData = {};
  Map<String, double> symptomData = {};

  DateTime? fromDate;
  DateTime? toDate;

  bool periodCycleChecked = false;
  bool ovulationCycleChecked = false;
  bool emotionsTrackedChecked = false;
  bool symptomsTrackedChecked = false;

  bool isLoading = true;

  int get daysSinceFirstPeriod {
    if (firstPeriodDate == null) return 0;
    final today = DateTime.now();
    return today.difference(firstPeriodDate!).inDays + 1;
  }

  int get daysLate {
    if (nextCycleStart == null) return 0;
    final today = DateTime.now();
    if (today.isAfter(nextCycleStart!)) {
      return today.difference(nextCycleStart!).inDays;
    }
    return 0;
  }

  Future<void> fetchEmotionData() async {
    try {
      final totalEmotionsResult = await supabase
          .from('tbl_userEmotions')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id);

      final totalEmotions = totalEmotionsResult.length;

      if (totalEmotions == 0) {
        if (mounted) {
          setState(() {
            userEmotion = [];
            isLoading = false;
          });
        }
        return;
      }

      final emotions = await supabase.from('tbl_emotions').select();
      List<Map<String, dynamic>> emotionStats = [];

      for (var data in emotions) {
        final uemotionResult = await supabase
            .from('tbl_userEmotions')
            .select()
            .eq('user_id', supabase.auth.currentUser!.id)
            .eq('emotion_id', data['emotion_id']);

        final uemotion = uemotionResult.length;
        double percentage =
            totalEmotions > 0 ? (uemotion / totalEmotions) * 100 : 0;

        emotionStats.add({
          'emotion': data['emotion_choice'],
          'percentage': percentage,
          'count': uemotion
        });
      }

      if (mounted) {
        print("User Emotions: $emotionStats");
        setState(() {
          userEmotion = emotionStats;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching emotion data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch emotions: $e")),
        );
      }
    }
  }

  Future<void> fetchSymptomData() async {
    try {
      final userSymptomsResult = await supabase
          .from('tbl_userSymptoms')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id);

      final totalSymptoms = userSymptomsResult.length;

      if (totalSymptoms == 0) {
        if (mounted) {
          setState(() {
            symptomStats = [];
            isLoading = false;
          });
        }
        return;
      }

      final symptoms = await supabase.from('tbl_symptoms').select();
      List<Map<String, dynamic>> tempSymptomStats = [];

      for (var data in symptoms) {
        final userSymptomResult = await supabase
            .from('tbl_userSymptoms')
            .select()
            .eq('user_id', supabase.auth.currentUser!.id)
            .eq(
                'symptoms_id',
                data[
                    'symptom_id']); // Fixed: Changed 'symptoms_id' to 'symptom_id'

        final symptomCount = userSymptomResult.length;
        double percentage =
            totalSymptoms > 0 ? (symptomCount / totalSymptoms) * 100 : 0;

        tempSymptomStats.add({
          'symptom': data['symptom_choice'],
          'percentage': percentage,
          'count': symptomCount
        });
      }

      if (mounted) {
        print("User Symptoms: $tempSymptomStats");
        setState(() {
          symptomStats = tempSymptomStats;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching symptom data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch symptoms: $e")),
        );
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchOvulationCycleData() async {
    if (!ovulationCycleChecked || fromDate == null || toDate == null) return [];
    try {
      final result = await supabase
          .from('tbl_ovulationCycle')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id);
      // .gte('ovulationCycle_start', fromDate!.toIso8601String().substring(0, 10))
      // .lte('ovulationCycle_end', toDate!.toIso8601String().substring(0, 10));
      return result;
    } catch (e) {
      print("Error fetching ovulation cycle data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch ovulation data: $e")),
        );
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchPeriodCycleData() async {
    if (!periodCycleChecked || fromDate == null || toDate == null) return [];
    try {
      final result = await supabase
          .from('tbl_cycleDates')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .gte('cycleDate_start', fromDate!.toIso8601String().substring(0, 10))
          .lte('cycleDate_end', toDate!.toIso8601String().substring(0, 10));
      return result;
    } catch (e) {
      print("Error fetching period cycle data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch period data: $e")),
        );
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchEmotionReportData() async {
    if (!emotionsTrackedChecked || fromDate == null || toDate == null)
      return [];
    try {
      final totalEmotionsResult = await supabase
          .from('tbl_userEmotions')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .gte('createdAt', fromDate!.toIso8601String())
          .lte('createdAt', toDate!.toIso8601String());

      final totalEmotions = totalEmotionsResult.length;
      if (totalEmotions == 0) return [];

      final emotions = await supabase.from('tbl_emotions').select();
      List<Map<String, dynamic>> emotionStats = [];

      for (var data in emotions) {
        final uemotionResult = await supabase
            .from('tbl_userEmotions')
            .select()
            .eq('user_id', supabase.auth.currentUser!.id)
            .eq('emotion_id', data['emotion_id'])
            .gte('createdAt', fromDate!.toIso8601String())
            .lte('createdAt', toDate!.toIso8601String());

        final uemotion = uemotionResult.length;
        double percentage =
            totalEmotions > 0 ? (uemotion / totalEmotions) * 100 : 0;

        if (uemotion > 0) {
          emotionStats.add({
            'emotion': data['emotion_choice'],
            'percentage': percentage,
            'count': uemotion
          });
        }
      }
      return emotionStats;
    } catch (e) {
      print("Error fetching emotion report data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch emotion data: $e")),
        );
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchSymptomReportData() async {
    if (!symptomsTrackedChecked || fromDate == null || toDate == null)
      return [];
    try {
      final userSymptomsResult = await supabase
          .from('tbl_userSymptoms')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .gte('createdAt', fromDate!.toIso8601String())
          .lte('createdAt', toDate!.toIso8601String());

      final totalSymptoms = userSymptomsResult.length;
      if (totalSymptoms == 0) return [];

      final symptoms = await supabase.from('tbl_symptoms').select();
      List<Map<String, dynamic>> symptomStats = [];

      for (var data in symptoms) {
        final userSymptomResult = await supabase
            .from('tbl_userSymptoms')
            .select()
            .eq('user_id', supabase.auth.currentUser!.id)
            .eq('symptoms_id', data['symptom_id'])
            .gte('createdAt', fromDate!.toIso8601String())
            .lte('createdAt', toDate!.toIso8601String());

        final symptomCount = userSymptomResult.length;
        double percentage =
            totalSymptoms > 0 ? (symptomCount / totalSymptoms) * 100 : 0;

        if (symptomCount > 0) {
          symptomStats.add({
            'symptom': data['symptom_choice'],
            'percentage': percentage,
            'count': symptomCount
          });
        }
      }
      return symptomStats;
    } catch (e) {
      print("Error fetching symptom report data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch symptom data: $e")),
        );
      }
      return [];
    }
  }

  Future<void> generateAndSharePdf() async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy');

    // Fetch data based on checkboxes
    final ovulationData = await fetchOvulationCycleData();
    final periodData = await fetchPeriodCycleData();
    final emotionData = await fetchEmotionReportData();
    final symptomData = await fetchSymptomReportData();
    print("Ovulation Data: $ovulationData");
    print("Period Data: $periodData");
    print("Emotion Data: $emotionData");
    print("Symptom Data: $symptomData");
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          // Header
          pw.Header(
            level: 0,
            child: pw.Text(
              ' Health Report',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Date Range : ${fromDate != null ? dateFormat.format(fromDate!) : 'N/A'} - ${toDate != null ? dateFormat.format(toDate!) : 'N/A'}\n\nGenerated on ${dateFormat.format(DateTime.now())} by Adelle',
            style: const pw.TextStyle(fontSize: 13),
          ),
          pw.SizedBox(height: 15),

          // Period Cycles Section
          if (periodData.isNotEmpty) ...[
            pw.Header(level: 1, text: 'Period Cycles'),
            pw.Table.fromTextArray(
              context: context,
              headers: ['Start Date', 'End Date', 'Duration (Days)'],
              data: periodData.map((cycle) {
                final start = DateTime.parse(cycle['cycleDate_start']);
                final end = DateTime.parse(cycle['cycleDate_end']);
                final duration = end.difference(start).inDays + 1;
                return [
                  dateFormat.format(start),
                  dateFormat.format(end),
                  duration.toString(),
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 20),
          ],

          // Ovulation Cycles Section
          if (ovulationData.isNotEmpty) ...[
            pw.Header(level: 1, text: 'Ovulation Cycles'),
            pw.Table.fromTextArray(
              context: context,
              headers: ['Start Date', 'End Date', 'Peak Days'],
              data: ovulationData.map((cycle) {
                final start = DateTime.parse(cycle['ovulationCycle_start']);
                final end = DateTime.parse(cycle['ovulationCycle_end']);
                final peak = DateTime.parse(cycle['ovulationCycle_peakDate']);
                return [
                  dateFormat.format(start),
                  dateFormat.format(end),
                  dateFormat.format(peak),
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 20),
          ],

          // Emotions Section
          if (emotionData.isNotEmpty) ...[
            pw.Header(level: 1, text: 'Moods Tracked'),
            pw.Table.fromTextArray(
              context: context,
              headers: ['Mood', 'Tracked Times', 'Percentage'],
              data: emotionData
                  .map((emotion) => [
                        emotion['emotion'],
                        emotion['count'].toString(),
                        '${emotion['percentage'].toStringAsFixed(1)}%',
                      ])
                  .toList(),
            ),
            pw.SizedBox(height: 20),
          ],

          // Symptoms Section
          if (symptomData.isNotEmpty) ...[
            pw.Header(level: 1, text: 'Symptoms Tracked'),
            pw.Table.fromTextArray(
              context: context,
              headers: ['Symptom', 'Tracked Times', 'Percentage'],
              data: symptomData
                  .map((symptom) => [
                        symptom['symptom'],
                        symptom['count'].toString(),
                        '${symptom['percentage'].toStringAsFixed(1)}%',
                      ])
                  .toList(),
            ),
            pw.SizedBox(height: 20),
          ],

          // No Data Message
          if (ovulationData.isEmpty &&
              periodData.isEmpty &&
              emotionData.isEmpty &&
              symptomData.isEmpty)
            pw.Text(
              'No data available for the selected options and date range.',
              style: pw.TextStyle(
                fontSize: 16,
                color: PdfColors.grey700,
              ),
            ),
        ],
      ),
    );

    // Save PDF
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/adelle_health_report.pdf');
    await file.writeAsBytes(await pdf.save());

    // Share PDF
    await Share.shareXFiles([XFile(file.path)], text: 'Health Report');
  }

  @override
  void initState() {
    super.initState();
    fetchEmotionData();
    fetchSymptomData();
    fetchFirstPeriodDate(); // Add this method call
    fetchPredictedDate(); // Add this method call
  }

  Future<void> fetchFirstPeriodDate() async {
    try {
      final response = await supabase
          .from('tbl_cycleDates')
          .select('cycleDate_start')
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('cycleDate_start', ascending: false)
          .limit(1)
          .single();

      setState(() {
        firstPeriodDate = DateTime.parse(response['cycleDate_start']);
      });
    } catch (e) {
      print('Error fetching first period date: $e');
    }
  }

  Future<void> fetchPredictedDate() async {
    try {
      // First get the latest period date
      final latestPeriod = await supabase
          .from('tbl_cycleDates')
          .select('cycleDate_start')
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('cycleDate_start', ascending: false)
          .limit(1)
          .single();

      // Get user's cycle length
      final user = await supabase
          .from('tbl_user')
          .select('user_cycleLength')
          .eq('user_id', supabase.auth.currentUser!.id)
          .single();

      final lastStart = DateTime.parse(latestPeriod['cycleDate_start']);
      final cycleLength = user['user_cycleLength'] ?? 28;

      setState(() {
        nextCycleStart = lastStart.add(Duration(days: cycleLength));
      });
    } catch (e) {
      print('Error fetching predicted date: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Colors for pie chart sections (direct light and bright red shades, no const)
  final List<Color> pieColors = [
    Color.fromARGB(255, 230, 0, 0), // Deep Red
    Color.fromARGB(255, 230, 40, 40),
    Color.fromARGB(255, 230, 80, 80),
    Colors.red,
    Color.fromARGB(255, 255, 0, 0), // Bright Red

    Color.fromARGB(255, 255, 80, 80),
    Color.fromARGB(255, 255, 120, 120),
    Color.fromARGB(255, 255, 150, 150),
    Color.fromARGB(255, 255, 180, 180),
    Color.fromARGB(255, 255, 200, 200),
    Color.fromARGB(255, 255, 220, 220),
    Color.fromARGB(255, 255, 235, 235),
    Color.fromARGB(255, 255, 245, 245),
  ];

  // Widget _buildCycleStatus() {
  //   if (daysLate > 0) {
  //     return Container(
  //       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
  //       padding: const EdgeInsets.all(10),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(10),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.red.withOpacity(0.3),
  //             spreadRadius: 1,
  //             blurRadius: 3,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       // child: Row(
  //       //   mainAxisAlignment: MainAxisAlignment.center,
  //       //   children: [
  //       //     const Icon(Icons.warning, color: Colors.red, size: 25),
  //       //     const SizedBox(width: 8),
  //       //     Text(
  //       //       'Your period is ${daysLate} ${daysLate == 1 ? 'day' : 'days'} late',
  //       //       style: const TextStyle(
  //       //         color: Colors.red,
  //       //         fontWeight: FontWeight.bold,
  //       //       ),
  //       //     ),
  //       //   ],
  //       // ),
  //     );
  //   }
  //   return const SizedBox.shrink();
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(81, 220, 1, 16),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Text(
                              "Statistics",
                              style: GoogleFonts.sortsMillGoudy().copyWith(
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                            color: Colors.red, size: 25),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            Text(
                              'Today, ${DateFormat('dd MMM').format(DateTime.now())}, ${DateFormat('EEE').format(DateTime.now()).toUpperCase()}',
                              style: const TextStyle(
                                color: Color(0xFF333333),
                              ),
                            ),
                            Text(
                              daysLate > 0
                                  ? 'Late by ${daysLate} ${daysLate == 1 ? 'day' : 'days'}'
                                  : 'Day ${daysSinceFirstPeriod + 1} of your cycle',
                              style: TextStyle(
                                fontSize: 12,
                                color: daysLate > 0
                                    ? Colors.red
                                    : const Color(0xFF333333),
                                fontWeight: daysLate > 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          'MOODS',
                          style: GoogleFonts.sortsMillGoudy(
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 15, right: 7.5),
                          height: screenWidth * 0.5,
                          child: userEmotion.isEmpty
                              ? const Center(child: Text('No emotion data'))
                              : PieChart(
                                  PieChartData(
                                    sections: userEmotion
                                        .asMap()
                                        .entries
                                        .where((entry) =>
                                            entry.value['percentage'] > 0)
                                        .map((entry) {
                                      int index = entry.key;
                                      Map<String, dynamic> data = entry.value;
                                      return PieChartSectionData(
                                        color:
                                            pieColors[index % pieColors.length],
                                        value: data['percentage'],
                                        title:
                                            '${data['emotion']}\n${data['percentage'].toStringAsFixed(1)}%',
                                        radius: screenWidth * 0.2,
                                        titleStyle: GoogleFonts.sortsMillGoudy(
                                          fontSize: 10,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        titlePositionPercentageOffset: 0.55,
                                      );
                                    }).toList(),
                                    sectionsSpace: 2,
                                    centerSpaceRadius: screenWidth * 0.025,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        // Emotion Legend (commented out as in original)
                        /*
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 7.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: userEmotion.map((data) {
                              int index = userEmotion.indexOf(data);
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      color: pieColors[index % pieColors.length],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${data['emotion']}: ${data['percentage'].toStringAsFixed(1)}% (${data['count']})',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        */
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          'SYMPTOMS',
                          style: GoogleFonts.sortsMillGoudy(
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 7.5, right: 15),
                          height: screenWidth * 0.5,
                          child: symptomStats.isEmpty
                              ? const Center(child: Text('No symptom data'))
                              : PieChart(
                                  PieChartData(
                                    sections: symptomStats
                                        .asMap()
                                        .entries
                                        .where((entry) =>
                                            entry.value['percentage'] > 0)
                                        .map((entry) {
                                      int index = entry.key;
                                      Map<String, dynamic> data = entry.value;
                                      return PieChartSectionData(
                                        color:
                                            pieColors[index % pieColors.length],
                                        value: data['percentage'],
                                        title:
                                            '${data['symptom']}\n${data['percentage'].toStringAsFixed(1)}%',
                                        radius: screenWidth * 0.2,
                                        titleStyle: GoogleFonts.sortsMillGoudy(
                                          fontSize: 10,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        titlePositionPercentageOffset: 0.55,
                                      );
                                    }).toList(),
                                    sectionsSpace: 2,
                                    centerSpaceRadius: screenWidth * 0.025,
                                  ),
                                ),
                        ),

                        // Symptom Legend (commented out as in original)
                        /*
                        Padding(
                          padding: const EdgeInsets.only(left: 7.5, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: symptomStats.map((data) {
                              int index = symptomStats.indexOf(data);
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      color: pieColors[index % pieColors.length],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${data['symptom']}: ${data['percentage'].toStringAsFixed(1)}% (${data['count']})',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        */
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            surfaceTintColor: Colors.white,
                            backgroundColor: Colors.white,
                            title: const Text(
                              "Download Health Report",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                          'Select the date range for the report'),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              readOnly: true,
                                              decoration: const InputDecoration(
                                                labelText: 'From',
                                                labelStyle: TextStyle(
                                                    color: Colors.red),
                                                border: UnderlineInputBorder(),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red),
                                                ),
                                              ),
                                              controller: TextEditingController(
                                                text: fromDate != null
                                                    ? "${fromDate!.day}/${fromDate!.month}/${fromDate!.year}"
                                                    : "",
                                              ),
                                              onTap: () async {
                                                final picked =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime.now(),
                                                  builder:
                                                      (BuildContext context,
                                                          Widget? child) {
                                                    return Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                        colorScheme:
                                                            const ColorScheme
                                                                .light(
                                                          primary:
                                                              Color(0xFFDC010E),
                                                          onPrimary:
                                                              Colors.white,
                                                          onSurface:
                                                              Color(0xFF333333),
                                                        ),
                                                        textButtonTheme:
                                                            TextButtonThemeData(
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                const Color(
                                                                    0xFFDC010E),
                                                          ),
                                                        ),
                                                      ),
                                                      child: child!,
                                                    );
                                                  },
                                                );
                                                if (picked != null && mounted) {
                                                  setState(() {
                                                    fromDate = picked;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: TextField(
                                              readOnly: true,
                                              decoration: const InputDecoration(
                                                labelText: 'To',
                                                labelStyle: TextStyle(
                                                    color: Colors.red),
                                                border: UnderlineInputBorder(),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red),
                                                ),
                                              ),
                                              controller: TextEditingController(
                                                text: toDate != null
                                                    ? "${toDate!.day}/${toDate!.month}/${toDate!.year}"
                                                    : "",
                                              ),
                                              onTap: () async {
                                                final picked =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime.now(),
                                                  builder:
                                                      (BuildContext context,
                                                          Widget? child) {
                                                    return Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                        colorScheme:
                                                            const ColorScheme
                                                                .light(
                                                          primary:
                                                              Color(0xFFDC010E),
                                                          onPrimary:
                                                              Colors.white,
                                                          onSurface:
                                                              Color(0xFF333333),
                                                        ),
                                                        textButtonTheme:
                                                            TextButtonThemeData(
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                const Color(
                                                                    0xFFDC010E),
                                                          ),
                                                        ),
                                                      ),
                                                      child: child!,
                                                    );
                                                  },
                                                );
                                                if (picked != null && mounted) {
                                                  setState(() {
                                                    toDate = picked;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: periodCycleChecked,
                                            side: const BorderSide(width: 1),
                                            activeColor:
                                                const Color(0xFFDC010E),
                                            onChanged: (value) {
                                              setState(() {
                                                periodCycleChecked = value!;
                                              });
                                            },
                                          ),
                                          const Text('Period Cycle'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            side: const BorderSide(width: 1),
                                            value: ovulationCycleChecked,
                                            activeColor:
                                                const Color(0xFFDC010E),
                                            onChanged: (value) {
                                              setState(() {
                                                ovulationCycleChecked = value!;
                                              });
                                            },
                                          ),
                                          const Text('Ovulation Cycle'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            side: const BorderSide(width: 1),
                                            value: emotionsTrackedChecked,
                                            activeColor:
                                                const Color(0xFFDC010E),
                                            onChanged: (value) {
                                              setState(() {
                                                emotionsTrackedChecked = value!;
                                              });
                                            },
                                          ),
                                          const Text('Emotions Tracked'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            side: const BorderSide(width: 1),
                                            value: symptomsTrackedChecked,
                                            activeColor:
                                                const Color(0xFFDC010E),
                                            onChanged: (value) {
                                              setState(() {
                                                symptomsTrackedChecked = value!;
                                              });
                                            },
                                          ),
                                          const Text('Symptoms Tracked'),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (fromDate == null ||
                                              toDate == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      "Please select both dates")),
                                            );
                                            return;
                                          }
                                          if (!periodCycleChecked &&
                                              !ovulationCycleChecked &&
                                              !emotionsTrackedChecked &&
                                              !symptomsTrackedChecked) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      "Please select at least one data to be downloaded")),
                                            );
                                            return;
                                          }
                                          try {
                                            await generateAndSharePdf();
                                            if (mounted) {
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "PDF generated and shared successfully")),
                                              );
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Failed to generate PDF : $e")),
                                              );
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFDC010E),
                                          overlayColor: const Color.fromARGB(
                                              255, 8, 8, 8),
                                          shadowColor: const Color(0xFFDC010E),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                        child: const Text(
                                          'Download',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Health Report',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.cloud_download_outlined,
                                      color: Colors.red, size: 16),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'PDF',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  const SizedBox(width: 80),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 100),
                          SizedBox(
                            child: Image.asset(
                              "assets/pdf.png",
                              height: 80,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
