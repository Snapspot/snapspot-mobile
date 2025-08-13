import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../data/datasources/remote/community_repository.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../../../shared/widgets/expandable_text.dart';
import '../../../../shared/widgets/custom_carousel.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/models/post_model.dart';
import '../../domain/models/comment_model.dart';
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
  bool _isLoadingComments = false;
  late int _currentLikes;
  late int _currentCommentsCount;
  late bool _isLiked;
  List<Comment> _cachedComments = [];

  @override
  void initState() {
    super.initState();
    _currentLikes = widget.post.likes;
    _currentCommentsCount = widget.post.comments;
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

  Future<void> _handleCommentTap() async {
    // Pre-load comments nếu chưa có
    if (_cachedComments.isEmpty && !_isLoadingComments) {
      await _preloadComments();
    }

    if (!mounted) return;

    // Show modal với comments đã load (hoặc empty list)
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentModal(
        postId: widget.post.id,
        initialComments: _cachedComments,
      ),
    );

    // Nếu có comment mới được thêm, reload comments
    if (result == true) {
      _preloadComments();
    }
  }

  Future<void> _preloadComments() async {
    if (_isLoadingComments) return;

    setState(() {
      _isLoadingComments = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final repository = CommunityRepository(accessToken: authProvider.accessToken);

      final comments = await repository.fetchCommentsByPostId(widget.post.id);

      if (mounted) {
        setState(() {
          _cachedComments = comments;
          _currentCommentsCount = comments.length;
          _isLoadingComments = false;
        });
      }
    } catch (e) {
      print('Error preloading comments: $e');
      if (mounted) {
        setState(() {
          _isLoadingComments = false;
        });
      }
    }
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yêu cầu đăng nhập'),
        content: const Text('Bạn cần đăng nhập để thực hiện hành động này.'),
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
                  onTap: _handleCommentTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        if (_isLoadingComments)
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.textSecondary,
                              ),
                            ),
                          )
                        else
                          const Icon(Icons.chat_bubble_outline, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          _currentCommentsCount >= 1000
                              ? "${(_currentCommentsCount / 1000).toStringAsFixed(1)}k"
                              : "$_currentCommentsCount",
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),

                // Share button (optional)
                // GestureDetector(
                //   onTap: () {
                //     // TODO: Implement share functionality
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //         content: Text('Tính năng chia sẻ sẽ được cập nhật sau'),
                //         backgroundColor: Colors.orange,
                //         behavior: SnackBarBehavior.floating,
                //       ),
                //     );
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //     child: const Row(
                //       children: [
                //         Icon(Icons.share_outlined, color: AppColors.textSecondary),
                //         SizedBox(width: 6),
                //         Text(
                //           'Chia sẻ',
                //           style: TextStyle(color: AppColors.textSecondary),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          // Preview comments (hiển thị 1-2 comment đầu tiên nếu có)
          if (_cachedComments.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  // Hiển thị tối đa 2 comment đầu
                  ...(_cachedComments.take(2).map((comment) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: comment.userAvatarUrl.isNotEmpty
                              ? NetworkImage(comment.userAvatarUrl)
                              : null,
                          child: comment.userAvatarUrl.isEmpty
                              ? const Icon(Icons.person, size: 12)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black87, fontSize: 13),
                              children: [
                                TextSpan(
                                  text: '${comment.userName} ',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: comment.content),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList()),

                  // Nút "Xem thêm bình luận" nếu có nhiều hơn 2 comment
                  if (_cachedComments.length > 2)
                    GestureDetector(
                      onTap: _handleCommentTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          'Xem thêm ${_cachedComments.length - 2} bình luận',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
        ],
      ),
    );
  }
}