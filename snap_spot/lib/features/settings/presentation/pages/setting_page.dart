import 'package:flutter/material.dart';

import '../../../../shared/widgets/custom_drawer.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('Cài đặt ứng dụng')),
    );
  }
}
