import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snap_spot/core/themes/app_colors.dart';
import 'package:snap_spot/features/auth/presentation/providers/auth_provider.dart';
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
    return Drawer(
      backgroundColor: AppColors.green,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context),
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

  Widget _buildDrawerHeader(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Sử dụng user từ AuthProvider trước, nếu không có thì dùng mock
        User? user;
        String displayName = 'Người dùng';

        try {
          if (authProvider.isAuthenticated && authProvider.user != null) {
            user = authProvider.user!;
            displayName = user.fullName;
          } else {
            // Fallback to mock user với error handling
            user = _createSafeMockUser();
            displayName = user?.fullName ?? 'Người dùng';
          }
        } catch (e) {
          // Nếu có lỗi khi tạo user, sử dụng giá trị default
          debugPrint('Error creating user: $e');
          displayName = 'Người dùng';
        }

        return DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.white12,
          ),
          child: GestureDetector(
            onTap: () => _navigateToProfile(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: NetworkImageWithFallback(
                    imageUrl: user?.avatarUrl ?? '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Xin chào, $displayName",
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
        );
      },
    );
  }

  User? _createSafeMockUser() {
    try {
      // Kiểm tra mockUserJson trước khi tạo User
      if (mockUserJson.isEmpty) {
        return null;
      }

      // Tạo một bản sao an toàn của mockUserJson với các giá trị default
      final safeUserJson = Map<String, dynamic>.from(mockUserJson);

      // Đảm bảo các field bắt buộc không null
      safeUserJson['fullName'] ??= 'Người dùng';
      safeUserJson['email'] ??= 'user@example.com';
      safeUserJson['phoneNumber'] ??= '';
      safeUserJson['id'] ??= 'default_id';

      return User.fromJson(safeUserJson);
    } catch (e) {
      debugPrint('Error creating safe mock user: $e');
      return null;
    }
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.pop(context); // Đóng Drawer
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
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
      onTap: () => _navigateToDestination(context, destination),
    );
  }

  void _navigateToDestination(BuildContext context, Widget destination) {
    Navigator.pop(context); // Đóng Drawer
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }
}