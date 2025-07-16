import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/expandable_text.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../../../shared/widgets/service_chip.dart';
import '../../domain/models/agency_model.dart';

class AgencyInfoPage extends StatefulWidget {
  final AgencyModel agency;

  const AgencyInfoPage({super.key, required this.agency});

  @override
  State<AgencyInfoPage> createState() => _AgencyInfoPageState();
}

class _AgencyInfoPageState extends State<AgencyInfoPage> {
  bool _showAllReviews = false;
  final int _initialReviewsToShow = 2;
  late final DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _dateFormat = DateFormat('dd/MM/yyyy');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final displayedReviews = _showAllReviews
    //     ? widget.agency.reviews
    //     : widget.agency.reviews.take(_initialReviewsToShow).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            iconTheme: const IconThemeData(color: AppColors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'agency-${widget.agency.id}',
                    child: NetworkImageWithFallback(
                      imageUrl: widget.agency.avatarUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.agency.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.starYellow, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              widget.agency.rating.toStringAsFixed(1),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Text(
                            //   '(${widget.agency.reviews.length} đánh giá)',
                            //   style: theme.textTheme.bodyMedium?.copyWith(
                            //     color: Colors.white.withOpacity(0.9),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact Info Section
                  _buildContactCard(),
                  const SizedBox(height: 16),

                  // Services Section
                  if (widget.agency.services.isNotEmpty) _buildServicesSection(),
                  if (widget.agency.services.isNotEmpty) const SizedBox(height: 16),

                  // About Section
                  _buildAboutSection(),
                  const SizedBox(height: 16),

                  // Reviews Section
                  // _buildReviewsSection(displayedReviews),
                  const SizedBox(height: 16),

                  // Call to Action
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showContactOptions,
                      icon: const Icon(Icons.phone),
                      label: const Text('Liên hệ ngay'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.person, widget.agency.fullname),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.phone, widget.agency.phoneNumber),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.location_on, widget.agency.address),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dịch vụ cung cấp',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.agency.services.map((service) => ServiceChip(
                name: service.name,
                color: service.color,
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Giới thiệu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.agency.description.isNotEmpty
                  ? widget.agency.description
                  : 'Chưa có thông tin giới thiệu.',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.business, size: 20, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Thuộc công ty: ${widget.agency.companyName}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
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

  // Widget _buildReviewsSection(List<Review> displayedReviews) {
  //   return Card(
  //     elevation: 0,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       side: BorderSide(color: Colors.grey.shade200),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const Text(
  //                 'Đánh giá',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               if (widget.agency.reviews.isNotEmpty)
  //                 Text(
  //                   '${widget.agency.reviews.length} đánh giá',
  //                   style: const TextStyle(
  //                     color: AppColors.primary,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //             ],
  //           ),
  //           const SizedBox(height: 12),
  //
  //           if (widget.agency.reviews.isEmpty)
  //             const Padding(
  //               padding: EdgeInsets.symmetric(vertical: 16),
  //               child: Center(
  //                 child: Text(
  //                   'Chưa có đánh giá nào',
  //                   style: TextStyle(
  //                     color: Colors.grey,
  //                     fontStyle: FontStyle.italic,
  //                   ),
  //                 ),
  //               ),
  //             )
  //           else
  //             Column(
  //               children: [
  //                 ...displayedReviews.map((review) => _buildReviewItem(review)),
  //                 if (widget.agency.reviews.length > _initialReviewsToShow)
  //                   TextButton(
  //                     onPressed: () {
  //                       setState(() {
  //                         _showAllReviews = !_showAllReviews;
  //                       });
  //                     },
  //                     child: Text(
  //                       _showAllReviews ? 'Thu gọn' : 'Xem thêm đánh giá',
  //                       style: const TextStyle(color: AppColors.primary),
  //                     ),
  //                   ),
  //               ],
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildReviewItem(Review review) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             CircleAvatar(
  //               radius: 20,
  //               backgroundImage: NetworkImage(review.userAvatar),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     review.userName,
  //                     style: const TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 15,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 2),
  //                   Text(
  //                     _dateFormat.format(review.date),
  //                     style: const TextStyle(
  //                       color: Colors.grey,
  //                       fontSize: 12,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Row(
  //               children: [
  //                 const Icon(Icons.star, color: AppColors.starYellow, size: 16),
  //                 const SizedBox(width: 4),
  //                 Text(review.rating.toStringAsFixed(1)),
  //               ],
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           review.comment,
  //           style: const TextStyle(fontSize: 14),
  //         ),
  //         const SizedBox(height: 8),
  //         if (review.images.isNotEmpty)
  //           SizedBox(
  //             height: 80,
  //             child: ListView.separated(
  //               scrollDirection: Axis.horizontal,
  //               itemCount: review.images.length,
  //               separatorBuilder: (_, __) => const SizedBox(width: 8),
  //               itemBuilder: (context, index) {
  //                 return ClipRRect(
  //                   borderRadius: BorderRadius.circular(8),
  //                   child: Image.network(
  //                     review.images[index],
  //                     width: 80,
  //                     height: 80,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  void _showContactOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Liên hệ với chúng tôi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.phone, color: AppColors.primary),
                  title: const Text('Gọi điện thoại'),
                  subtitle: Text(widget.agency.phoneNumber),
                  onTap: () {
                    // Implement call functionality
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.message, color: AppColors.primary),
                  title: const Text('Nhắn tin Zalo'),
                  onTap: () {
                    // Implement Zalo messaging
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.email, color: AppColors.primary),
                  title: const Text('Gửi email'),
                  onTap: () {
                    // Implement email functionality
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}