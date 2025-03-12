// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:user_adelle/main.dart';

// class EditWeight extends StatefulWidget {
//   const EditWeight({super.key});

//   @override
//   State<EditWeight> createState() => _EditWeightState();
// }

// class _EditWeightState extends State<EditWeight> {
//   double weight = 55.0;

//   Future<void> fetchUser() async {
//     try {
//       final response = await supabase
//           .from('tbl_user')
//           .select()
//           .eq('user_id', supabase.auth.currentUser!.id)
//           .single();
//       setState(() {
//         weight = double.tryParse(response['user_weight'].toString()) ?? 0;
//       });
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   Future<void> update(double weightSelected) async {
//     try {
//       await supabase
//           .from('tbl_user')
//           .update({'user_weight': weightSelected}).eq(
//               'user_id', supabase.auth.currentUser!.id);
//       setState(() {
//         weight = weightSelected; // Update UI with new selection
//       });
//       Navigator.pop(context); // Close the modal after updating
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchUser();
//   }

//   Future<void> updateWeight() async {
//     List<int> weights =
//         List.generate(101, (index) => 30 + index); // 30kg to 130kg
//     num selectedWeight = weight > 0 ? weight : 60;

//     showModalBottomSheet(
//       backgroundColor: Colors.white,
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Container(
//               padding: const EdgeInsets.all(16),
//               height: 300,
//               child: Column(
//                 children: [
//                   Text(
//                     "Select Weight",
//                     style: GoogleFonts.sortsMillGoudy(fontSize: 18),
//                   ),
//                   Expanded(
//                     child: CupertinoPicker(
//                       backgroundColor: Colors.white,
//                       itemExtent: 50,
//                       scrollController: FixedExtentScrollController(
//                         initialItem: weights.indexOf(selectedWeight.toInt()),
//                       ),
//                       onSelectedItemChanged: (index) {
//                         setModalState(() {
//                           selectedWeight =
//                               weights[index]; // ✅ Corrected reference
//                         });
//                       },
//                       children: weights.map((w) {
//                         return Center(
//                           child: Text(
//                             "$w kg",
//                             style: const TextStyle(fontSize: 20),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: Text("CANCEL",
//                             style: GoogleFonts.sortsMillGoudy().copyWith(
//                                 color: const Color(0xFFDC010E), fontSize: 14)),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           update(selectedWeight
//                               .toDouble()); // ✅ Use selectedWeight
//                         },
//                         child: Text("OK",
//                             style: GoogleFonts.sortsMillGoudy().copyWith(
//                                 color: const Color(0xFFDC010E), fontSize: 14)),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFDC010E),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.close_sharp),
//           color: Colors.white,
//         ),
//         title: Text(
//           "Weight",
//           style: GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white),
//         ),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: Text("Weight", style: GoogleFonts.sortsMillGoudy()),
//             subtitle: Text(weight > 0 ? "$weight kg" : "Not Set"),
//             onTap: () {
//               updateWeight();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:user_adelle/main.dart';

class EditWeight extends StatefulWidget {
  const EditWeight({super.key});

  @override
  State<EditWeight> createState() => _EditWeightState();
}

class _EditWeightState extends State<EditWeight> {
  double weight = 55.0;

  Future<void> fetchUser() async {
    try {
      final response = await supabase
          .from('tbl_user')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .single();
      setState(() {
        weight = double.tryParse(response['user_weight'].toString()) ?? 0;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> update(double weightSelected) async {
    try {
      await supabase
          .from('tbl_user')
          .update({'user_weight': weightSelected}).eq(
              'user_id', supabase.auth.currentUser!.id);
      setState(() {
        weight = weightSelected; // Update UI with new selection
      });
      Navigator.pop(context); // Close the modal after updating
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> updateWeight() async {
    double selectedWeight = weight > 0 ? weight : 60.0;

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: 400,
              child: Column(
                children: [
                  Text(
                    "Select Weight",
                    style: GoogleFonts.sortsMillGoudy(fontSize: 18),
                  ),
                  Expanded(
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 30,
                          maximum: 130,
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
                              value: selectedWeight,
                              markerType: MarkerType.invertedTriangle,
                              color: Color(0xFFDC010E),
                              markerHeight: 15,
                              markerWidth: 15,
                              enableDragging: true,
                              onValueChanged: (value) {
                                setModalState(() {
                                  selectedWeight =
                                      double.parse(value.toStringAsFixed(1));
                                });
                              },
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Text(
                                "${selectedWeight.toStringAsFixed(1)} KG",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              angle: 90,
                              positionFactor: 0.7,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("CANCEL",
                            style: GoogleFonts.sortsMillGoudy().copyWith(
                                color: const Color(0xFFDC010E), fontSize: 14)),
                      ),
                      TextButton(
                        onPressed: () {
                          update(selectedWeight);
                        },
                        child: Text("OK",
                            style: GoogleFonts.sortsMillGoudy().copyWith(
                                color: const Color(0xFFDC010E), fontSize: 14)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFDC010E),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close_sharp),
          color: Colors.white,
        ),
        title: Text(
          "Weight",
          style: GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Weight", style: GoogleFonts.sortsMillGoudy()),
            subtitle: Text(weight > 0 ? "$weight kg" : "Not Set"),
            onTap: () {
              updateWeight();
            },
          ),
        ],
      ),
    );
  }
}
