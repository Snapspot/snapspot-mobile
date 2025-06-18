import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../../../shared/widgets/expandable_text.dart';
import '../../../../shared/widgets/custom_carousel.dart';
import '../../domain/models/post_model.dart';
import 'comment_modal.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final aspectRatio = 4 / 3;
    final dynamicHeight = screenWidth / aspectRatio;

    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      elevation: 2,
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.userAvatarUrl),
            ),
            title: Text(
              post.userName,
              style: const TextStyle(fontWeight: FontWeight.bold,color: AppColors.green),
            ),
            subtitle: Text("📍 ${post.location}", style: TextStyle(color: AppColors.green)),
            trailing: const Icon(Icons.more_horiz),
          ),

          // Post Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ExpandableText(text: post.content,style: TextStyle(color: AppColors.green)),
          ),

          // Carousel Images
          if (post.imageUrls.isNotEmpty)
            CustomCarousel(
              itemCount: post.imageUrls.length,
              height: dynamicHeight,
              itemBuilder: (_, index) => NetworkImageWithFallback(
                imageUrl: post.imageUrls[index],
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Likes
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Text(
                      "${post.likes ~/ 1000}.${(post.likes % 1000) ~/ 100}k",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                // Comments
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => CommentModal(comments: post.comments),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.chat_bubble_outline, color: AppColors.gray),
                      const SizedBox(width: 4),
                      Text(
                        "${post.comments.length}",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
