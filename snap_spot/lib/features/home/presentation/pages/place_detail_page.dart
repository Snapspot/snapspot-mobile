import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/error/network_exceptions.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../community/presentation/pages/community_page.dart';
import '../../../../data/datasources/remote/agency_repository.dart';
import '../../../../data/datasources/remote/spot_repository.dart';
import '../../domain/models/spot_model.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../../../shared/widgets/service_chip.dart';
import 'agency_info_page.dart';
import '../../domain/models/agency_model.dart';

class PlaceDetailPage extends StatefulWidget {
  final String spotId;

  const PlaceDetailPage({super.key, required this.spotId});

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> with SingleTickerProviderStateMixin {
  late Future<SpotModel> _spotFuture;
  late Future<List<AgencyModel>> _agenciesFuture;
  late AnimationController _animationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _spotFuture = SpotRepository().fetchSpotById(widget.spotId);
    _agenciesFuture = AgencyRepository().fetchAgenciesBySpotId(widget.spotId);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _buttonScaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SpotModel>(
      future: _spotFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Lỗi: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Không tìm thấy địa điểm.')),
          );
        }

        final spot = snapshot.data!;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(spot),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 8),
                    _buildSectionTitle('Mô tả'),
                    const SizedBox(height: 8),
                    Text(
                      spot.description,
                      style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Vị trí'),
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
                        onPressed: () => _openGoogleMaps(context, spot),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBlue,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Các công ty dịch vụ'),
                    const SizedBox(height: 12),
                    _buildAgenciesSection(),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Tách riêng phần hiển thị agencies để dễ quản lý
  Widget _buildAgenciesSection() {
    return FutureBuilder<List<AgencyModel>>(
      future: _agenciesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          final error = snapshot.error;
          debugPrint('Agencies error: $error');
          debugPrint('Error type: ${error.runtimeType}');

          // Kiểm tra tất cả các trường hợp có thể có lỗi 401
          bool is401Error = false;
          String errorMessage = 'Đã xảy ra lỗi. Vui lòng thử lại.';

          if (error is ServerException) {
            is401Error = error.statusCode == 401;
            errorMessage = error.message;
          } else if (error.toString().contains('401') ||
              error.toString().contains('Unauthorized') ||
              error.toString().contains('đăng nhập')) {
            is401Error = true;
            errorMessage = 'Vui lòng đăng nhập để xem danh sách công ty dịch vụ';
          } else if (error is NetworkException) {
            errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra internet.';
          } else if (error is ParsingException) {
            errorMessage = 'Lỗi xử lý dữ liệu từ server.';
          }

          // Hiển thị UI phù hợp
          if (is401Error) {
            return _buildLoginRequiredCard(errorMessage);
          } else {
            return _buildErrorCard(errorMessage);
          }
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyAgenciesCard();
        }

        final agencies = snapshot.data!;
        return Column(
          children: agencies.map((agency) => _buildAgencyCard(agency)).toList(),
        );
      },
    );
  }

  // Card hiển thị khi cần đăng nhập
  Widget _buildLoginRequiredCard(String message) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.lock_outline,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to login page
                // Navigator.pushNamed(context, '/login');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chuyển hướng đến trang đăng nhập...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.login),
              label: const Text('Đăng nhập'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card hiển thị lỗi khác
  Widget _buildErrorCard(String message) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Reload agencies
                setState(() {
                  _agenciesFuture = AgencyRepository().fetchAgenciesBySpotId(widget.spotId);
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card hiển thị khi không có agencies
  Widget _buildEmptyAgenciesCard() {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.business_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'Chưa có công ty dịch vụ nào tại địa điểm này',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(SpotModel spot) {
    return SliverAppBar(
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
                imageUrl: spot.imageUrl.isNotEmpty ? spot.imageUrl : 'https://via.placeholder.com/300',
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
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedBuilder(
                  animation: _buttonScaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _buttonScaleAnimation.value,
                      child: child,
                    );
                  },
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CommunityPage(
                            spotName: spot.name,
                            spotId: spot.id, // truyền spotId
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.groups_2),
                    label: const Text("Xem các bài đăng"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
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
    );
  }

  Widget _buildAgencyCard(AgencyModel agency) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(agency.avatarUrl),
                  radius: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        agency.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(agency.fullname, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                      Text(agency.phoneNumber, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: agency.services
                            .map((s) => ServiceChip(name: s.name, color: s.color))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 20),
                    Text(agency.rating.toStringAsFixed(1)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AgencyInfoPage(agency: agency),
                      ),
                    );
                  },
                  icon: const Icon(Icons.reviews),
                  label: const Text('Xem đánh giá'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openGoogleMaps(BuildContext context, SpotModel spot) async {
    try {
      final String fullAddress = '${spot.name}, ${spot.address}, ${spot.districtName}, ${spot.provinceName}';
      final String encodedAddress = Uri.encodeComponent(fullAddress);
      final Uri googleMapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedAddress');

      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar(context, 'Không thể mở Google Maps');
      }
    } catch (_) {
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