import 'package:flutter/material.dart';

class ServiceChip extends StatelessWidget {
  final String name;
  final String color;

  const ServiceChip({super.key, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: _parseColor(color),
      label: Text(name, style: const TextStyle(color: Colors.white)),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xff')));
    } catch (_) {
      return Colors.grey;
    }
  }
}
