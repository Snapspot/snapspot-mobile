// lib/features/home/presentation/pages/place_detail_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Thêm dependency này
import '../../../../core/themes/app_colors.dart';
import '../../domain/models/place_model.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../../../shared/widgets/service_chip.dart';
import 'agency_info_page.dart';

class PlaceDetailPage extends StatelessWidget {
  final Place place;

  const PlaceDetailPage({super.key, required this.place});

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
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: AppColors.white),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'place-image-${place.id}',
                    child: NetworkImageWithFallback(
                      imageUrl: place.imageUrl,
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
                      place.name,
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
                  place.description,
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
                        '${place.address}, ${place.district.name}, ${place.district.province.name}',
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

                _buildSectionTitle('Các Công Ty Dịch Vụ (${place.agencies.length})'),
                const SizedBox(height: 12),

                if (place.agencies.isNotEmpty)
                  ...place.agencies.map((agency) => _buildAgencyCard(context, agency)).toList()
                else
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: const Center(
                      child: Text(
                        "Không có công ty dịch vụ nào được liên kết tại địa điểm này.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 15, fontStyle: FontStyle.italic),
                      ),
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

  // Hàm mở Google Maps
  Future<void> _openGoogleMaps(BuildContext context) async {
    try {
      if (place.latitude != null && place.longitude != null) {
        final Uri googleMapsUri = Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}');
        debugPrint('Trying to open Google Maps with coordinates: $googleMapsUri');
        if (await canLaunchUrl(googleMapsUri)) {
          await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint('Cannot launch URL: $googleMapsUri');
          _showErrorSnackBar(context, 'Không thể mở Google Maps');
        }
      } else {
        final String fullAddress = '${place.address}, ${place.district.name}, ${place.district.province.name}';
        final String encodedAddress = Uri.encodeComponent(fullAddress);
        final Uri googleMapsUri = Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=$encodedAddress');
        debugPrint('Trying to open Google Maps with address: $googleMapsUri');
        if (await canLaunchUrl(googleMapsUri)) {
          await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint('Cannot launch URL: $googleMapsUri');
          _showErrorSnackBar(context, 'Không thể mở Google Maps');
        }
      }
    } catch (e) {
      debugPrint('Error opening Google Maps: $e');
      _showErrorSnackBar(context, 'Đã xảy ra lỗi khi mở bản đồ');
    }
  }


  // Hàm mở Google Maps với nhiều tùy chọn
  Future<void> _openGoogleMapsAdvanced(BuildContext context) async {
    try {
      List<String> mapOptions = [];

      if (place.latitude != null && place.longitude != null) {
        // Tọa độ chính xác
        mapOptions.add('https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}');

        // Mở trực tiếp trong Google Maps app (nếu có cài đặt)
        mapOptions.add('geo:${place.latitude},${place.longitude}?q=${place.latitude},${place.longitude}(${Uri.encodeComponent(place.name)})');

        // Google Maps với label
        mapOptions.add('https://www.google.com/maps/place/${place.latitude},${place.longitude}/@${place.latitude},${place.longitude},17z');
      } else {
        // Tìm kiếm bằng địa chỉ
        final String fullAddress = '${place.name}, ${place.address}, ${place.district.name}, ${place.district.province.name}';
        final String encodedAddress = Uri.encodeComponent(fullAddress);
        mapOptions.add('https://www.google.com/maps/search/?api=1&query=$encodedAddress');
      }

      // Thử từng option cho đến khi có cái nào work
      for (String mapUrl in mapOptions) {
        final Uri uri = Uri.parse(mapUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        }
      }

      _showErrorSnackBar(context, 'Không thể mở Google Maps');
    } catch (e) {
      _showErrorSnackBar(context, 'Đã xảy ra lỗi khi mở bản đồ');
      debugPrint('Error opening Google Maps: $e');
    }
  }

  // Hiển thị dialog lựa chọn cách mở bản đồ
  Future<void> _showMapOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Chọn cách xem bản đồ',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              ListTile(
                leading: const Icon(Icons.map, color: AppColors.primary),
                title: const Text('Google Maps'),
                subtitle: const Text('Mở trong ứng dụng Google Maps'),
                onTap: () {
                  Navigator.pop(context);
                  _openGoogleMaps(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.web, color: AppColors.primary),
                title: const Text('Trình duyệt web'),
                subtitle: const Text('Mở Google Maps trong trình duyệt'),
                onTap: () {
                  Navigator.pop(context);
                  _openGoogleMapsInBrowser(context);
                },
              ),

              if (place.latitude != null && place.longitude != null)
                ListTile(
                  leading: const Icon(Icons.navigation, color: AppColors.primary),
                  title: const Text('Chỉ đường'),
                  subtitle: const Text('Mở chỉ đường trong Google Maps'),
                  onTap: () {
                    Navigator.pop(context);
                    _openGoogleMapsDirections(context);
                  },
                ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // Mở Google Maps trong trình duyệt
  Future<void> _openGoogleMapsInBrowser(BuildContext context) async {
    try {
      String mapUrl;
      if (place.latitude != null && place.longitude != null) {
        mapUrl = 'https://www.google.com/maps/@${place.latitude},${place.longitude},17z';
      } else {
        final String fullAddress = '${place.address}, ${place.district.name}, ${place.district.province.name}';
        final String encodedAddress = Uri.encodeComponent(fullAddress);
        mapUrl = 'https://www.google.com/maps/search/$encodedAddress';
      }

      final Uri uri = Uri.parse(mapUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      } else {
        _showErrorSnackBar(context, 'Không thể mở trình duyệt');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Đã xảy ra lỗi khi mở trình duyệt');
    }
  }

  // Mở chỉ đường trong Google Maps
  Future<void> _openGoogleMapsDirections(BuildContext context) async {
    if (place.latitude == null || place.longitude == null) {
      _showErrorSnackBar(context, 'Không có thông tin tọa độ để chỉ đường');
      return;
    }

    try {
      final Uri directionsUri = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=${place.latitude},${place.longitude}&travelmode=driving'
      );

      if (await canLaunchUrl(directionsUri)) {
        await launchUrl(directionsUri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar(context, 'Không thể mở chỉ đường');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Đã xảy ra lỗi khi mở chỉ đường');
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

  Widget _buildAgencyCard(BuildContext context, Agency agency) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgencyInfoPage(agency: agency),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: NetworkImageWithFallback(
                  imageUrl: agency.logoUrl ?? '',
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agency.name,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    if (agency.fullName.isNotEmpty && agency.fullName != agency.name)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          agency.fullName,
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ),
                    const SizedBox(height: 6),
                    if (agency.services.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: agency.services
                            .take(3)
                            .map((service) => ServiceChip(
                          name: service.name,
                          color: service.color,
                        ))
                            .toList(),
                      )
                    else
                      const Text(
                        'Không có dịch vụ nổi bật',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textSecondary),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        agency.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.star, size: 18, color: AppColors.starYellow),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'chi tiết >',
                    style: TextStyle(fontSize: 12, color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}