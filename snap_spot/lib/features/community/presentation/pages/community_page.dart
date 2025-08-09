import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snap_spot/features/community/domain/models/post_model.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/custom_drawer.dart';
import '../../../profile/data/user_mock.dart';
import '../../../profile/domain/model/user_model.dart';
import '../widgets/post_card.dart';
import 'create_post_page.dart';

class CommunityPage extends StatefulWidget {
  final String? spotName;
  final String? spotId; // Thêm spotId để truyền từ PlaceDetailPage

  const CommunityPage({super.key, this.spotName, this.spotId});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late Future<List<Post>> _postsFuture;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    _postsFuture = fetchPosts();
    currentUser = User.fromJson(mockUserJson);
  }

  Future<List<Post>> fetchPosts() async {
    if (widget.spotId == null) return [];
    final url = Uri.parse('http://14.225.217.24:8080/api/posts/${widget.spotId}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      if (jsonBody['success'] == true && jsonBody['data'] != null) {
        final List data = jsonBody['data'];
        if (data.isEmpty) return [];
        return data.map((e) => Post.fromApi(e)).toList();
      }
      return [];
    } else {
      throw Exception('Lỗi khi tải bài đăng');
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _postsFuture = fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.spotName != null ? 'Bài đăng tại ${widget.spotName}' : 'Cộng Đồng',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreatePostPage(
                    suggestedLocation: widget.spotName,
                  ),
                ),
              ).then((_) => _handleRefresh());
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage("https://avatars.githubusercontent.com/u/169139992?v=4"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Bạn đang nghĩ gì?',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  const Icon(Icons.edit_note_rounded, color: AppColors.green),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              edgeOffset: 12,
              displacement: 40,
              color: AppColors.green,
              child: FutureBuilder<List<Post>>(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Lỗi khi tải bài đăng.\n${snapshot.error}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  final posts = snapshot.data ?? [];
                  if (posts.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          'Không có bài đăng nào tại địa điểm này.',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    itemCount: posts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return PostCard(post: posts[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
              