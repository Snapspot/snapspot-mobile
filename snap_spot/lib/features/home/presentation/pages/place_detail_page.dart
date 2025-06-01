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
      body: Column(
        children: [
          Stack(
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
              Positioned(
                top: 50,
                left: 16,
                child: BackButton(color: Colors.white),
              ),
              Positioned(
                top: 50,
                right: 16,
                child: Icon(Icons.favorite_border, color: Colors.white),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Text(
                  place.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                ),
              ),
            ],
          ),

          // VIEW 360° Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {}, // implement action
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('VIEW 360°'),
            ),
          ),

          // Address
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Vị Trí', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () {}, // navigate to maps
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Xem vị trí'),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Các Dịch Vụ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: place.agencies.length,
              itemBuilder: (context, index) {
                final agency = place.agencies[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black.withOpacity(0.05))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        color: Colors.teal,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(agency.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(agency.fullName, style: const TextStyle(fontSize: 12)),
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
                          Text(agency.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Icon(Icons.star, size: 16, color: Colors.yellow),
                        ],
                      ),
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
