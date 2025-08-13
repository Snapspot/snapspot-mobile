import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../data/datasources/remote/community_repository.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../../../shared/widgets/expandable_text.dart';
import '../../../../shared/widgets/custom_carousel.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/models/post_model.dart';
import 'comment_modal.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final CommunityRepository? communityRepository;

  const PostCard({
    super.key,
    required this.post,
    this.communityRepository,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiking = false;
  late int _currentLikes;
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _currentLikes = widget.post.likes;
    _isLiked = false; // Có thể cải thiện bằng cách check từ server
  }

  Future<void> _handleLike() async {
    // Kiểm tra đăng nhập
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      _showLoginRequiredDialog();
      return;
    }

    if (_isLiking) return;

    // Lưu trạng thái hiện tại để rollback nếu lỗi
    final previousLikes = _currentLikes;
    final previousLiked = _isLiked;

    setState(() {
      _isLiking = true;
      // Optimistic update - cập nhật UI trước khi gọi API
      if (_isLiked) {
        _currentLikes--;
      } else {
        _currentLikes++;
      }
      _isLiked = !_isLiked;
    });

    try {
      // Sử dụng repository được truyền vào hoặc tạo mới với token
      CommunityRepository repository;
      if (widget.communityRepository != null) {
        repository = widget.communityRepository!;
      } else {
        repository = CommunityRepository(accessToken: authProvider.accessToken);
      }

      // Sử dụng method toggle
      final success = await repository.toggleLikePost(widget.post.id, previousLiked);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(_isLiked ? 'Đã thích bài đăng' : 'Đã bỏ thích'),
              ],
            ),
            backgroundColor: _isLiked ? Colors.green : Colors.grey,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        // API thất bại - rollback UI
        if (mounted) {
          setState(() {
            _currentLikes = previousLikes;
            _isLiked = previousLiked;
          });
        }
      }
    } catch (e) {
      // Lỗi xảy ra - rollback UI
      if (mounted) {
        setState(() {
          _currentLikes = previousLikes;
          _isLiked = previousLiked;
        });

        print('Like error: $e'); // Debug log

        String errorMessage = e.toString();

        // Xử lý lỗi cụ thể
        if (errorMessage.contains('Token hết hạn') || errorMessage.contains('401')) {
          errorMessage = 'Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại';
          // Có thể logout user tại đây
          // authProvider.logout();
        } else if (errorMessage.contains('Vui lòng đăng nhập')) {
          _showLoginRequiredDialog();
          return;
        } else if (errorMessage.contains('NetworkException:')) {
          errorMessage = errorMessage.replaceAll('NetworkException: ', '');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLiking = false;
        });
      }
    }
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yêu cầu đăng nhập'),
        content: const Text('Bạn cần đăng nhập để thích bài đăng này.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to login page
              // Navigator.pushNamed(context, '/login');
            },
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }

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
              backgroundImage: NetworkImage(widget.post.userAvatarUrl),
              onBackgroundImageError: (_, __) {},
              child: widget.post.userAvatarUrl.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(
              widget.post.userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("📍 ${widget.post.location}"),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // TODO: Implement more options
              },
            ),
          ),

          // Post Content
          if (widget.post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ExpandableText(
                text: widget.post.content,
                style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
              ),
            ),

          // Carousel Images
          if (widget.post.imageUrls.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: CustomCarousel(
                itemCount: widget.post.imageUrls.length,
                height: dynamicHeight,
                itemBuilder: (_, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: NetworkImageWithFallback(
                    imageUrl: widget.post.imageUrls[index],
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
                GestureDetector(
                  onTap: _handleLike,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        if (_isLiking)
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _isLiked ? Colors.redAccent : Colors.grey,
                              ),
                            ),
                          )
                        else
                          Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            color: _isLiked ? Colors.redAccent : Colors.grey,
                          ),
                        const SizedBox(width: 6),
                        Text(
                          _currentLikes >= 1000
                              ? "${(_currentLikes / 1000).toStringAsFixed(1)}k"
                              : "$_currentLikes",
                          style: TextStyle(
                            color: _isLiked ? Colors.redAccent : AppColors.textSecondary,
                            fontWeight: _isLiked ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Comments
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => CommentModal(comments: const []),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          "${widget.post.comments}",
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
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