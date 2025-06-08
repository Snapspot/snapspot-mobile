// lib/features/home/presentation/pages/agency_info_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/expandable_text.dart';
import '../../domain/models/place_model.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../../../shared/widgets/service_chip.dart';

class AgencyInfoPage extends StatefulWidget {
  final Agency agency;

  const AgencyInfoPage({super.key, required this.agency});

  @override
  State<AgencyInfoPage> createState() => _AgencyInfoPageState();
}

class _AgencyInfoPageState extends State<AgencyInfoPage> {
  bool _showAllAgencyRatings = false;
  final int _agencyRatingsToShowInitially = 3;
  late final DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  }

  @override
  Widget build(BuildContext context) {
    final agencyRatings = widget.agency.individualRatings;
    // Sort ratings by date, newest first
    agencyRatings.sort((a, b) => b.date.compareTo(a.date));

    final displayedAgencyRatings = _showAllAgencyRatings
        ? agencyRatings
        : agencyRatings.take(_agencyRatingsToShowInitially).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: AppColors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  NetworkImageWithFallback(
                    imageUrl: widget.agency.logoUrl ?? '',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Agency Basic Info
                  Card(
                    elevation: 2,
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.agency.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (widget.agency.fullName.isNotEmpty && widget.agency.fullName != widget.agency.name)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                widget.agency.fullName,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary.withOpacity(0.9),
                                ),
                              ),
                            ),
                          if(widget.agency.phoneNumber != null && widget.agency.phoneNumber!.isNotEmpty) ...[
                            Row(
                              children: [
                                const Icon(Icons.phone_outlined, size: 16, color: AppColors.green),
                                const SizedBox(width: 6),
                                Text(
                                  widget.agency.phoneNumber!,
                                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                          // Rating Section
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, color: AppColors.starYellow, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  widget.agency.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${widget.agency.individualRatings.length} đánh giá)',
                                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Services Section
                  if (widget.agency.services.isNotEmpty) ...[
                    Card(
                      elevation: 1,
                      color: AppColors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dịch vụ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: widget.agency.services
                                  .map((service) => ServiceChip(
                                name: service.name,
                                color: service.color,
                              ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Reviews Section
                  Card(
                    elevation: 1,
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Đánh giá',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${agencyRatings.length}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (displayedAgencyRatings.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24.0),
                              child: const Center(
                                child: Text(
                                  'Chưa có đánh giá nào cho công ty này.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.textSecondary,
                                      fontSize: 15
                                  ),
                                ),
                              ),
                            )
                          else
                            Column(
                              children: [
                                ...displayedAgencyRatings.map((rating) =>
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: _buildAgencyRatingItem(rating, _dateFormat),
                                    )
                                ),
                                if (agencyRatings.length > _agencyRatingsToShowInitially)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _showAllAgencyRatings = !_showAllAgencyRatings;
                                          });
                                        },
                                        child: Text(
                                          _showAllAgencyRatings ? 'Thu gọn' : 'Xem thêm',
                                          style: const TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Company Info Section (if available)
                  Card(
                    elevation: 1,
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thuộc công ty',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: NetworkImageWithFallback(
                                  imageUrl: widget.agency.logoUrl ?? '',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.agency.fullName.isNotEmpty ? widget.agency.fullName : widget.agency.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (widget.agency.description != null && widget.agency.description!.isNotEmpty)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ExpandableText(text: widget.agency.description!),
                                          const SizedBox(height: 4),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Write Review Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showRatingDialog(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBlue,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Viết đánh giá',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgencyRatingItem(RatingModel rating, DateFormat dateFormat) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightGray.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: NetworkImageWithFallback(
              imageUrl: rating.userAvatarUrl ?? '',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        rating.userName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textPrimary
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      dateFormat.format(rating.date.toLocal()),
                      style: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.8),
                          fontSize: 12
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ...List.generate(
                      5,
                          (i) => Icon(
                        i < rating.stars.round() ? Icons.star : Icons.star_border,
                        color: AppColors.starYellow,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${rating.stars.toStringAsFixed(1)})',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  rating.comment,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RatingDialog(
          agencyName: widget.agency.name,
          onSubmit: (rating, comment) {
            // TODO: Implement API call to submit rating
            _handleRatingSubmit(rating, comment);
          },
        );
      },
    );
  }

  void _handleRatingSubmit(int rating, String comment) {
    // TODO: Implement actual API call here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã gửi đánh giá $rating sao cho ${widget.agency.name}'),
        backgroundColor: AppColors.green,
      ),
    );
  }
}

class RatingDialog extends StatefulWidget {
  final String agencyName;
  final Function(int rating, String comment) onSubmit;

  const RatingDialog({
    super.key,
    required this.agencyName,
    required this.onSubmit,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Đánh giá công ty FPT Tre Việt',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Rating Stars
            const Text(
              'Cảm nhận của quý khách',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRating = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      index < _selectedRating ? Icons.star : Icons.star_border,
                      color: AppColors.starYellow,
                      size: 36,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Comment TextField
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Nhập bình luận của bạn...',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.7),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.lightGray.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColors.lightGray.withOpacity(0.5)),
                      ),
                    ),
                    child: const Text(
                      'Hủy',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedRating > 0 ? () {
                      widget.onSubmit(_selectedRating, _commentController.text.trim());
                      Navigator.of(context).pop();
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonBlue,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Gửi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}