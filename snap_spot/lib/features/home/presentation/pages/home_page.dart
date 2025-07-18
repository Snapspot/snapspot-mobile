import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/custom_carousel.dart';
import '../../../../shared/widgets/custom_drawer.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../data/spot_repository.dart';
import '../../domain/models/spot_model.dart';
import 'place_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<SpotModel> _allSpots = [];
  List<SpotModel> _filteredSpots = [];
  List<SpotModel> _carouselSpots = [];
  bool _isSearching = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initialize();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _initialize() async {
    try {
      await _checkLocationPermission();
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final spots = await SpotRepository().fetchSpotsByLocation(position.latitude, position.longitude);

      setState(() {
        _allSpots = spots;
        _filteredSpots = spots;
        _carouselSpots = spots.take(5).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Lỗi: ${e.toString()}';
      });
    }
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Dịch vụ định vị chưa được bật.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Người dùng từ chối quyền truy cập vị trí.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Người dùng đã từ chối quyền truy cập vĩnh viễn.');
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredSpots = _allSpots;
        _isSearching = false;
      } else {
        _filteredSpots = _allSpots.where((spot) {
          final name = spot.name.toLowerCase();
          final district = spot.districtName.toLowerCase();
          final province = spot.provinceName.toLowerCase();
          return name.contains(query) ||
              district.contains(query) ||
              province.contains(query) ||
              '$name $district $province'.contains(query);
        }).toList();
        _isSearching = true;
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      _filteredSpots = _allSpots;
      _isSearching = false;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            if (_isSearching && _searchController.text.isNotEmpty) _buildSearchOverlay(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopSection(),
                _buildSearchInput(),
                _buildSearchResults(),
                _buildSectionTitle(),
                const SizedBox(height: 8),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : _buildGridView(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchOverlay() => Positioned.fill(
    child: AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: 1.0,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: GestureDetector(onTap: _clearSearch),
      ),
    ),
  );

  Widget _buildTopSection() => Stack(
    children: [
      if (_carouselSpots.isNotEmpty)
        CustomCarousel(
          height: 220,
          itemCount: _carouselSpots.length,
          itemBuilder: (context, index) => _buildCarouselItem(_carouselSpots[index]),
        ),
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8),
          child: Builder(
            builder: (context) => InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              customBorder: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.menu, size: 24, color: AppColors.textPrimary),
              ),
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildSearchInput() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Bạn muốn đi đâu?',
          prefixIcon: const Icon(Icons.search, color: AppColors.gray),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: AppColors.gray),
            onPressed: _clearSearch,
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
        onTap: () => setState(() => _isSearching = true),
      ),
    ),
  );

  Widget _buildSearchResults() {
    if (!_isSearching || _searchController.text.isEmpty) return const SizedBox.shrink();
    return _filteredSpots.isEmpty ? _buildSearchEmpty() : _buildSearchList();
  }

  Widget _buildSearchList() => Container(
    margin: const EdgeInsets.only(top: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2)),
      ],
    ),
    constraints: const BoxConstraints(maxHeight: 200),
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: _filteredSpots.length,
      itemBuilder: (context, index) {
        final spot = _filteredSpots[index];
        return ListTile(
          leading: const Icon(Icons.location_on, color: AppColors.primary),
          title: Text(spot.name),
          subtitle: Text('${spot.districtName}, ${spot.provinceName}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceDetailPage(spotId: spot.id),
              ),
            ).then((_) => _clearSearch());
          },
        );
      },
    ),
  );

  Widget _buildSearchEmpty() => Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2)),
      ],
    ),
    child: const Center(child: Text('Không tìm thấy địa điểm phù hợp.')),
  );

  Widget _buildSectionTitle() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Text(
      _isSearching && _searchController.text.isNotEmpty
          ? 'Kết quả tìm kiếm (${_filteredSpots.length})'
          : 'Các địa điểm nổi bật',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    ),
  );

  Widget _buildGridView() => GridView.builder(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
    itemCount: _filteredSpots.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.75,
    ),
    itemBuilder: (context, index) {
      final spot = _filteredSpots[index];
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceDetailPage(spotId: spot.id),
            ),
          );
        },
        child: _buildSpotCard(spot),
      );
    },
  );

  Widget _buildCarouselItem(SpotModel spot) => Stack(
    fit: StackFit.expand,
    children: [
      NetworkImageWithFallback(
        imageUrl: spot.imageUrl.isNotEmpty ? spot.imageUrl : 'https://via.placeholder.com/300',
        fit: BoxFit.cover,
        width: double.infinity,
      ),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.5), Colors.transparent, Colors.black.withOpacity(0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
      Positioned.fill(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                spot.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceDetailPage(spotId: spot.id),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Xem thêm'),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _buildSpotCard(SpotModel spot) => Container(
    decoration: BoxDecoration(
      color: AppColors.green,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: AppColors.shadow.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 3)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Hero(
              tag: 'place-image-${spot.id}',
              child: NetworkImageWithFallback(
                imageUrl: spot.imageUrl.isNotEmpty ? spot.imageUrl : 'https://via.placeholder.com/150',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: Text(
            spot.name,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.white, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: AppColors.white),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${spot.districtName}, ${spot.provinceName}',
                  style: const TextStyle(color: AppColors.white, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '${spot.distance.toStringAsFixed(2)} km',
            style: const TextStyle(color: AppColors.white, fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}