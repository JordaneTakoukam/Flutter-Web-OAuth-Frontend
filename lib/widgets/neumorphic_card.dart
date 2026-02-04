import 'package:flutter/material.dart';

class NeumorphicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final double? width;

  const NeumorphicCard({
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
        color: const Color(0xFFE0E5EC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA3B1C6),
            offset: const Offset(6, 6),
            blurRadius: 15,
          ),
          BoxShadow(
            color: Colors.white,
            offset: const Offset(-6, -6),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6366F1),
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
