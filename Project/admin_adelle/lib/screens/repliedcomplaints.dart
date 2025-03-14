import 'package:admin_adelle/main.dart';
import 'package:admin_adelle/screens/complaints.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Repliedcomplaints extends StatefulWidget {
  const Repliedcomplaints({super.key});

  @override
  State<Repliedcomplaints> createState() => _RepliedcomplaintsState();
}

class _RepliedcomplaintsState extends State<Repliedcomplaints> {
  List<Map<String, dynamic>> answers = [];
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
          .eq('complaint_status', 1);

      setState(() {
        answers = response;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Replied Complaints",
                style: GoogleFonts.quicksand().copyWith(
                    fontSize: 36,
                    // fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: answers.length,
                  itemBuilder: (context, index) {
                    final data = answers[index];
                    return Card(
                        surfaceTintColor: Colors.white,
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['complaint_title'],
                                style: GoogleFonts.quicksand().copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                data['complaint_content'],
                                style: GoogleFonts.quicksand().copyWith(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Reply",
                                style: GoogleFonts.quicksand().copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                data['complaint_reply'],
                                style: GoogleFonts.quicksand().copyWith(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ));
                  }),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Complaints()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Adjust color

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "BACK",
                    style:
                        GoogleFonts.quicksand().copyWith(color: Colors.white),
                  ),
                ),
              ),
            )
          ]),
        ));
  }
}
