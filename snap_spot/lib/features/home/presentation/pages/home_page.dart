import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../shared/widgets/custom_drawer.dart';
import '../../../home/data/places_mock.dart';
import '../../../home/domain/models/place_model.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';

class HomePage extends StatelessWidget {
  final List<Place> places = mockPlaces.map((e) => Place.fromJson(e)).toList();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner header
          Stack(
            children: [
              Container(
                height: 220,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://www.dulichhalong.net/wp-content/uploads/2014/09/Vinh-Bai-Tu-Long.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 220,
                color: Colors.black.withOpacity(0.3),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Vịnh Hạ Long',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Xem thêm'),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Builder(
                    builder: (context) => GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
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
                        child: const Icon(Icons.menu, size: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Search Box
          Padding(
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
                  )
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Bạn muốn đi đâu?',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Các địa điểm nổi bật',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Grid view
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: places.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final place = places[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary, // Màu nền xanh đậm
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ảnh vuông phía trên
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: NetworkImageWithFallback(
                            imageUrl: place.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Tên địa điểm
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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

                      // Địa chỉ (Quận, Tỉnh)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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

                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
