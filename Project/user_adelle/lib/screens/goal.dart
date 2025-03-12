// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:user_adelle/main.dart';

// class Goal extends StatefulWidget {
//   const Goal({super.key});

//   @override
//   State<Goal> createState() => _GoalState();
// }

// class _GoalState extends State<Goal> {
//   List<Map<String, dynamic>> answers = [];
//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }

//   int? value;
//   String? selectedValue;
//   //
//   int goal = 0;
//   Future<void> fetchUserData() async {
//     try {
//       final response = await supabase
//           .from('tbl_user')
//           .select()
//           .eq('user_id', supabase.auth.currentUser!.id)
//           .single();
//       setState(() {
//         goal = response['user_trackingReason'];
//       });
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   Future<void> fetchTrackingReasons() async {
//     try {
//       final data = await supabase.from('tbl_trackingReason').select();
//       setState(() {
//         answers = data['trackingReason_choice'];
//       });
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   Future<void> update() async {
//     try {
//       await supabase
//           .from('tbl_user')
//           .update({'trackingReason_id': selectedValue});
//     } catch (e) {}
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
//           "Goal",
//           style: GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListView(
//               children: [
//                 ListTile(
//                   title: Text("Traking Reason",
//                       style: GoogleFonts.sortsMillGoudy()),
//                   subtitle: Text(''),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: ListView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: answers.length,
//                 itemBuilder: (context, index) {
//                   final data = answers[index];
//                   return Card(
//                       color: value == index ? Color(0xFFDC010E) : Colors.white,
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         side: BorderSide(color: Color(0xFFDC010E)),
//                       ),
//                       child: InkWell(
//                         onTap: () {
//                           print(data['trackingReason_id']);
//                           setState(() {
//                             value = index;
//                             selectedValue =
//                                 data['trackingReason_id'].toString();
//                           });
//                         },
//                         child: Container(
//                           alignment: Alignment.center,
//                           padding: EdgeInsets.all(10),
//                           child: ListTile(
//                               title: Text(
//                             data['trackingReason_choice'],
//                             style: GoogleFonts.sortsMillGoudy().copyWith(
//                               color:
//                                   value == index ? Colors.white : Colors.black,
//                               fontSize: 16,
//                             ),
//                           )),
//                         ),
//                       ));
//                 },
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: selectedValue != null
//             ? () {
//                 update(); // ✅ Use selectedValue instead
//               }
//             : null, // Disable button if nothing is selected
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(50),
//         ),
//         child: Icon(
//           Icons.delete_outline_rounded,
//           color: selectedValue != null
//               ? Color(0xFFDC010E)
//               : Colors.grey, // Change color when disabled
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';

class Goal extends StatefulWidget {
  const Goal({super.key});

  @override
  State<Goal> createState() => _GoalState();
}

class _GoalState extends State<Goal> {
  List<Map<String, dynamic>> answers = [];
  int? value;
  String? selectedValue;
  String? goalTrackingReason;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchTrackingReasons();
  }

  // Fetch User's Current Tracking Reason
  Future<void> fetchUserData() async {
    try {
      final response = await supabase
          .from('tbl_user')
          .select('trackingReason_id')
          .eq('user_id', supabase.auth.currentUser!.id)
          .single();

      final goalId = response['trackingReason_id'];

      final trackingResponse = await supabase
          .from('tbl_trackingReason')
          .select('trackingReason_choice')
          .eq('trackingReason_id', goalId)
          .single();

      setState(() {
        goalTrackingReason = trackingResponse['trackingReason_choice'];
        selectedValue = goalId.toString();
      });
    } catch (e) {
      print("Error fetching user goal: $e");
    }
  }

  // Fetch Tracking Reasons
  Future<void> fetchTrackingReasons() async {
    try {
      final data = await supabase.from('tbl_trackingReason').select();
      setState(() {
        answers = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      print("Error fetching tracking reasons: $e");
    }
  }

  // Update User's Tracking Goal
  Future<void> updateGoal() async {
    if (selectedValue == null) return;

    try {
      await supabase
          .from('tbl_user')
          .update({'trackingReason_id': selectedValue}).eq(
              'user_id', supabase.auth.currentUser!.id);

      fetchUserData(); // Refresh UI after update
    } catch (e) {
      print("Error updating goal: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFDC010E),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_sharp),
          color: Colors.white,
        ),
        title: Text(
          "Goal",
          style: GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Current Tracking Reason
            ListTile(
              title:
                  Text("Tracking Reason", style: GoogleFonts.sortsMillGoudy()),
              subtitle: Text(
                goalTrackingReason ?? "Loading...",
                style: GoogleFonts.sortsMillGoudy(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),

            // Tracking Reason Selection
            Expanded(
              child: ListView.builder(
                itemCount: answers.length,
                itemBuilder: (context, index) {
                  final data = answers[index];
                  bool isSelected =
                      selectedValue == data['trackingReason_id'].toString();

                  return Card(
                    color: isSelected ? Color(0xFFDC010E) : Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Color(0xFFDC010E)),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedValue = data['trackingReason_id'].toString();
                        });
                      },
                      child: ListTile(
                        title: Text(
                          data['trackingReason_choice'],
                          style: GoogleFonts.sortsMillGoudy().copyWith(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectedValue != null && selectedValue != goalTrackingReason
            ? updateGoal
            : null,
        backgroundColor:
            selectedValue != null && selectedValue != goalTrackingReason
                ? Color(0xFFDC010E)
                : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}
