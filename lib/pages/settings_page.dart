import 'package:discorso/components/my_setting_tile.dart';
import 'package:discorso/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text("Settings"),
      foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      body:Column(
        children: [
          MySettingTile(
            title: "Dark Mode", 
            action: CupertinoSwitch(
              onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            ),)
        ],
      )
    );
  }
}