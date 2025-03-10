import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';

class Yob extends StatefulWidget {
  const Yob({super.key});

  @override
  State<Yob> createState() => _YobState();
}

class _YobState extends State<Yob> {
  int yob = 0;

  Future<void> fetchUser() async {
    try {
      final response = await supabase
          .from('tbl_user')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .single();
      setState(() {
        yob = int.tryParse(response['user_yob'].toString()) ?? 0;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> update(int yearSelected) async {
    try {
      await supabase.from('tbl_user').update({'user_yob': yearSelected}).eq(
          'user_id', supabase.auth.currentUser!.id);
      setState(() {
        yob = yearSelected; // Update UI with new selection
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

  void birthYear() {
    int currentYear = DateTime.now().year;
    List<int> years = List.generate(52, (index) => currentYear - (12 + index));
    int selectedYear = yob > 0 ? yob : currentYear - 20;

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: 300,
              child: Column(
                children: [
                  Text(
                    "Select Year of Birth",
                    style: GoogleFonts.sortsMillGoudy(fontSize: 18),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      itemExtent: 50,
                      scrollController: FixedExtentScrollController(
                        initialItem: years.indexOf(selectedYear),
                      ),
                      onSelectedItemChanged: (index) {
                        setModalState(() {
                          selectedYear = years[index]; // ✅ Store selected year
                        });
                      },
                      children: years.map((year) {
                        return Center(
                          child: Text(
                            "$year",
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(),
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
                          update(selectedYear); // ✅ Update database and UI
                        },
                        child: Text("OK",
                            style: GoogleFonts.sortsMillGoudy().copyWith(
                                color: const Color(0xFFDC010E), fontSize: 14)),
                      ),
                    ],
                  ),
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
          "Year of Birth",
          style: GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("YOB", style: GoogleFonts.sortsMillGoudy()),
            subtitle: Text(yob > 0 ? yob.toString() : "Not Set"),
            onTap: () {
              birthYear();
            },
          ),
        ],
      ),
    );
  }
}
