import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_adelle/main.dart';
import 'package:user_adelle/services/notification_services.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  bool periodReminder = true;
  bool ovulationReminder = true;
  bool pregnantMode = false;  // Initialize as false
  bool irregularPeriod = true;
  bool markPeriod = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  // Load saved notification settings
  Future<void> _loadNotificationSettings() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final userData = await supabase
          .from('tbl_user')
          .select('user_pregnantMode')
          .eq('user_id', userId)
          .single();
      
      setState(() {
        pregnantMode = userData['user_pregnantMode'] ?? false;
        // If pregnant mode is on, disable all other notifications
        if (pregnantMode) {
          periodReminder = false;
          ovulationReminder = false;
          irregularPeriod = false;
          markPeriod = false;
        }
      });
    } catch (e) {
      print('Error loading notification settings: $e');
    }
  }

  // Save notification settings to database
  Future<void> _saveNotificationSettings() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase
          .from('tbl_user')
          .update({'user_pregnantMode': pregnantMode})
          .eq('user_id', userId);
    } catch (e) {
      print('Error saving notification settings: $e');
    }
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
          "Notifications",
          style: GoogleFonts.sortsMillGoudy().copyWith(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Pregnant Mode",
                style: GoogleFonts.sortsMillGoudy().copyWith(fontSize: 17)),
            trailing: Switch(
              value: pregnantMode,
              thumbColor: WidgetStatePropertyAll(Colors.white),
              activeTrackColor: Colors.green,
              inactiveTrackColor: const Color.fromARGB(33, 0, 0, 0),
              trackOutlineColor: WidgetStatePropertyAll(Colors.white),
              onChanged: (value) async {
                setState(() {
                  pregnantMode = value;
                  // If pregnant mode is turned on, disable all other notifications
                  if (value) {
                    periodReminder = false;
                    ovulationReminder = false;
                    irregularPeriod = false;
                    markPeriod = false;
                    // Cancel all notifications
                    RoutineNotificationService.cancelPeriodReminders();
                  }
                });
                await _saveNotificationSettings();
              },
            ),
          ),
          ListTile(
            title: Text("Period Reminders",
                style: GoogleFonts.sortsMillGoudy().copyWith(fontSize: 17)),
            trailing: Switch(
              value: periodReminder,
              thumbColor: WidgetStatePropertyAll(Colors.white),
              activeTrackColor: Colors.green,
              inactiveTrackColor: const Color.fromARGB(33, 0, 0, 0),
              trackOutlineColor: WidgetStatePropertyAll(Colors.white),
              onChanged: pregnantMode 
                  ? null  // Disable switch if pregnant mode is on
                  : (value) async {
                      setState(() {
                        periodReminder = value;
                      });
                      
                      if (value) {
                        await RoutineNotificationService.init();
                        final nextPeriod = await supabase
                            .from('tbl_cycleDates')
                            .select('cycleDate_start')
                            .eq('user_id', supabase.auth.currentUser!.id)
                            .order('cycleDate_start', ascending: false)
                            .limit(1)
                            .single();
                            
                        if (nextPeriod != null) {
                          final lastStart = DateTime.parse(nextPeriod['cycleDate_start']);
                          final user = await supabase
                              .from('tbl_user')
                              .select('user_cycleLength')
                              .eq('user_id', supabase.auth.currentUser!.id)
                              .single();
                              
                          final cycleLength = user['user_cycleLength'] ?? 28;
                          final nextCycleStart = lastStart.add(Duration(days: cycleLength));
                          
                          await RoutineNotificationService.schedulePeriodReminder(nextCycleStart);
                        }
                      } else {
                        await RoutineNotificationService.cancelPeriodReminders();
                      }
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
              trackOutlineColor: WidgetStatePropertyAll(Colors.white),
              onChanged: pregnantMode 
                  ? null  // Disable switch if pregnant mode is on
                  : (value) {
                      setState(() {
                        ovulationReminder = value;
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
              trackOutlineColor: WidgetStatePropertyAll(Colors.white),
              onChanged: pregnantMode 
                  ? null  // Disable switch if pregnant mode is on
                  : (value) {
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
              trackOutlineColor: WidgetStatePropertyAll(Colors.white),
              onChanged: pregnantMode 
                  ? null  // Disable switch if pregnant mode is on
                  : (value) {
                      setState(() {
                        markPeriod = value;
                      });
                    },
            ),
          ),
        ],
      ),
    );
  }
}
