import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../profile/data/user_mock.dart';
import '../../../profile/domain/model/user_model.dart';


class CreatePostPage extends StatefulWidget {
  final String? spotName;
  final String? suggestedLocation;


  const CreatePostPage({super.key, this.spotName, this.suggestedLocation});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  Color _selectedColor = const Color(0xFFFDF1DD);
  File? _pickedImage;

  final List<Color> _colors = [
    const Color(0xFFFDF1DD),
    const Color(0xFFEFEAD8),
    const Color(0xFF1E81CE),
    const Color(0xFFE62727),
    const Color(0xFFFFF455),
    const Color(0xFFDE4ECF),
  ];

  late final User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = User.fromJson(mockUserJson);
    if (widget.spotName != null) {
      _locationController.text = widget.spotName!;
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  void _submitPost() {
    final content = _controller.text.trim();
    final location = _locationController.text.trim();

    if (content.isEmpty && _pickedImage == null) return;

    // TODO: Lưu bài đăng vào Firestore hoặc Local
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _selectedColor,
      appBar: AppBar(
        backgroundColor: _selectedColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tạo bài đăng', style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          TextButton(
            onPressed: _submitPost,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              side: const BorderSide(color: AppColors.textPrimary),
              backgroundColor: Colors.transparent,
            ),
            child: const Text("Đăng", style: TextStyle(color: AppColors.textPrimary)),
          )
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(currentUser.avatarUrl),
            ),
            title: Text(
              currentUser.name,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            subtitle: TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: "Nhập vị trí...",
                border: InputBorder.none,
              ),
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                maxLines: null,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  hintText: "Bạn đang nghĩ gì?",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          if (_pickedImage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_pickedImage!, height: 180),
              ),
            ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _colors.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == color ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Photos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}