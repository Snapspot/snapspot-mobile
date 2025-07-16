import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snap_spot/core/themes/app_colors.dart';
import 'package:snap_spot/features/settings/presentation/pages/setting_page.dart';
import '../../../../shared/widgets/custom_drawer.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../data/user_mock.dart';
import '../../domain/model/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showOwnPosts = true;

  @override
  Widget build(BuildContext context) {
    final user = User.fromJson(mockUserJson);
    final List<String> currentPosts = showOwnPosts ? user.posts : user.savedPosts;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 160,
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
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
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
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
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
                            backgroundColor: Colors.teal,
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _profileButton("Sửa hồ sơ", () {}),
                const SizedBox(width: 8),
                _profileButton("Chia sẻ hồ sơ", () {}),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                user.bio,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black87),
              ),
            ),
            const SizedBox(height: 12),

            // Post switcher icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showOwnPosts = true;
                      });
                    },
                    icon: Icon(Icons.grid_view,
                        color: showOwnPosts ? AppColors.primary : Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showOwnPosts = false;
                      });
                    },
                    icon: Icon(Icons.bookmark,
                        color: !showOwnPosts ? AppColors.primary : Colors.grey),
                  ),
                ],
              ),
            ),

            // Posts grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currentPosts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primary,
                      image: DecorationImage(
                        image: NetworkImage(currentPosts[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _profileButton(String title, VoidCallback onPressed) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: onPressed,
      child: Text(title),
    );
  }
}