// lib/shared/widgets/error_indicator.dart

import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  const ErrorIndicator({
    super.key,
    required this.message,
    this.icon = Icons.error_outline,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Try Again"),
            )
          ]
        ],
      ),
    );
  }
}
