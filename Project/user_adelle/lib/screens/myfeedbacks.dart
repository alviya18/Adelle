import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';

class MyFeedbacks extends StatefulWidget {
  const MyFeedbacks({super.key});

  @override
  State<MyFeedbacks> createState() => _MyFeedbacksState();
}

class _MyFeedbacksState extends State<MyFeedbacks> {
  List<Map<String, dynamic>> answers = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await supabase
          .from('tbl_feedback')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id);

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

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_feedback').delete().eq('feedback_id', id);

      fetchData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed",
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.black,
      ));
    }
  }

  int? value;
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
          "My Feedbacks",
          style: GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: answers.length,
                itemBuilder: (context, index) {
                  final data = answers[index];
                  return Card(
                      shadowColor: Color(0xFFDC010E),
                      color: value == index ? Color(0xFFDC010E) : Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Color(0xFFDC010E)),
                      ),
                      child: InkWell(
                        onTap: () {
                          print(data['complaint_id']);
                          setState(() {
                            value = index;
                            selectedValue = data['complaint_id'].toString();
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: ListTile(
                              title: Text(
                            data['feedback_content'],
                            style: GoogleFonts.sortsMillGoudy().copyWith(
                              color:
                                  value == index ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          )),
                        ),
                      ));
                },
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectedValue != null
            ? () {
                delete(
                    int.parse(selectedValue!)); // ✅ Use selectedValue instead
              }
            : null, // Disable button if nothing is selected
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: selectedValue != null
              ? Color(0xFFDC010E)
              : Colors.grey, // Change color when disabled
        ),
      ),
    );
  }
}
