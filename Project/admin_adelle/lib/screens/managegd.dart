import 'package:admin_adelle/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GD extends StatefulWidget {
  const GD({super.key});

  @override
  State<GD> createState() => _GDState();
}

class _GDState extends State<GD> {
  TextEditingController gd = TextEditingController();

  int editId = 0;

  List<Map<String, dynamic>> gdList = [];

  Future<void> fetchData() async {
    try {
      final response = await supabase.from('tbl_gd').select();
      setState(() {
        gdList = response;
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
      String disease = gd.text.trim().toLowerCase();

      try {
        // Check if disease already exists (case-insensitive)
        final existingDisease = await supabase
            .from("tbl_gd")
            .select()
            .ilike("gd_choice", disease)
            .maybeSingle();

        if (existingDisease != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "This disease already exists!",
              style: GoogleFonts.quicksand().copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
        } else {
          await supabase.from("tbl_gd").insert({
            'gd_choice': disease,
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
      gd.clear();
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_gd').delete().eq('gd_id', id);
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
      gd.clear();
    }
  }

  Future<void> update() async {
    String disease = gd.text.trim().toLowerCase();

    try {
      // Check if another record (excluding the current one) has the same disease
      final existingDisease = await supabase
          .from('tbl_gd')
          .select()
          .ilike('gd_choice', disease)
          .neq('gd_id', editId) // Exclude the current disease
          .maybeSingle();

      if (existingDisease != null) {
        // If disease already exists, show error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "This disease already exists!",
            style: GoogleFonts.quicksand().copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      } else {
        // Proceed with the update
        await supabase
            .from('tbl_gd')
            .update({'gd_choice': disease}).eq('gd_id', editId);

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
    gd.clear();
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
      child: LayoutBuilder(
        builder: (context, constraints) => Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Gynacological Diseases Management",
                  style: GoogleFonts.quicksand().copyWith(
                      fontSize: 36,
                      // fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
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
                          controller: gd,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please insert diseases";
                            }
                            return null;
                          },
                          cursorColor: Color.fromARGB(221, 6, 6, 6),
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueGrey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Gynacological Disease",
                              hintStyle: GoogleFonts.quicksand().copyWith(
                                color: Colors.blueGrey,
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
                itemCount: gdList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final data = gdList[index];
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
                            data['gd_choice'],
                            style: GoogleFonts.quicksand().copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      color:
                                          const Color.fromARGB(255, 0, 60, 226),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        editId = data['gd_id'];
                                        gd.text = data['gd_choice'];
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
                                      delete(data['gd_id']);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  );
                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
