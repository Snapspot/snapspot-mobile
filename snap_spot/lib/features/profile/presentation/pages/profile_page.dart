import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snap_spot/core/themes/app_colors.dart';
import 'package:snap_spot/features/settings/presentation/pages/setting_page.dart';
import '../../../../shared/widgets/custom_drawer.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../data/user_mock.dart';
import '../../domain/model/user_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = User.fromJson(mockUserJson);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          // Banner + avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(user.backgroundUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Builder(
                    builder: (context) => GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.menu, size: 24),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                left: 0,
                right: 0,
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: NetworkImageWithFallback(
                            imageUrl: user.avatarUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.teal[700],
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _infoRow("Email", user.email),
                const Divider(
                  color: AppColors.green,
                ),
                _infoRow("SĐT", user.phone),
                const Divider(
                  color: AppColors.green,
                ),
                _infoRow("Sinh nhật", formatDate(user.birthdate)),
                const Divider(
                  color: AppColors.green,
                  height: 32,
                ),
                _actionTile(Icons.edit, 'Chỉnh sửa thông tin', Colors.blue, (){}),
                _actionTile(Icons.settings, 'Cài đặt', Colors.teal, (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                }),
                _actionTile(Icons.logout, 'Đăng xuất', Colors.red,  (){}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _actionTile(IconData icon, String title, Color iconColor, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: iconColor.withOpacity(0.2),
        highlightColor: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 16),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }



  String formatDate(String isoDate) {
    final parts = isoDate.split('-');
    if (parts.length != 3) return isoDate;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
}
