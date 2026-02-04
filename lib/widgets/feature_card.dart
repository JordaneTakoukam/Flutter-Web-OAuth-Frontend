import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final double? width;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0070F3).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF0070F3),
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
