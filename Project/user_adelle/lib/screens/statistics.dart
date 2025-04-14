import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CycleStatistics extends StatefulWidget {
  const CycleStatistics({super.key});

  @override
  State<CycleStatistics> createState() => _CycleStatisticsState();
}

class _CycleStatisticsState extends State<CycleStatistics> {
  DateTime cycleStartDate =
      DateTime(2025, 4, 12); // Replace with your actual cycle start date

  int get dayOfCycle {
    final today = DateTime.now();
    return today.difference(cycleStartDate).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(),
                        Container(),
                      ],
                    ),
                    Container(
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
                    )
                  ],
                ),
              ))
            ]));
  }
}
