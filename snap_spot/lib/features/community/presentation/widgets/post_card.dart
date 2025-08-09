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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.userAvatarUrl),
            ),
            title: Text(
              post.userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("📍 ${post.location}"),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),

          // Post Content
          if (post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ExpandableText(
                text: post.content,
                style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
              ),
            ),

          // Carousel Images
          if (post.imageUrls.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: CustomCarousel(
                itemCount: post.imageUrls.length,
                height: dynamicHeight,
                itemBuilder: (_, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: NetworkImageWithFallback(
                    imageUrl: post.imageUrls[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 8),
          const Divider(height: 1),

          // Like & Comment Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Likes
                Row(
                  children: [
                    const Icon(Icons.favorite_border, color: Colors.redAccent),
                    const SizedBox(width: 6),
                    Text(
                      post.likes >= 1000
                          ? "${(post.likes / 1000).toStringAsFixed(1)}k"
                          : "${post.likes}",
                      style: const TextStyle(color: AppColors.textSecondary),
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
                      builder: (_) => CommentModal(comments: const []), // Không có danh sách comment
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        "${post.comments}",
                        style: const TextStyle(color: AppColors.textSecondary),
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
