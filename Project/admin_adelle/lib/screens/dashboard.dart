import 'package:admin_adelle/main.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> userList = [];
  List<Map<String, dynamic>> complaintList = [];
  List<Map<String, dynamic>> feedbackList = [];
  List<Map<String, dynamic>> moodList = [];
  List<Map<String, dynamic>> symptomList = [];
  Future<void> fetchEmotions() async {
    try {
      final response = await supabase.from('tbl_emotions').select();
      setState(() {
        moodList = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> fetchSymptoms() async {
    try {
      final response = await supabase.from('tbl_symptoms').select();
      setState(() {
        symptomList = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> fetchFeedbacks() async {
    try {
      final response = await supabase.from('tbl_feedback').select();
      setState(() {
        feedbackList = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> fetchUser() async {
    try {
      final response = await supabase.from('tbl_user').select();
      setState(() {
        userList = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> fetchComplaints() async {
    try {
      final response = await supabase.from('tbl_complaint').select();
      setState(() {
        complaintList = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  void initState() {
    super.initState();
    fetchUser();
    fetchFeedbacks();
    fetchComplaints();
    fetchEmotions();
    fetchSymptoms();
  }

  Map<String, double> getDataMap() {
    return {
      "Users": userList.length.toDouble(),
      "Feedbacks": feedbackList.length.toDouble(),
      "Complaints": complaintList.length.toDouble(),
    };
  }

  List<Color> colorList = [
    const Color.fromARGB(255, 19, 149, 255),
    const Color.fromARGB(255, 4, 169, 10),
    const Color.fromARGB(255, 223, 21, 7),
    Colors.yellow
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Admin Dashboard",
                  style: GoogleFonts.quicksand().copyWith(
                      fontSize: 36,
                      // fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // StatsCard(title: "Total Users", value: "${userList.length}"),
                  // StatsCard(title: "Feedbacks", value: "${feedbackList.length}"),
                  // StatsCard(title: "Complaints", value: "${complaintList.length}"),
                  getDataMap().values.every((value) => value == 0)
                      ? Center(
                          child: Text("No Data Available",
                              style: TextStyle(color: Colors.white)))
                      : Card(
                          elevation: 25,
                          shadowColor: Colors.black,

                          // surfaceTintColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 50, horizontal: 25),
                            child: PieChart(
                              dataMap: getDataMap(),
                              animationDuration: Duration(seconds: 2),
                              chartLegendSpacing: 32,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 4,
                              colorList: colorList,
                              initialAngleInDegree: 0,
                              chartType: ChartType.ring,
                              ringStrokeWidth: 12,

                              // centerText: "",
                              legendOptions: LegendOptions(
                                showLegendsInRow: false,
                                legendPosition: LegendPosition.right,
                                showLegends: true,
                                legendShape: BoxShape.circle,
                                legendTextStyle:
                                    GoogleFonts.quicksand().copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              chartValuesOptions: ChartValuesOptions(
                                showChartValueBackground: true,
                                showChartValues: true,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                                decimalPlaces: 1,
                              ),
                              // gradientList: ---To add gradient colors---
                              // emptyColorGradient: ---Empty Color gradient---
                            ),
                          ),
                        ),
                  Column(children: [
                    StatsCard(
                        title: "Symptomns", value: "${symptomList.length}"),
                    SizedBox(
                      height: 50,
                    ),
                    StatsCard(title: "Moods", value: "${moodList.length}"),
                  ])
                ],
              ),
            ],
          ),
        ));
  }
}

class StatsCard extends StatelessWidget {
  final String title;
  final String value;

  StatsCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 25,
      child: Container(
        padding: EdgeInsets.all(16),
        width: 220,
        height: 220,
        child: Column(
          children: [
            SizedBox(height: 15),
            Text(title,
                style: GoogleFonts.quicksand()
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 22)),
            SizedBox(height: 15),
            Text(value,
                style: GoogleFonts.quicksand().copyWith(
                    fontSize: 42,
                    color: Colors.green,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
