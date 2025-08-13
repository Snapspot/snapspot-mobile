import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../data/datasources/remote/community_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/models/comment_model.dart';

class CommentModal extends StatefulWidget {
  final String postId;
  final List<Comment> initialComments;

  const CommentModal({
    super.key,
    required this.postId,
    this.initialComments = const [],
  });

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late CommunityRepository _repository;
  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isPosting = false;
  String? _errorMessage;
  bool _hasNewComment = false; // Thêm biến để track comment mới

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.initialComments);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _repository = CommunityRepository(accessToken: authProvider.accessToken);

    if (_comments.isEmpty) {
      _fetchComments();
    } else {
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchComments() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final comments = await _repository.fetchCommentsByPostId(widget.postId);

      if (mounted) {
        setState(() {
          _comments = comments;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Lỗi khi tải bình luận: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _postComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      _showLoginRequiredDialog();
      return;
    }

    try {
      setState(() {
        _isPosting = true;
      });

      final newComment = await _repository.postComment(widget.postId, content);

      if (newComment != null && mounted) {
        print('New comment posted, setting _hasNewComment = true');
        setState(() {
          _comments.insert(0, newComment);
          _isPosting = false;
          _hasNewComment = true; // Set true khi có comment mới
        });

        _commentController.clear();

        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã đăng bình luận'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });

        String errorMessage = e.toString();
        if (errorMessage.contains('Token hết hạn') || errorMessage.contains('401')) {
          errorMessage = 'Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại';
        } else if (errorMessage.contains('Vui lòng đăng nhập')) {
          _showLoginRequiredDialog();
          return;
        } else if (errorMessage.contains('NetworkException:')) {
          errorMessage = errorMessage.replaceAll('NetworkException: ', '');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yêu cầu đăng nhập'),
        content: const Text('Bạn cần đăng nhập để bình luận.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _hasNewComment);
        return false;
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.only(top: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    'Bình luận',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _isLoading ? null : _fetchComments,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context, _hasNewComment),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 1),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchComments,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              )
                  : _comments.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Chưa có bình luận nào',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Hãy là người đầu tiên bình luận!',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              )
                  : RefreshIndicator(
                onRefresh: _fetchComments,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _comments.length,
                  itemBuilder: (_, index) {
                    final comment = _comments[index];
                    final timeAgo = _formatTimeAgo(comment.timestamp);

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: comment.userAvatarUrl.isNotEmpty
                                ? NetworkImage(comment.userAvatarUrl)
                                : null,
                            child: comment.userAvatarUrl.isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      comment.userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (comment.spotName != null) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          comment.spotName!,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.blue.shade800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment.content,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  timeAgo,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const Divider(height: 1),
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: authProvider.user?.avatarUrl?.isNotEmpty == true
                              ? NetworkImage(authProvider.user!.avatarUrl!)
                              : null,
                          child: authProvider.user?.avatarUrl?.isNotEmpty != true
                              ? const Icon(Icons.person, size: 16)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: authProvider.isAuthenticated
                                  ? 'Viết bình luận...'
                                  : 'Đăng nhập để bình luận...',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              isDense: true,
                            ),
                            enabled: authProvider.isAuthenticated && !_isPosting,
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _postComment(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _isPosting
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : IconButton(
                          icon: const Icon(Icons.send, color: Colors.blueAccent),
                          onPressed: authProvider.isAuthenticated &&
                              _commentController.text.trim().isNotEmpty &&
                              !_isPosting
                              ? _postComment
                              : null,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return DateFormat('dd/MM/yyyy').format(time);
  }
}