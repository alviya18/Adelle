// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:user_adelle/main.dart';

// class ComplaintReplies extends StatefulWidget {
//   const ComplaintReplies({super.key});

//   @override
//   State<ComplaintReplies> createState() => _ComplaintRepliesState();
// }

// class _ComplaintRepliesState extends State<ComplaintReplies> {
//   List<Map<String, dynamic>> answers = [];
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     try {
//       final response = await supabase
//           .from('tbl_complaint')
//           .select()
//           .eq('user_id', supabase.auth.currentUser!.id)
//           .eq('complaint_status', 1);
//       print(response);
//       setState(() {
//         answers = response;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(
//           "Failed",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: false,
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
//           "Complaint Replies",
//           style: GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white),
//         ),
//       ),
//       body: ListView(
//         shrinkWrap: true,
//         children: [
//           SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: ListView.builder(
//               physics: NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: answers.length,
//               itemBuilder: (context, index) {
//                 final data = answers[index];
//                 return Card(
//                     shadowColor: Color(0xFFDC010E),
//                     color: Colors.white,
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       side: BorderSide(color: Color(0xFFDC010E)),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             data['complaint_title'],
//                             style: GoogleFonts.sortsMillGoudy().copyWith(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                               fontSize: 16,
//                             ),
//                             textAlign: TextAlign.left,
//                           ),
//                           Text(
//                             data['complaint_content'],
//                             style: GoogleFonts.sortsMillGoudy().copyWith(
//                               color: Colors.black,
//                               fontSize: 16,
//                             ),
//                             textAlign: TextAlign.justify,
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             "Reply",
//                             style: GoogleFonts.sortsMillGoudy().copyWith(
//                               color: Colors.green,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                             textAlign: TextAlign.left,
//                           ),
//                           Text(
//                             data['complaint_reply'],
//                             style: GoogleFonts.sortsMillGoudy().copyWith(
//                               color: Colors.black,
//                               fontSize: 16,
//                             ),
//                             textAlign: TextAlign.justify,
//                           ),
//                         ],
//                       ),
//                     ));
//               },
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';

class ComplaintReplies extends StatefulWidget {
  const ComplaintReplies({super.key});

  @override
  State<ComplaintReplies> createState() => _ComplaintRepliesState();
}

class _ComplaintRepliesState extends State<ComplaintReplies> {
  List<Map<String, dynamic>> answers = [];
  int? selectedComplaint;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await supabase
          .from('tbl_complaint')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .eq('complaint_status', 1);
      setState(() {
        answers = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to fetch complaints. Please try again.",
            style: GoogleFonts.sortsMillGoudy(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          "Complaint Replies",
          style: GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white),
        ),
      ),
      body: answers.isEmpty
          ? Center(
              child: Text(
                "No replies yet.",
                style: GoogleFonts.sortsMillGoudy(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: answers.length,
                  itemBuilder: (context, index) {
                    final data = answers[index];
                    return Card(
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      elevation: 4,
                      shadowColor: Color(0xFFDC010E),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Color(0xFFDC010E),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['complaint_title'] ?? "No Title",
                              style: GoogleFonts.sortsMillGoudy().copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: selectedComplaint == index
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data['complaint_content'] ?? "No Content",
                              style: GoogleFonts.sortsMillGoudy().copyWith(
                                fontSize: 14,
                                color: selectedComplaint == index
                                    ? Colors.white70
                                    : Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(206, 251, 240, 240),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(206, 251, 240, 240),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Response",
                                    style: GoogleFonts.sortsMillGoudy()
                                        .copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    data['complaint_reply'] ?? "No Reply",
                                    style:
                                        GoogleFonts.sortsMillGoudy().copyWith(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
