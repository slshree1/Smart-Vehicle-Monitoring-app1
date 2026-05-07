import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final Function(bool) onDarkModeChanged;
  final Function(bool) onNotificationsChanged;

  SettingsScreen({
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.onDarkModeChanged,
    required this.onNotificationsChanged,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool isDarkMode;
  late bool notificationsEnabled;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    notificationsEnabled = widget.notificationsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (val) {
              setState(() {
                isDarkMode = val;
              });
              widget.onDarkModeChanged(val);
            },
          ),
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: notificationsEnabled,
            onChanged: (val) {
              setState(() {
                notificationsEnabled = val;
              });
              widget.onNotificationsChanged(val);
            },
          ),
        ],
      ),
    );
  }
}