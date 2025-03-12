import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';

class EditHeight extends StatefulWidget {
  const EditHeight({super.key});

  @override
  State<EditHeight> createState() => _EditHeightState();
}

class _EditHeightState extends State<EditHeight> {
  int height = 0;

  Future<void> fetchUser() async {
    try {
      final response = await supabase
          .from('tbl_user')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .single();
      setState(() {
        height = int.tryParse(response['user_height'].toString()) ?? 0;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> update(int heightSelected) async {
    try {
      await supabase
          .from('tbl_user')
          .update({'user_height': heightSelected}).eq(
              'user_id', supabase.auth.currentUser!.id);
      setState(() {
        height = heightSelected; // Update UI with new selection
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

  Future<void> updateHeight() async {
    List<int> heights =
        List.generate(101, (index) => 120 + index); // 120cm to 220cm
    int selectedHeight = height > 0 ? height : 150;

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
                    "Select Height",
                    style: GoogleFonts.sortsMillGoudy(fontSize: 18),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      itemExtent: 50,
                      scrollController: FixedExtentScrollController(
                        initialItem: heights.indexOf(selectedHeight),
                      ),
                      onSelectedItemChanged: (index) {
                        setModalState(() {
                          selectedHeight =
                              heights[index]; // ✅ Corrected list reference
                        });
                      },
                      children: heights.map((h) {
                        return Center(
                          child: Text(
                            "$h cm",
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
                          update(selectedHeight); // ✅ Use selectedHeight
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
          "Height",
          style: GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Height", style: GoogleFonts.sortsMillGoudy()),
            subtitle: Text(height > 0 ? "$height cm" : "Not Set"),
            onTap: () {
              updateHeight();
            },
          ),
        ],
      ),
    );
  }
}
