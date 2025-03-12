import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';

class Bmi extends StatefulWidget {
  const Bmi({super.key});

  @override
  State<Bmi> createState() => _BmiState();
}

class _BmiState extends State<Bmi> {
  String bmiRemark = "";

  Future<void> update() async {
    final data = await supabase
        .from('tbl_user')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .single();
    double weight = double.parse(data['user_weight']);
    double height = double.parse(data['user_height']);
    double yob = double.parse(data['user_yob']);
    double age = DateTime.now().year - yob;
    double bmi = weight / ((height / 100) * (height / 100));
    String remark = "";
    if (age > 20) {
      if (bmi < 18.5) {
        remark = "Underweight";
      } else if (bmi >= 18.5 && bmi <= 24.9) {
        remark = "Normal";
      } else if (bmi >= 25 && bmi <= 29.9) {
        remark = "Overweight";
      } else {
        remark = "Obsese";
      }
    } else {
      remark =
          "You are under 20yrs and still growing. We do not have adequate information to calculate child BMI";
    }

    setState(() {
      bmiRemark = remark;
    });
    try {
      await supabase
          .from('tbl_user')
          .update({'user_bmi': bmi, 'user_bmiRemark': remark}).eq(
        'user_id',
        supabase.auth.currentUser!.id,
      );

      // Close the modal after updating
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    update();
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
          "Body Mass Index",
          style: GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Category", style: GoogleFonts.sortsMillGoudy()),
            subtitle: Text(
              bmiRemark,
              style: GoogleFonts.sortsMillGoudy(),
            ),
          ),
        ],
      ),
    );
  }
}
