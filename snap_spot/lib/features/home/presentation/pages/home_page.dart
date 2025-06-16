import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/custom_carousel.dart'; // Đảm bảo import đúng widget tự xây dựng
import '../../../../shared/widgets/custom_drawer.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../../home/domain/models/place_model.dart';
import '../../data/places_mock.dart';
import 'place_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Biến cho việc tìm kiếm
  final TextEditingController _searchController = TextEditingController();
  late final List<Place> _allPlaces;
  List<Place> _filteredPlaces = [];
  bool _isSearching = false;

  // Biến dữ liệu cho carousel
  List<Place> _carouselPlaces = [];

  @override
  void initState() {
    super.initState();
    _allPlaces = mockPlacesData.map((data) => Place.fromJson(data)).toList();
    _filteredPlaces = _allPlaces;
    _carouselPlaces = _allPlaces.take(5).toList(); // Lấy 5 địa điểm đầu tiên
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredPlaces = _allPlaces;
        _isSearching = false;
      } else {
        _filteredPlaces = _allPlaces.where((place) {
          final placeName = place.name.toLowerCase();
          final districtName = place.district.name.toLowerCase();
          final provinceName = place.district.province.name.toLowerCase();
          // Tìm kiếm nâng cao
          return placeName.contains(query) ||
              districtName.contains(query) ||
              provinceName.contains(query) ||
              '${place.name} ${districtName}'.contains(query) ||
              '${place.name} ${provinceName}'.contains(query) ||
              '$districtName ${provinceName}'.contains(query) ||
              '${place.name} $districtName $provinceName'.contains(query);
        }).toList();
        _isSearching = true;
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      _filteredPlaces = _allPlaces;
      _isSearching = false;
    });
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
            // Overlay mờ khi tìm kiếm
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
                // --- Carousel Banner ---
                Stack(
                  children: [
                    if (_carouselPlaces.isNotEmpty)
                    // SỬA LỖI: Gọi đúng tên widget CustomCarousel
                      CustomCarousel(
                        height: 220,
                        itemCount: _carouselPlaces.length,
                        itemBuilder: (context, index) {
                          final place = _carouselPlaces[index];
                          // Gọi hàm helper để xây dựng UI cho item
                          return buildCarouselItem(context, place);
                        },
                      ),
                    // Icon Menu
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

                // --- Thanh tìm kiếm và kết quả ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      // Thanh tìm kiếm
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
                          onTap: () {
                            setState(() {
                              _isSearching = true;
                            });
                          },
                        ),
                      ),
                      // Danh sách kết quả tìm kiếm
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
                                subtitle: Text('${place.district.name}, ${place.district.province.name}'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlaceDetailPage(place: place),
                                    ),
                                  ).then((_) => _clearSearch());
                                },
                              );
                            },
                          ),
                        ),
                      // Thông báo không tìm thấy
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
                        )
                    ],
                  ),
                ),

                // --- Tiêu đề danh sách ---
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

                // --- Lưới hiển thị các địa điểm ---
                Expanded(
                  child: _filteredPlaces.isEmpty && !_isSearching
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
                              builder: (context) => PlaceDetailPage(place: place),
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
                                      imageUrl: place.imageUrl,
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
                                        '${place.district.name}, ${place.district.province.name}',
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

  /// Hàm trợ giúp để xây dựng UI cho một item trong carousel.
  Widget buildCarouselItem(BuildContext context, Place place) {
    return Stack(
      fit: StackFit.expand,
      children: [
        NetworkImageWithFallback(
          imageUrl: place.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.5, 1.0],
              )),
        ),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  place.name,
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
                      builder: (context) => PlaceDetailPage(place: place),
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