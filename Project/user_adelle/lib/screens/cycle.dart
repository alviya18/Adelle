import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';

class Cycle extends StatefulWidget {
  const Cycle({super.key});

  @override
  State<Cycle> createState() => _CycleState();
}

class _CycleState extends State<Cycle> {
  int length = 0;
  int duration = 0;

  Future<void> fetchUser() async {
    try {
      final response = await supabase
          .from('tbl_user')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .single();
      setState(() {
        length = response['user_cycleLength'];
        duration = response['user_cycleDuration'];
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUser();
  }

  void cycleLength() {
    Future<void> update(tempValue) async {
      try {
        await supabase
            .from('tbl_user')
            .update({'user_cycleLength': tempValue}).eq(
                'user_id', supabase.auth.currentUser!.id);
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        int tempValue = length; // Temporary variable to update selection

        return Container(
          color: Colors.white,
          height: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Cycle length",
                    style: GoogleFonts.sortsMillGoudy().copyWith(
                      fontSize: 18,
                    )),
              ),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 50, // Height of each item
                  scrollController:
                      FixedExtentScrollController(initialItem: length - 21),
                  onSelectedItemChanged: (index) {
                    tempValue = index + 21; // Store selected value
                  },
                  children: List.generate(
                      15,
                      (index) => Text("${index + 21}",
                          style: TextStyle(fontSize: 20))),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("CANCEL",
                        style: GoogleFonts.sortsMillGoudy()
                            .copyWith(color: Color(0xFFDC010E), fontSize: 14)),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        length = tempValue; // Update UI
                      });
                      update(tempValue);
                    },
                    child: Text("OK",
                        style: GoogleFonts.sortsMillGoudy()
                            .copyWith(color: Color(0xFFDC010E), fontSize: 14)),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
    );
  }

  void cycleDuration() {
    Future<void> update(tempValue) async {
      try {
        await supabase
            .from('tbl_user')
            .update({'user_cycleDuration': tempValue}).eq(
                'user_id', supabase.auth.currentUser!.id);
        Navigator.pop(context);
      } catch (e) {}
    }

    ;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        int hello = duration; // Temporary variable to update selection

        return Container(
          color: Colors.white,
          height: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Period length",
                    style: GoogleFonts.sortsMillGoudy().copyWith(
                      fontSize: 18,
                    )),
              ),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 40, // Height of each item
                  scrollController:
                      FixedExtentScrollController(initialItem: duration - 2),
                  onSelectedItemChanged: (index) {
                    hello = index + 2; // Store selected value
                  },
                  children: List.generate(
                      6,
                      (index) =>
                          Text("${index + 2}", style: TextStyle(fontSize: 20))),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("CANCEL",
                        style: GoogleFonts.sortsMillGoudy()
                            .copyWith(color: Color(0xFFDC010E), fontSize: 14)),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        duration = hello; // Update UI
                      });
                      update(hello);
                    },
                    child: Text("OK",
                        style: GoogleFonts.sortsMillGoudy()
                            .copyWith(color: Color(0xFFDC010E), fontSize: 14)),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Color(0xFFDC010E),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close_sharp),
            color: Colors.white,
          ),
          title: Text("Cycle",
              style:
                  GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white))),
      body: ListView(
        children: [
          ListTile(
            title: Text("Cycle length", style: GoogleFonts.sortsMillGoudy()),
            subtitle: Text(length.toString()),
            onTap: () {
              cycleLength();
            },
          ),
          ListTile(
            title: Text("Period length", style: GoogleFonts.sortsMillGoudy()),
            subtitle: Text(duration.toString()),
            onTap: () {
              cycleDuration();
            },
          )
        ],
      ),
    );
  }
}
