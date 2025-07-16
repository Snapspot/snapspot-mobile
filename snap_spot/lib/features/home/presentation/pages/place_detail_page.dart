// place_detail_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../community/data/mock_post_data.dart';
import '../../../community/domain/models/post_model.dart';
import '../../../community/presentation/pages/community_page.dart';
import '../../domain/models/spot_model.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../../../shared/widgets/service_chip.dart';
import 'agency_info_page.dart';

class PlaceDetailPage extends StatelessWidget {
  final SpotModel spot;

  const PlaceDetailPage({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280.0,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.background,
            iconTheme: const IconThemeData(color: AppColors.white),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'place-image-${spot.id}',
                    child: NetworkImageWithFallback(
                      imageUrl: spot.imageUrl.isNotEmpty
                          ? spot.imageUrl
                          : 'https://via.placeholder.com/300',
                      width: double.infinity,
                      height: double.infinity,
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
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.1, 0.7, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: kToolbarHeight + 60,
                    left: 16,
                    right: 16,
                    child: Text(
                      spot.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 30,
                        fontFamily: 'Libre Baskerville',
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: AppColors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chức năng Yêu thích chưa được triển khai.')),
                  );
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                _buildSectionTitle('Mô Tả'),
                const SizedBox(height: 8),
                Text(
                  spot.description,
                  style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 20),

                _buildSectionTitle('Vị Trí'),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, size: 20, color: AppColors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${spot.address}, ${spot.districtName}, ${spot.provinceName}',
                        style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: const Text('Xem vị trí trên bản đồ'),
                    onPressed: () => _openGoogleMaps(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonBlue,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                _buildSectionTitle('Các Công Ty Dịch Vụ'),
                const SizedBox(height: 12),

                spot.agencies.isEmpty
                    ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                      color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                  child: const Center(
                    child: Text(
                      "Không có công ty dịch vụ nào được liên kết tại địa điểm này.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                )
                    : Column(
                  children: spot.agencies.map((agency) {
                    return Card(
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(agency.avatarUrl),
                        ),
                        title: Text(
                          agency.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                        Text('${agency.fullname} - ${agency.phoneNumber}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 18),
                            Text(agency.rating.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AgencyInfoPage(agency: agency),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                _buildSectionTitle('Bài đăng liên quan'),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.groups_2, color: AppColors.green),
                          SizedBox(width: 8),
                          Text(
                            'Cộng đồng SnapSpot',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Khám phá những khoảnh khắc chân thực từ cộng đồng tại địa điểm này.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CommunityPage(spotName: spot.name),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            backgroundColor: AppColors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Xem các bài đăng",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openGoogleMaps(BuildContext context) async {
    try {
      final String fullAddress = '${spot.name}, ${spot.address}, ${spot.districtName}, ${spot.provinceName}';
      final String encodedAddress = Uri.encodeComponent(fullAddress);
      final Uri googleMapsUri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$encodedAddress');

      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar(context, 'Không thể mở Google Maps');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Đã xảy ra lỗi khi mở bản đồ');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    );
  }
}
