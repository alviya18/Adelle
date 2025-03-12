import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  bool periodReminder = true;
  bool ovulationReminder = true;
  bool pregnantMode = true;
  bool irregularPeriod = true;
  bool markPeriod = true;

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
          "Notifications",
          style: GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Period Reminders",
                style: GoogleFonts.sortsMillGoudy().copyWith(fontSize: 17)),
            trailing: Switch(
              value: periodReminder,
              thumbColor: WidgetStatePropertyAll(Colors.white),
              activeTrackColor: Colors.green,
              inactiveTrackColor: const Color.fromARGB(33, 0, 0, 0),
              trackOutlineColor: WidgetStatePropertyAll(
                Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  periodReminder = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text("Ovulation Reminders",
                style: GoogleFonts.sortsMillGoudy().copyWith(fontSize: 17)),
            trailing: Switch(
              value: ovulationReminder,
              thumbColor: WidgetStatePropertyAll(Colors.white),
              activeTrackColor: Colors.green,
              inactiveTrackColor: const Color.fromARGB(33, 0, 0, 0),
              trackOutlineColor: WidgetStatePropertyAll(
                Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  ovulationReminder = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text("Pregnant Mode",
                style: GoogleFonts.sortsMillGoudy().copyWith(fontSize: 17)),
            trailing: Switch(
              value: pregnantMode,
              thumbColor: WidgetStatePropertyAll(Colors.white),
              activeTrackColor: Colors.green,
              inactiveTrackColor: const Color.fromARGB(33, 0, 0, 0),
              trackOutlineColor: WidgetStatePropertyAll(
                Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  pregnantMode = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text("Irregular Period",
                style: GoogleFonts.sortsMillGoudy().copyWith(fontSize: 17)),
            trailing: Switch(
              value: irregularPeriod,
              thumbColor: WidgetStatePropertyAll(Colors.white),
              activeTrackColor: Colors.green,
              inactiveTrackColor: const Color.fromARGB(33, 0, 0, 0),
              trackOutlineColor: WidgetStatePropertyAll(
                Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  irregularPeriod = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text("Mark Period",
                style: GoogleFonts.sortsMillGoudy().copyWith(fontSize: 17)),
            trailing: Switch(
              value: markPeriod,
              thumbColor: WidgetStatePropertyAll(Colors.white),
              activeTrackColor: Colors.green,
              inactiveTrackColor: const Color.fromARGB(33, 0, 0, 0),
              trackOutlineColor: WidgetStatePropertyAll(
                Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  markPeriod = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
