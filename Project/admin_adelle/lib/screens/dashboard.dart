import 'package:admin_adelle/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> userList = [];
  List<Map<String, dynamic>> complaintList = [];
  List<Map<String, dynamic>> feedbackList = [];
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsCard(title: "Total Users", value: "${userList.length}"),
              StatsCard(title: "Feedbacks", value: "${feedbackList.length}"),
              StatsCard(title: "Complaints", value: "${complaintList.length}"),
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
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(16),
        width: 120,
        height: 120,
        child: Column(
          children: [
            Text(title,
                style: GoogleFonts.quicksand()
                    .copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(value,
                style: GoogleFonts.quicksand().copyWith(
                    fontSize: 28,
                    color: Colors.green,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
