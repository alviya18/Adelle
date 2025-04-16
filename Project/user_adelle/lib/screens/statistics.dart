import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:user_adelle/main.dart';

class CycleStatistics extends StatefulWidget {
  const CycleStatistics({super.key});

  @override
  State<CycleStatistics> createState() => _CycleStatisticsState();
}

class _CycleStatisticsState extends State<CycleStatistics> {
  DateTime cycleStartDate = DateTime(2025, 4, 12);

  List<Map<String, dynamic>> userEmotion = [];
  Map<String, double> emotionData = {};
  Map<String, double> symptomnData = {};

  DateTime? fromDate;
  DateTime? toDate; // Replace with your actual cycle start date

  bool periodCycleChecked = false;
  bool ovulationCycleChecked = false;
  bool emotionsTrackedChecked = false;
  bool symptomsTrackedChecked = false;

  int get dayOfCycle {
    final today = DateTime.now();
    return today.difference(cycleStartDate).inDays + 1;
  }

  Future<void> fetchEmotionData() async {
    try {
      final totalEmotions = await supabase
          .from('tbl_userEmotions')
          .count()
          .eq('user_id', supabase.auth.currentUser!.id);
      List<Map<String, dynamic>> userEmotion = [];
      final emotions = await supabase.from('tbl_emotions').select();
      for (var data in emotions) {
        final uemotion = await supabase
            .from('tbl_userEmotions')
            .count()
            .eq('user_id', supabase.auth.currentUser!.id)
            .eq('emotion_id', data['emotion_id']);
        double percentage = (uemotion / totalEmotions) * 100;
        userEmotion.add({
          'emotion': data['emotion_choice'],
          'percentage': percentage,
        });
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      print("Error fetching emotion data: $e");
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after fetching data
      });
    }
  }

  Future<void> fetchSymptomData() async {
    try {
      final totalEmotions = await supabase
          .from('tbl_userSymptoms')
          .count()
          .eq('user_id', supabase.auth.currentUser!.id);
      List<Map<String, dynamic>> userEmotion = [];
      final emotions = await supabase.from('tbl_symptoms').select();
      for (var data in emotions) {
        final uemotion = await supabase
            .from('tbl_userSymptoms')
            .count()
            .eq('user_id', supabase.auth.currentUser!.id)
            .eq('symptom_id', data['symptom_id']);
        double percentage = (uemotion / totalEmotions) * 100;
        userEmotion.add({
          'symptom': data['symptom_choice'],
          'percentage': percentage,
        });
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      print("Error fetching symptom data: $e");
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after fetching data
      });
    }
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmotionData();
    fetchSymptomData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Text(
                      "Statistics",
                      style: GoogleFonts.sortsMillGoudy().copyWith(
                        fontSize: 22,
                        // color: Color(0xFFDC010E),
                        // fontWeight: FontWeight.bold
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
                const Icon(Icons.calendar_today, color: Colors.red, size: 25),
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
                      'Day $dayOfCycle of your cycle',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
          Column(children: [
            Row(
              children: [
                Container(
                    // child: PieChart(
                    //   PieChartData(
                    //     sections: _createPieChartSections(),
                    //     borderData: FlBorderData(show: false),
                    //     centerSpaceRadius: 40,
                    //     sectionsSpace: 2,
                    //   ),
                    // ),
                    ),
                Container(

                    // PieChart(
                    //   PieChartData(),
                    // ),
                    ),
              ],
            ),
            GestureDetector(
              child: Container(
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
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Health Report',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.cloud_download_outlined,
                                color: Colors.red, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'PDF',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333333),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    SizedBox(
                      child: Image(
                        image: AssetImage("assets/pdf.png"),
                        height: 80,
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      surfaceTintColor: Colors.white,
                      backgroundColor: Colors.white,
                      title: Text(
                        "Download Health Report",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Select the date range for the report'),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            labelText: 'From',
                                            labelStyle:
                                                TextStyle(color: Colors.red),
                                            border: UnderlineInputBorder(),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red)),
                                          ),
                                          controller: TextEditingController(
                                            text: fromDate != null
                                                ? "${fromDate!.day}/${fromDate!.month}/${fromDate!.year}"
                                                : "",
                                          ),
                                          onTap: () async {
                                            final picked = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime.now(),
                                              builder: (BuildContext context,
                                                  Widget? child) {
                                                return Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    colorScheme:
                                                        ColorScheme.light(
                                                      primary: Color(
                                                          0xFFDC010E), // Header & selected day
                                                      onPrimary: Colors
                                                          .white, // Text on header
                                                      onSurface: Color(
                                                          0xFF333333), // Default text color
                                                    ),
                                                    textButtonTheme:
                                                        TextButtonThemeData(
                                                      style:
                                                          TextButton.styleFrom(
                                                        foregroundColor: Color(
                                                            0xFFDC010E), // Cancel/OK text
                                                      ),
                                                    ),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            );
                                            if (picked != null) {
                                              setState(() {
                                                toDate = picked;
                                              });
                                            }
                                          }),
                                    ),
                                    Expanded(
                                      child: TextField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            labelText: 'To',
                                            labelStyle:
                                                TextStyle(color: Colors.red),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red)),
                                            border: UnderlineInputBorder(),
                                          ),
                                          controller: TextEditingController(
                                            text: toDate != null
                                                ? "${toDate!.day}/${toDate!.month}/${toDate!.year}"
                                                : "",
                                          ),
                                          onTap: () async {
                                            final picked = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime.now(),
                                              builder: (BuildContext context,
                                                  Widget? child) {
                                                return Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    colorScheme:
                                                        ColorScheme.light(
                                                      primary: Color(
                                                          0xFFDC010E), // Header & selected day
                                                      onPrimary: Colors
                                                          .white, // Text on header
                                                      onSurface: Color(
                                                          0xFF333333), // Default text color
                                                    ),
                                                    textButtonTheme:
                                                        TextButtonThemeData(
                                                      style:
                                                          TextButton.styleFrom(
                                                        foregroundColor: Color(
                                                            0xFFDC010E), // Cancel/OK text
                                                      ),
                                                    ),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            );
                                            if (picked != null) {
                                              setState(() {
                                                toDate = picked;
                                              });
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: periodCycleChecked,
                                      side: BorderSide(width: 1),
                                      activeColor: Color(0xFFDC010E),
                                      onChanged: (value) {
                                        setState(() {
                                          periodCycleChecked = value!;
                                        });
                                      },
                                    ),
                                    Text('Period Cycle'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      side: BorderSide(width: 1),
                                      value: ovulationCycleChecked,
                                      activeColor: Color(0xFFDC010E),
                                      onChanged: (value) {
                                        setState(() {
                                          ovulationCycleChecked = value!;
                                        });
                                      },
                                    ),
                                    Text('Ovulation Cycle'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      side: BorderSide(width: 1),
                                      value: emotionsTrackedChecked,
                                      activeColor: Color(0xFFDC010E),
                                      onChanged: (value) {
                                        setState(() {
                                          emotionsTrackedChecked = value!;
                                        });
                                      },
                                    ),
                                    Text('Emotions Tracked'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      side: BorderSide(width: 1),
                                      value: symptomsTrackedChecked,
                                      activeColor: Color(0xFFDC010E),
                                      onChanged: (value) {
                                        setState(() {
                                          symptomsTrackedChecked = value!;
                                        });
                                      },
                                    ),
                                    Text('Symptoms Tracked'),
                                  ],
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    if (fromDate != null && toDate != null) {
                                      // Handle download logic here using fromDate & toDate
                                      print(
                                          "Download PDF from $fromDate to $toDate");
                                      Navigator.of(context).pop();
                                    } else {
                                      // Optional: Show a warning if date not selected
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Please select both dates")),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFDC010E),
                                    overlayColor: Color.fromARGB(255, 8, 8, 8),
                                    shadowColor: Color(0xFFDC010E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: Text('Download',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
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
            )
          ])
        ]));
  }
}
