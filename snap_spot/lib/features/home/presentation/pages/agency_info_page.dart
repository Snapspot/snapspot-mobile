import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Đảm bảo bạn đã import đúng các file cần thiết từ dự án của mình
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/expandable_text.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../../../shared/widgets/service_chip.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../data/datasources/remote/feedback_repository.dart';
import '../../domain/models/agency_model.dart';
import '../../domain/models/feedback_model.dart';
// import 'package:url_launcher/url_launcher.dart'; // Thêm dependency này vào pubspec.yaml để mở link

class AgencyInfoPage extends StatefulWidget {
  final AgencyModel agency;

  const AgencyInfoPage({super.key, required this.agency});

  @override
  State<AgencyInfoPage> createState() => _AgencyInfoPageState();
}

class _AgencyInfoPageState extends State<AgencyInfoPage> {
  late final DateFormat _dateFormat;
  FeedbackRepository? _feedbackRepository;
  Future<List<FeedbackModel>>? _feedbackFuture;
  final _feedbackController = TextEditingController();
  double _selectedRating = 0.0;

  @override
  void initState() {
    super.initState();
    _dateFormat = DateFormat('dd/MM/yyyy');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = context.watch<AuthProvider>();
    if (authProvider.isAuthenticated) {
      _feedbackRepository ??= FeedbackRepository(authProvider);
      _feedbackFuture = _feedbackRepository!.fetchAgencyFeedbacks(
        agencyId: widget.agency.id,
      );
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  // --- CÁC HÀM XỬ LÝ LOGIC ---

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể thực hiện cuộc gọi')),
      );
    }
  }

  void _showFeedbackForm() {
    // Giữ nguyên hàm _showFeedbackForm từ code gốc của bạn
    // vì nó đã xử lý tốt việc hiển thị bottom sheet.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Viết đánh giá',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Đánh giá của bạn',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return IconButton(
                                onPressed: () {
                                  setModalState(() {
                                    _selectedRating = (index + 1).toDouble();
                                  });
                                },
                                icon: Icon(
                                  index < _selectedRating ? Icons.star : Icons.star_border,
                                  color: AppColors.starYellow,
                                  size: 32,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _feedbackController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Nhập nội dung đánh giá...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.primary, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: const Text(
                                    'Hủy',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_feedbackController.text.trim().isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Vui lòng nhập nội dung đánh giá'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    try {
                                      final authProvider = context.read<AuthProvider>();
                                      await _feedbackRepository!.createFeedback(
                                        agencyId: widget.agency.id,
                                        content: _feedbackController.text.trim(),
                                        rating: _selectedRating.toInt(),
                                      );
                                      Navigator.pop(context);
                                      setState(() {
                                        _feedbackFuture = _feedbackRepository!.fetchAgencyFeedbacks(
                                          agencyId: widget.agency.id,
                                        );
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Gửi đánh giá thành công'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Lỗi khi gửi đánh giá: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Gửi đánh giá',
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
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // --- CÁC WIDGET XÂY DỰNG GIAO DIỆN ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  _buildAboutSection(),
                  if (widget.agency.services.isNotEmpty) _buildServicesSection(),
                  _buildContactSection(),
                  _buildFeedbackSection(),
                  const SizedBox(height: 80), // Khoảng đệm cho FAB
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSliverAppBar() {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
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
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.5, 0.7, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildHeaderContent(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderContent(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.agency.name,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [const Shadow(blurRadius: 4, color: Colors.black54)],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.agency.companyName,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          _buildTrustBar(),
        ],
      ),
    );
  }

  Widget _buildTrustBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTrustBarItem(Icons.star_rounded, AppColors.starYellow, '${widget.agency.rating.toStringAsFixed(1)} Rating'),
          _buildTrustBarSeparator(),
          _buildTrustBarItem(Icons.verified_user_rounded, Colors.lightGreenAccent, 'Đã xác minh'),
          _buildTrustBarSeparator(),
          _buildTrustBarItem(Icons.grid_view_rounded, Colors.lightBlueAccent, '${widget.agency.services.length} Dịch vụ'),
        ],
      ),
    );
  }

  Widget _buildTrustBarItem(IconData icon, Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildTrustBarSeparator() {
    return Container(height: 20, width: 1, color: Colors.white.withOpacity(0.3));
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Giới thiệu', Icons.info_outline_rounded),
        const SizedBox(height: 16),
        ExpandableText(
          text: widget.agency.description.isNotEmpty ? widget.agency.description : 'Chưa có thông tin giới thiệu.',
          maxLines: 4,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.6),
        ),
        const SizedBox(height: 16),
        const Divider(thickness: 1, height: 32),
      ],
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Dịch vụ cung cấp', Icons.miscellaneous_services_rounded),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.agency.services
              .map((service) => ServiceChip(name: service.name, color: service.color))
              .toList(),
        ),
        const SizedBox(height: 16),
        const Divider(thickness: 1, height: 32),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Thông tin liên hệ', Icons.contact_page_outlined),
        const SizedBox(height: 20),
        _buildActionableContactRow(
          icon: Icons.phone_outlined,
          label: 'Số điện thoại',
          value: widget.agency.phoneNumber,
          onTap: () { /* await _makePhoneCall(widget.agency.phoneNumber); */ },
        ),
        const SizedBox(height: 16),
        _buildActionableContactRow(
          icon: Icons.person_outline,
          label: 'Người đại diện',
          value: widget.agency.fullname,
          onTap: () {}, // Không cần action
        ),
        const SizedBox(height: 16),
        _buildActionableContactRow(
          icon: Icons.location_on_outlined,
          label: 'Địa chỉ',
          value: widget.agency.address,
          onTap: () { /* TODO: Implement launch map URL */ },
        ),
        const SizedBox(height: 16),
        const Divider(thickness: 1, height: 32),
      ],
    );
  }

  Widget _buildActionableContactRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            if(onTap != (){}) // Chỉ hiện icon nếu có hành động
              Icon(Icons.launch, size: 20, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () async {await _makePhoneCall(widget.agency.phoneNumber); },
      label: const Text('Liên hệ ngay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      icon: const Icon(Icons.phone_in_talk_outlined),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 8,
    );
  }

  Widget _buildFeedbackSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSectionHeader('Đánh giá người dùng', Icons.reviews_outlined),
                if (authProvider.isAuthenticated)
                  TextButton(
                    onPressed: _showFeedbackForm,
                    child: const Text('Viết đánh giá'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (!authProvider.isAuthenticated)
              _buildLoginPrompt()
            else
              _buildFeedbackContent(),
          ],
        );
      },
    );
  }

  Widget _buildFeedbackContent() {
    if (_feedbackFuture == null) return _buildEmptyFeedback();

    return FutureBuilder<List<FeedbackModel>>(
      future: _feedbackFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        if (snapshot.hasError) {
          return _buildErrorCard(snapshot.error.toString());
        }
        final feedbacks = snapshot.data!;
        if (feedbacks.isEmpty) {
          return _buildEmptyFeedback();
        }
        return ListView.separated(
          itemCount: feedbacks.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _buildFeedbackCard(feedbacks[index]);
          },
        );
      },
    );
  }

  Widget _buildLoginPrompt() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.lock_outline_rounded, size: 40, color: AppColors.primary.withOpacity(0.7)),
          const SizedBox(height: 16),
          const Text(
            'Đăng nhập để xem và gửi đánh giá',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Chức năng này chỉ dành cho thành viên đã đăng nhập.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 12),
          const Text(
            'Lỗi khi tải đánh giá',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                final authProvider = context.read<AuthProvider>();
                _feedbackRepository = FeedbackRepository(authProvider);
                _feedbackFuture = _feedbackRepository!.fetchAgencyFeedbacks(agencyId: widget.agency.id);
              });
            },
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text('Thử lại'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFeedback() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.rate_review_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Chưa có đánh giá nào',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy là người đầu tiên đánh giá dịch vụ này.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(FeedbackModel feedback) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(feedback.avatarUrl), radius: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(feedback.fullName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (i) => Icon(i < feedback.rating ? Icons.star : Icons.star_border, size: 16, color: AppColors.starYellow)),
                        const SizedBox(width: 8),
                        Text(_dateFormat.format(feedback.createdAt), style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            feedback.content,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
          ),
        ],
      ),
    );
  }
}