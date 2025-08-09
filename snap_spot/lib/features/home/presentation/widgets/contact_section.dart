// lib/features/agency/presentation/widgets/contact_section.dart
import 'package:flutter/material.dart';
import '../../domain/models/agency_model.dart';
import '../../../../core/themes/app_colors.dart';

class ContactSection extends StatelessWidget {
  final AgencyModel agency;

  const ContactSection({super.key, required this.agency});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Thông tin liên hệ", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (agency.phoneNumber != null)
          Row(children: [
            const Icon(Icons.phone, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(agency.phoneNumber!),
          ]),
        // if (agency.email != null)
        //   Row(children: [
        //     const Icon(Icons.email, size: 18, color: AppColors.primary),
        //     const SizedBox(width: 8),
        //     Text(agency.email!),
        //   ]),
        if (agency.address.isNotEmpty)
          Row(children: [
            const Icon(Icons.location_on, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(child: Text(agency.address)),
          ]),
      ],
    );
  }
}
