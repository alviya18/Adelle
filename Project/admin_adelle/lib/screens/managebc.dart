import 'package:admin_adelle/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BirthControl extends StatefulWidget {
  const BirthControl({super.key});

  @override
  State<BirthControl> createState() => _BirthControlState();
}

class _BirthControlState extends State<BirthControl> {
  TextEditingController bc = TextEditingController();

  int editId = 0;

  List<Map<String, dynamic>> bcList = [];

  Future<void> fetchData() async {
    try {
      final response = await supabase.from('tbl_bc').select();
      setState(() {
        bcList = response;
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
      String choice = bc.text.trim().toLowerCase();

      try {
        // Check if the choice already exists (case-insensitive)
        final existingChoice = await supabase
            .from("tbl_bc")
            .select()
            .ilike("bc_choice", choice)
            .maybeSingle();

        if (existingChoice != null) {
          // If duplicate exists, show error message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "This birth control choice already exists!",
              style: GoogleFonts.quicksand().copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
        } else {
          // Insert new choice if no duplicate found
          await supabase.from("tbl_bc").insert({
            'bc_choice': choice,
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Added successfully!",
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
            "Failed to add!",
            style: GoogleFonts.quicksand().copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
      bc.clear();
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_bc').delete().eq('bc_id', id);
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
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.black,
      ));
      bc.clear();
    }
  }

  Future<void> update() async {
    String choice = bc.text.trim().toLowerCase();

    try {
      // Check if another record (excluding the current one) has the same bc_choice
      final existingChoice = await supabase
          .from('tbl_bc')
          .select()
          .ilike('bc_choice', choice)
          .neq('bc_id', editId) // Exclude the current entry
          .maybeSingle();

      if (existingChoice != null) {
        // Show error if duplicate exists
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "This birth control choice already exists!",
            style: GoogleFonts.quicksand().copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      } else {
        // Proceed with update
        await supabase
            .from('tbl_bc')
            .update({'bc_choice': choice}).eq('bc_id', editId);

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

    // Clear input and reset edit state
    bc.clear();
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
                  "Manage Medication Choice",
                  style: GoogleFonts.quicksand().copyWith(
                      fontSize: 36,
                      // fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Add Yes and No options for user to choose from if they are on birth control or not?",
                  style: GoogleFonts.quicksand().copyWith(
                      fontSize: 15,
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
                          controller: bc,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Add Options to choose";
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
                              //  Color.fromARGB(221, 6, 6, 6),
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
              Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                    itemCount: bcList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final data = bcList[index];
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
                                data['bc_choice'],
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
                                      textStyle:
                                          GoogleFonts.quicksand().copyWith(
                                        color: const Color.fromARGB(
                                            255, 0, 60, 226),
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
                                            editId = data['bc_id'];
                                            bc.text = data['bc_choice'];
                                          });
                                        },
                                      ),
                                    ),
                                    Tooltip(
                                      message: "Delete",
                                      textStyle:
                                          GoogleFonts.quicksand().copyWith(
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
                                          delete(data['bc_id']);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      );
                    },
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
