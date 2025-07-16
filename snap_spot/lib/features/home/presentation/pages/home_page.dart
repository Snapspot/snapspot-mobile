// lib/features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/custom_carousel.dart';
import '../../../../shared/widgets/custom_drawer.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../data/spot_repository.dart';
import '../../domain/models/spot_model.dart';
import 'place_detail_page.dart';
import 'package:geolocator/geolocator.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<SpotModel> _allSpots = [];
  List<SpotModel> _filteredPlaces = [];
  List<SpotModel> _carouselPlaces = [];
  bool _isSearching = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchData() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Dịch vụ định vị chưa được bật.');
      }

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

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final spots = await SpotRepository().fetchSpotsByLocation(
          position.latitude, position.longitude);

      setState(() {
        _allSpots = spots;
        _filteredPlaces = spots;
        _carouselPlaces = spots.take(5).toList();
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Lỗi: ${e.toString()}';
      });
    }
  }


  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredPlaces = _allSpots;
        _isSearching = false;
      } else {
        _filteredPlaces = _allSpots.where((place) {
          final name = place.name.toLowerCase();
          final district = place.districtName.toLowerCase();
          final province = place.provinceName.toLowerCase();
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
      _filteredPlaces = _allSpots;
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
            if (_isSearching && _searchController.text.isNotEmpty)
              Positioned.fill(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: 1.0,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: GestureDetector(onTap: _clearSearch),
                  ),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    if (_carouselPlaces.isNotEmpty)
                      CustomCarousel(
                        height: 220,
                        itemCount: _carouselPlaces.length,
                        itemBuilder: (context, index) {
                          final place = _carouselPlaces[index];
                          return buildCarouselItem(context, place);
                        },
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      Container(
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
                      if (_isSearching && _searchController.text.isNotEmpty && _filteredPlaces.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredPlaces.length,
                            itemBuilder: (context, index) {
                              final place = _filteredPlaces[index];
                              return ListTile(
                                leading: const Icon(Icons.location_on, color: AppColors.primary),
                                title: Text(place.name),
                                subtitle: Text('${place.districtName}, ${place.provinceName}'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlaceDetailPage(spot: place), // Fixed: Changed `spot` to `place`
                                    ),
                                  ).then((_) => _clearSearch());
                                },
                              );
                            },
                          ),
                        ),
                      if (_isSearching && _searchController.text.isNotEmpty && _filteredPlaces.isEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(child: Text('Không tìm thấy địa điểm phù hợp.')),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _isSearching && _searchController.text.isNotEmpty
                        ? 'Kết quả tìm kiếm (${_filteredPlaces.length})'
                        : 'Các địa điểm nổi bật',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : _filteredPlaces.isEmpty && !_isSearching
                      ? const Center(child: Text('Không có địa điểm nào để hiển thị.'))
                      : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: _filteredPlaces.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      final place = _filteredPlaces[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaceDetailPage(spot: place),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  child: Hero(
                                    tag: 'place-image-${place.id}',
                                    child: NetworkImageWithFallback(
                                      imageUrl: place.imageUrl.isNotEmpty
                                          ? place.imageUrl
                                          : 'https://via.placeholder.com/150', // Fallback image
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                                child: Text(
                                  place.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                    fontSize: 14,
                                  ),
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
                                        '${place.districtName}, ${place.provinceName}',
                                        style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child:Text('${(place.distance / 1).toStringAsFixed(2)} km',
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCarouselItem(BuildContext context, SpotModel spot) {
    return Stack(
      fit: StackFit.expand,
      children: [
        NetworkImageWithFallback(
          imageUrl: spot.imageUrl.isNotEmpty
              ? spot.imageUrl
              : 'https://via.placeholder.com/300', // Fallback image for carousel
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.transparent,
                Colors.black.withOpacity(0.5),
              ],
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
                      builder: (context) => PlaceDetailPage(spot: spot),
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
  }
}