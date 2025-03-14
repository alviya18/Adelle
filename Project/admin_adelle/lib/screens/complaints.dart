import 'package:admin_adelle/main.dart';
import 'package:admin_adelle/screens/repliedcomplaints.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Complaints extends StatefulWidget {
  const Complaints({super.key});

  @override
  State<Complaints> createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
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
          .neq('complaint_status', 1);

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
    return Container(
        child: Stack(
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "Complaints",
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(
                              data['complaint_title'],
                              style: GoogleFonts.quicksand().copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                // fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              data['complaint_content'],
                              style: GoogleFonts.quicksand().copyWith(
                                color: Colors.black,
                                // fontSize: 16,
                              ),
                            ),
                          ),
                        ));
                  }),
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Repliedcomplaints()),
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
                  "REPLIED COMPLAINTS",
                  style: GoogleFonts.quicksand().copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
