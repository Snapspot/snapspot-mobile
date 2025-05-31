import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/setting_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text("Menu", style: TextStyle(fontSize: 24))),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomePage())),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => ProfilePage())),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => SettingPage())),
          ),
        ],
      ),
    );
  }
}
