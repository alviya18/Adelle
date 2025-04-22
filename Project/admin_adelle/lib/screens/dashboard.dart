import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

// Move SurveyData class outside of _DashboardState
class SurveyData {
  final String category;
  final double value;
  final Color color;

  SurveyData(this.category, this.value, this.color);
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> userList = [];
  List<Map<String, dynamic>> complaintList = [];
  List<Map<String, dynamic>> feedbackList = [];
  List<Map<String, dynamic>> moodList = [];
  List<Map<String, dynamic>> symptomList = [];
  Map<String, String> trackingReasons = {};
  Map<String, String> gdChoices = {};
  Map<String, String> bcChoices = {};
  Map<String, int> trackingReasonCounts = {};
  Map<String, int> gdCounts = {};
  Map<String, int> bcCounts = {};
  int totalUsers = 0;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final results = await Future.wait([
        supabase.from('tbl_user').select('trackingReason_id, gd_id, bc_id'),
        supabase.from('tbl_complaint').select(),
        supabase.from('tbl_feedback').select(),
        supabase.from('tbl_emotions').select(),
        supabase.from('tbl_symptoms').select(),
        supabase.from('tbl_trackingReason').select(),
        supabase.from('tbl_gd').select(),
        supabase.from('tbl_bc').select(),
      ]);

      setState(() {
        userList = results[0];
        complaintList = results[1];
        feedbackList = results[2];
        moodList = results[3];
        symptomList = results[4];

        // Map IDs to choices
        trackingReasons = {
          for (var item in results[5])
            item['trackingReason_id'].toString(): item['trackingReason_choice']
        };
        gdChoices = {
          for (var item in results[6]) item['gd_id'].toString(): item['gd_choice']
        };
        bcChoices = {
          for (var item in results[7]) item['bc_id'].toString(): item['bc_choice']
        };

        // Count user selections
        totalUsers = userList.length;
        trackingReasonCounts = {for (var id in trackingReasons.keys) id: 0};
        gdCounts = {
          for (var id in gdChoices.keys) id: 0,
          'null': 0, // For users with no gd_id
        };
        bcCounts = {for (var id in bcChoices.keys) id: 0};

        for (var user in userList) {
          final trackingId = user['trackingReason_id']?.toString();
          final gdId = user['gd_id']?.toString();
          final bcId = user['bc_id']?.toString();

          if (trackingId != null) {
            trackingReasonCounts[trackingId] =
                (trackingReasonCounts[trackingId] ?? 0) + 1;
          }
          gdCounts[gdId ?? 'null'] = (gdCounts[gdId ?? 'null'] ?? 0) + 1;
          if (bcId != null) {
            bcCounts[bcId] = (bcCounts[bcId] ?? 0) + 1;
          }
        }

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Failed to load data: $e';
      });
      showError(error!);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Build table for survey results
  Widget _buildTable(String title, Map<String, int> counts, Map<String, String> labels) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.quicksand(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.blue.shade50),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Option',
                        style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Count',
                        style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Percentage',
                        style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...counts.entries.map((entry) {
                  final label = entry.key == 'null' ? 'None' : labels[entry.key] ?? 'Unknown';
                  final count = entry.value;
                  final percentage = totalUsers > 0
                      ? (count / totalUsers * 100).toStringAsFixed(2)
                      : '0.00';
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(label, style: GoogleFonts.quicksand()),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(count.toString(), style: GoogleFonts.quicksand()),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('$percentage%', style: GoogleFonts.quicksand()),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build bar chart
  Widget _buildChart(String title, Map<String, int> counts, Map<String, String> labels) {
    final data = counts.entries.map((entry) {
      final label = entry.key == 'null' ? 'None' : labels[entry.key] ?? 'Unknown';
      return SurveyData(
        label,
        entry.value.toDouble(),
        Colors.blue,
      );
    }).toList();

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.quicksand(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: data.isNotEmpty 
                      ? data.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2
                      : 100,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${data[groupIndex].category}\n${rod.toY.round()}',
                          GoogleFonts.quicksand(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= data.length) return const Text('');
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Text(
                                data[value.toInt()].category,
                                style: GoogleFonts.quicksand(fontSize: 12),
                              ),
                            ),
                          );
                        },
                        reservedSize: 80,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: GoogleFonts.quicksand(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    data.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: data[index].value,
                          color: data[index].color,
                          width: 22,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Text(
                    error!,
                    style: GoogleFonts.quicksand(color: Colors.red, fontSize: 18),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Admin Dashboard',
                          style: GoogleFonts.quicksand(
                            fontSize: 36,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: [
                            StatsCard(
                              title: 'Total Users',
                              value: '${userList.length}',
                              color: Colors.blue,
                            ),
                            StatsCard(
                              title: 'Feedbacks',
                              value: '${feedbackList.length}',
                              color: Colors.green,
                            ),
                            StatsCard(
                              title: 'Complaints',
                              value: '${complaintList.length}',
                              color: Colors.red,
                            ),
                            StatsCard(
                              title: 'Moods',
                              value: '${moodList.length}',
                              color: Colors.blueGrey,
                            ),
                            StatsCard(
                              title: 'Symptoms',
                              value: '${symptomList.length}',
                              color: Colors.orange,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildTable('Tracking Reason', trackingReasonCounts, trackingReasons),
                        _buildChart('Tracking Reason', trackingReasonCounts, trackingReasons),
                        _buildTable('Gynecological Disorders', gdCounts, gdChoices),
                        _buildChart('Gynecological Disorders', gdCounts, gdChoices),
                        _buildTable('Birth Control', bcCounts, bcChoices),
                        _buildChart('Birth Control', bcCounts, bcChoices),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.quicksand(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.quicksand(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
