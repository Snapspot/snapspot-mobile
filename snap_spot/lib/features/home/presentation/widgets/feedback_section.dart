import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/domain/model/user_model.dart';
import '../../domain/models/feedback_model.dart';
import '../../../../data/datasources/remote/feedback_repository.dart';

class FeedbackSection extends StatefulWidget {
  final Future<List<FeedbackModel>> feedbackFuture;
  final User? user;
  final String agencyId;
  final VoidCallback onFeedbackSubmitted;

  const FeedbackSection({
    super.key,
    required this.feedbackFuture,
    required this.user,
    required this.agencyId,
    required this.onFeedbackSubmitted,
  });

  @override
  State<FeedbackSection> createState() => _FeedbackSectionState();
}

class _FeedbackSectionState extends State<FeedbackSection> {
  final TextEditingController _controller = TextEditingController();
  double _rating = 5.0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_controller.text.isEmpty || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    final authProvider = context.read<AuthProvider>();
    final repo = FeedbackRepository(authProvider);

    try {
      await repo.createFeedback(
        agencyId: widget.agencyId,
        content: _controller.text,
        rating: _rating.round(),
      );

      _controller.clear();
      widget.onFeedbackSubmitted();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đánh giá đã được gửi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Đánh giá từ người dùng", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        FutureBuilder<List<FeedbackModel>>(
          future: widget.feedbackFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return const Text("Lỗi khi tải đánh giá");
            }

            final feedbacks = snapshot.data!;
            if (feedbacks.isEmpty) {
              return const Text("Chưa có đánh giá nào.");
            }

            return Column(
              children: feedbacks.map((fb) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(fb.fullName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingBarIndicator(
                        rating: fb.rating.toDouble(),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                      Text(fb.content),
                      Text(
                        DateFormat.yMd().add_Hm().format(fb.createdAt),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 16),
        if (widget.user != null) ...[
          const Divider(height: 32),
          Text("Gửi đánh giá của bạn", style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Nhận xét...',
              border: OutlineInputBorder(),
            ),
            minLines: 2,
            maxLines: 4,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _isSubmitting ? null : _submitFeedback,
            icon: const Icon(Icons.send),
            label: const Text("Gửi đánh giá"),
          ),
        ]
      ],
    );
  }
}
