import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snap_spot/core/themes/app_colors.dart';
import 'package:snap_spot/features/auth/presentation/pages/login_page.dart';
import 'package:snap_spot/features/auth/presentation/providers/auth_provider.dart';
import '../../../../shared/widgets/custom_drawer.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../settings/presentation/pages/setting_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showOwnPosts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const CustomDrawer(),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!authProvider.isAuthenticated || authProvider.user == null) {
            return _buildUnauthenticatedView(context);
          }

          final user = authProvider.user!;
          // final List<String> currentPosts =
          // showOwnPosts ? user.posts : user.savedPosts;

          return RefreshIndicator(
            onRefresh: () => authProvider.refreshUserProfile(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(context),
                  _buildProfileInfo(user),
                  _buildActionButtons(context),
                  _buildUserDetails(user),
                  _buildPostSwitcher(),
                  // _buildPostsGrid(currentPosts),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnauthenticatedView(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Back button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()
                      )),
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Error content
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Không thể tải thông tin người dùng',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Vui lòng đăng nhập lại',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()
                          )),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Đăng nhập'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://images.unsplash.com/photo-1506744038136-46273834b3fb"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Menu button (mở drawer)
                Builder(
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
                // Settings button (chuyển trang)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.settings, size: 24),
                  ),
                ),
              ],
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
                      imageUrl: "https://avatars.githubusercontent.com/u/169139992?v=4",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _showFeatureInDevelopment(context),
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.camera_alt,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(user) {
    return Column(
      children: [
        const SizedBox(height: 60),
        Text(
          user.fullName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildProfileButton("Sửa hồ sơ", () {
              // TODO: Implement edit dialog
            }),
            const SizedBox(width: 8),
            _buildProfileButton("Chia sẻ hồ sơ", () {
              _showFeatureInDevelopment(context,
                  message: "Tính năng chia sẻ hồ sơ đang phát triển");
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildUserDetails(user) {
    final hasPhoneNumber = user.phoneNumber?.isNotEmpty ?? false;
    final hasDob = user.dob != null;

    if (!hasPhoneNumber && !hasDob) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 8),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 24),
        //   child: Text(
        //     user.bio,
        //     textAlign: TextAlign.center,
        //     style: const TextStyle(color: Colors.black87),
        //   ),
        // ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              if (hasPhoneNumber)
                _buildInfoRow(
                  icon: Icons.phone,
                  text: user.phoneNumber,
                ),
              if (hasDob)
                _buildInfoRow(
                  icon: Icons.cake,
                  text: DateFormat('dd/MM/yyyy').format(user.dob),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPostSwitcher() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _togglePostView(true),
                icon: Icon(
                  Icons.grid_view,
                  color: showOwnPosts ? AppColors.primary : Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _togglePostView(false),
                icon: Icon(
                  Icons.bookmark,
                  color: !showOwnPosts ? AppColors.primary : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildPostsGrid(List<String> currentPosts) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     child: currentPosts.isEmpty
  //         ? _buildEmptyPostsView()
  //         : GridView.builder(
  //             shrinkWrap: true,
  //             physics: const NeverScrollableScrollPhysics(),
  //             itemCount: currentPosts.length,
  //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 3,
  //               crossAxisSpacing: 8,
  //               mainAxisSpacing: 8,
  //               childAspectRatio: 1,
  //             ),
  //             itemBuilder: (context, index) => _buildPostItem(currentPosts[index]),
  //           ),
  //   );
  // }

  // Widget _buildEmptyPostsView() {
  //   return Container(
  //     height: 200,
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(
  //             showOwnPosts ? Icons.photo_library : Icons.bookmark,
  //             size: 48,
  //             color: Colors.grey,
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             showOwnPosts
  //                 ? 'Chưa có bài viết nào'
  //                 : 'Chưa có bài viết đã lưu',
  //             style: const TextStyle(color: Colors.grey),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildPostItem(String imageUrl) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(8),
  //       color: AppColors.primary,
  //       image: DecorationImage(
  //         image: NetworkImage(imageUrl),
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildProfileButton(String title, VoidCallback onPressed) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: onPressed,
      child: Text(title),
    );
  }

  void _togglePostView(bool showOwn) {
    setState(() {
      showOwnPosts = showOwn;
    });
  }

  void _showFeatureInDevelopment(BuildContext context, {String? message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Tính năng thay đổi ảnh đại diện đang phát triển'),
      ),
    );
  }
}