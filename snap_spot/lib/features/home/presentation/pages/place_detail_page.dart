import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../features/home/domain/models/place_model.dart';
import '../../../../shared/widgets/network_image_with_fallback.dart';
import '../../../../shared/widgets/service_chip.dart';

class PlaceDetailPage extends StatelessWidget {
  final Place place;

  const PlaceDetailPage({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final services = place.agencies.expand((a) => a.services).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'place-image-${place.id}',
                child: Stack(
                  children: [
                    NetworkImageWithFallback(
                      imageUrl: place.imageUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // VIEW 360° Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('VIEW 360°'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Address
                  const Text(
                    'Vị Trí',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.green),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${place.address}, ${place.district.name}, ${place.district.province.name}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Xem vị trí'),
                  ),

                  const SizedBox(height: 16),

                  // Services
                  const Text(
                    'Các Dịch Vụ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final agency = place.agencies[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(agency.name,
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(agency.fullName,
                                style: const TextStyle(fontSize: 12)),
                            Wrap(
                              spacing: 6,
                              runSpacing: -8,
                              children: agency.services
                                  .map((s) => ServiceChip(name: s.name, color: s.color))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(agency.rating.toString(),
                              style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                          const Icon(Icons.star, size: 16, color: Colors.yellow),
                        ],
                      ),
                    ],
                  ),
                );
              },
              childCount: place.agencies.length,
            ),
          ),
        ],
      ),
    );
  }
}