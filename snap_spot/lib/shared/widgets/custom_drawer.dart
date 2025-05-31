import 'package:flutter/material.dart';
import 'package:snap_spot/core/themes/app_colors.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/setting_page.dart';
import 'network_image_with_fallback.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final String avatar;

  const CustomDrawer({
    super.key,
    this.userName = "Quyền đẹp trai",
    this.avatar = "https://tinhte.edu.vn/wp-content/uploads/2024/04/tokuda-la-ai.jpg",
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.green,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white12,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Đóng Drawer
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: NetworkImageWithFallback(
                      imageUrl: avatar,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Xin chào, $userName",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            title: 'Home',
            destination: HomePage(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: 'Settings',
            destination: const SettingPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget destination,
      }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: Colors.white24,
      onTap: () {
        Navigator.pop(context); // Đóng Drawer
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => destination),
        );
      },
    );
  }
}
