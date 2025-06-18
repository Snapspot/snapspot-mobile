import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/comment_model.dart';

class CommentModal extends StatelessWidget {
  final List<Comment> comments;

  const CommentModal({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Bọc toàn bộ modal
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
          const Text(
            'Bình luận',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: DraggableScrollableSheet(
              expand: true,
              initialChildSize: 1.0,
              minChildSize: 0.4,
              maxChildSize: 1.0,
              builder: (_, controller) {
                if (comments.isEmpty) {
                  return const Center(
                    child: Text(
                      'Chưa có bình luận nào',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: comments.length,
                  itemBuilder: (_, index) {
                    final comment = comments[index];
                    final timeAgo = _formatTimeAgo(comment.timestamp);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(comment.userAvatarUrl),
                        ),
                        title: Text(comment.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment.content),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('$timeAgo • ',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                                const Icon(Icons.favorite,
                                    color: Colors.redAccent, size: 16),
                                const SizedBox(width: 4),
                                Text('${comment.likes}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Thanh nhập bình luận
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=4'), // TODO: Thay bằng avatar người dùng thật
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Viết bình luận...',
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blueAccent),
                    onPressed: () {
                      // TODO: Gửi bình luận
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return DateFormat('dd/MM/yyyy').format(time);
  }
}
