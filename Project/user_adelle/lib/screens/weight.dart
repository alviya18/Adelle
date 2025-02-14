import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:user_adelle/screens/height.dart';

class Weight extends StatefulWidget {
  const Weight({super.key});

  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  double weight = 55.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(50)),
                    color: const Color(0xFFDC010E),
                    image: DecorationImage(
                        image: AssetImage("assets/userlogin4.webp"),
                        fit: BoxFit.cover)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 220,
                ),
                Text(
                    "For more personalized insights, kindly share your weight.",
                    style: GoogleFonts.sortsMillGoudy().copyWith(
                      color: Color(0xFFDC010E),
                      fontSize: 24,
                    )),
                SizedBox(
                  height: 55,
                ),
                SizedBox(
                  height: 250,
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0, // ✅ Min weight set to 0
                        maximum: 120, // ✅ Max weight set to 120
                        startAngle: 150,
                        endAngle: 30,
                        showLabels: true,
                        showTicks: true,
                        axisLineStyle: AxisLineStyle(
                          thickness: 8,
                          color: Colors.grey.shade300,
                        ),
                        majorTickStyle:
                            MajorTickStyle(length: 10, thickness: 1.5),
                        minorTicksPerInterval: 3,
                        pointers: <GaugePointer>[
                          MarkerPointer(
                            // ✅ Draggable Pointer
                            value: weight,
                            markerType: MarkerType.invertedTriangle,
                            color: Color(0xFFDC010E),
                            markerHeight: 15,
                            markerWidth: 15,
                            enableDragging: true, // ✅ Enables dragging
                            onValueChanged: (value) {
                              setState(() {
                                weight = value; // ✅ Update weight dynamically
                              });
                            },
                          ),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            widget: Text(
                              "${weight.toStringAsFixed(1)} KG", // ✅ Show 1 decimal place
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 3, 3, 3),
                              ),
                            ),
                            angle: 90,
                            positionFactor: 1.5,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 155,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Height()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDC010E),
                    overlayColor: Color.fromARGB(255, 8, 8, 8),
                    shadowColor: Color(0xFFDC010E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "NEXT",
                    style: GoogleFonts.sortsMillGoudy().copyWith(
                      color: const Color.fromARGB(221, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
