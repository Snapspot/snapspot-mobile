import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/custom_drawer.dart';
import '../../data/mock_post_data.dart';
import '../../domain/models/post_model.dart';
import '../widgets/post_card.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = mockPostData.map((e) => Post.fromJson(e)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cộng Đồng'),
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (_, index) => Padding(
          padding: const EdgeInsets.only(bottom: 8), // spacing between posts
          child: PostCard(post: posts[index]),
        ),
      ),
    );
  }
}
