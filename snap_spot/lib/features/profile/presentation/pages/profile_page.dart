import 'package:flutter/material.dart';

import '../../../../shared/widgets/custom_drawer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Thông tin người dùng')),
    );
  }
}
