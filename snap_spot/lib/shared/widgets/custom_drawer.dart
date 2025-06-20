import 'package:flutter/material.dart';
import 'package:snap_spot/core/themes/app_colors.dart';
import '../../features/community/presentation/pages/community_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/data/user_mock.dart';
import '../../features/profile/domain/model/user_model.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/setting_page.dart';
import 'network_image_with_fallback.dart';

class CustomDrawer extends StatelessWidget {


  const CustomDrawer({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    final User user = User.fromJson(mockUserJson);

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
                      imageUrl: user.avatarUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Xin chào, ${user.name}",
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
            title: 'Trang chủ',
            destination: HomePage(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.group,
            title: 'Cộng đồng',
            destination: const CommunityPage(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: 'Cài đặt',
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
