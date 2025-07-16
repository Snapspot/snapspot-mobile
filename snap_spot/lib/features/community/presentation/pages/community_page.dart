import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/custom_drawer.dart';
import '../../../profile/data/user_mock.dart';
import '../../../profile/domain/model/user_model.dart';
import '../../data/mock_post_data.dart';
import '../../domain/models/post_model.dart';
import '../widgets/post_card.dart';
import 'create_post_page.dart';


class CommunityPage extends StatefulWidget {
  final String? spotName;

  const CommunityPage({super.key, this.spotName});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late List<Post> allPosts;
  late List<Post> filteredPosts;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    _loadPosts();
    currentUser = User.fromJson(mockUserJson);
  }

  void _loadPosts() {
    allPosts = mockPostData.map((e) => Post.fromJson(e)).toList();
    filteredPosts = widget.spotName != null
        ? allPosts
        .where((p) =>
    p.location.trim().toLowerCase() ==
        widget.spotName!.trim().toLowerCase())
        .toList()
        : allPosts;
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _loadPosts();
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
              ).then((_) => _handleRefresh()); // làm mới sau khi quay lại
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
                    backgroundImage: NetworkImage(currentUser.avatarUrl),
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
              child: filteredPosts.isEmpty
                  ? const Center(
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
              )
                  : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 12),
                itemCount: filteredPosts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return PostCard(post: filteredPosts[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
