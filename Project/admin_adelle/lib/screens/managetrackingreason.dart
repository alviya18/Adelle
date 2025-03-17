import 'package:admin_adelle/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackingReason extends StatefulWidget {
  const TrackingReason({super.key});

  @override
  State<TrackingReason> createState() => _TrackingReasonState();
}

class _TrackingReasonState extends State<TrackingReason> {
  TextEditingController trackingReason = TextEditingController();

  int editId = 0;

  List<Map<String, dynamic>> trackingReasonList = [];

  Future<void> fetchData() async {
    try {
      final response = await supabase.from('tbl_trackingReason').select();
      setState(() {
        trackingReasonList = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed",
          style: GoogleFonts.quicksand().copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> insert() async {
    if (formKey.currentState!.validate()) {
      String tr = trackingReason.text.trim().toLowerCase();

      try {
        // Check if tracking reason already exists (case-insensitive)
        final existingReason = await supabase
            .from("tbl_trackingReason")
            .select()
            .ilike("trackingReason_choice", tr)
            .maybeSingle();

        if (existingReason != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "This tracking reason already exists!",
              style: GoogleFonts.quicksand().copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
        } else {
          await supabase.from("tbl_trackingReason").insert({
            'trackingReason_choice': tr,
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Added!",
              style: GoogleFonts.quicksand().copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ));
          fetchData();
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Failed",
            style: GoogleFonts.quicksand().copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
      trackingReason.clear();
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase
          .from('tbl_trackingReason')
          .delete()
          .eq('trackingReason_id', id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Deleted!",
            style: GoogleFonts.quicksand().copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red));

      fetchData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed",
          style: GoogleFonts.quicksand().copyWith(color: Colors.red),
        ),
        backgroundColor: Colors.black,
      ));
      trackingReason.clear();
    }
  }

  Future<void> update() async {
    String reason = trackingReason.text.trim().toLowerCase();

    try {
      // Check if another record (excluding the current one) has the same tracking reason
      final existingReason = await supabase
          .from('tbl_trackingReason')
          .select()
          .ilike('trackingReason_choice', reason)
          .neq('trackingReason_id', editId) // Exclude the current entry
          .maybeSingle();

      if (existingReason != null) {
        // If tracking reason already exists, show error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "This tracking reason already exists!",
            style: GoogleFonts.quicksand().copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      } else {
        // Proceed with the update
        await supabase.from('tbl_trackingReason').update(
            {'trackingReason_choice': reason}).eq('trackingReason_id', editId);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Updated successfully!",
            style: GoogleFonts.quicksand().copyWith(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 3, 43, 156),
        ));

        fetchData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed to update!",
          style: GoogleFonts.quicksand().copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ));
    }

    // Reset fields after update attempt
    trackingReason.clear();
    setState(() {
      editId = 0;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      //  const Color.fromARGB(255, 255, 255, 255),
      child: LayoutBuilder(
        builder: (context, constraints) => Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Manage Tracking Reasons",
                  style: GoogleFonts.quicksand().copyWith(
                      fontSize: 36,
                      // fontWeight: FontWeight.bold,
                      color: Colors.white
                      //  const Color.fromARGB(255, 3, 3, 3)
                      ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                // shadowColor: Color.fromARGB(221, 240, 63, 63),
                surfaceTintColor: Colors.white,
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          style: GoogleFonts.quicksand().copyWith(
                              color: Color.fromARGB(221, 6, 6, 6),
                              fontWeight: FontWeight.bold),
                          controller: trackingReason,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please insert a tracking reason";
                            }
                            return null;
                          },
                          cursorColor: Color.fromARGB(221, 6, 6, 6),
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(221, 6, 6, 6)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Tracking Reason",
                              hintStyle: GoogleFonts.quicksand().copyWith(
                                color: Color.fromARGB(221, 6, 6, 6),
                                fontSize: 13,
                              ),
                              errorStyle: GoogleFonts.quicksand()),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 100,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            if (editId == 0) {
                              insert();
                            } else {
                              update();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(221, 240, 63, 63),
                              overlayColor: Color.fromARGB(255, 40, 41, 42),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: Text(
                            "ENTER",
                            style: GoogleFonts.quicksand().copyWith(
                              color: const Color.fromARGB(221, 255, 255, 255),
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ListView.builder(
                itemCount: trackingReasonList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final data = trackingReasonList[index];
                  return Card(
                      surfaceTintColor: Colors.white,
                      color: Colors.white,
                      elevation: 4,
                      // shadowColor: Color(0xFFDC010E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        // side: BorderSide(color: Color(0xFFDC010E)),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                            leading: Text(
                              "${index + 1}",
                              style: GoogleFonts.quicksand().copyWith(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            title: Text(
                              data['trackingReason_choice'],
                              style: GoogleFonts.quicksand().copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Tooltip(
                                    message: "Edit",
                                    textStyle: GoogleFonts.quicksand().copyWith(
                                      color:
                                          const Color.fromARGB(255, 0, 60, 226),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: const Color.fromARGB(
                                            255, 0, 60, 226),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          editId = data['trackingReason_id'];
                                          trackingReason.text =
                                              data['trackingReason_choice'];
                                        });
                                      },
                                    ),
                                  ),
                                  Tooltip(
                                    message: "Delete",
                                    textStyle: GoogleFonts.quicksand().copyWith(
                                      color: Colors.red,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete_outline_outlined,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        delete(data['trackingReason_id']);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ));
                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
