import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';

class RatingDialog extends StatefulWidget {
  final String agencyName;
  final void Function(int rating, String comment) onSubmit;

  const RatingDialog({
    super.key,
    required this.agencyName,
    required this.onSubmit,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _selectedStars = 5;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Đánh giá ${widget.agencyName}'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Chọn số sao', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _selectedStars ? Icons.star : Icons.star_border,
                    color: AppColors.starYellow,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedStars = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Viết nhận xét của bạn...',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Hủy'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: () {
            final comment = _commentController.text.trim();
            if (comment.isNotEmpty) {
              widget.onSubmit(_selectedStars, comment);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vui lòng nhập nhận xét trước khi gửi.'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonBlue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Gửi'),
        ),
      ],
    );
  }
}
