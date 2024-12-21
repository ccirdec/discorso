import 'package:discorso/components/my_drawer_tile.dart';
import 'package:discorso/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 72,
                  color:Theme.of(context).colorScheme.primary,
                ),
              ),
          
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 10,),
             
              MyDrawerTile(
                title: "Home",
                icon: Icons.home,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
          
              MyDrawerTile(
                title: "Settings",
                icon: Icons.settings,
                onTap: () {
                  Navigator.pop(context);
          
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => SettingsPage(),
                    ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}