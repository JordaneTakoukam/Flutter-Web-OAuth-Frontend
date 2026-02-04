import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/auth_provider.dart';

class NeumorphicButton extends StatefulWidget {
  final AuthProvider provider;
  final VoidCallback? onPressed;
  final double width;
  final double height;

  const NeumorphicButton({
    super.key,
    required this.provider,
    this.onPressed,
    this.width = 140,
    this.height = 60,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E5EC),
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isPressed
                ? [
                    BoxShadow(
                      color: const Color(0xFFA3B1C6),
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(-4, -4),
                      blurRadius: 10,
                    ),
                  ]
                : [
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: _isHovered ? 2 : 0, sigmaY: _isHovered ? 2 : 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProviderIcon(),
                    const SizedBox(width: 12),
                    Text(
                      widget.provider.name,
                      style: const TextStyle(
                        color: Color(0xFF4A5568),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProviderIcon() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: widget.provider.primaryColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: widget.provider.primaryColor.withValues(alpha: 0.4),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          widget.provider.iconPath,
          width: 20,
          height: 20,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.login,
              color: Colors.white.withValues(alpha: 0.8),
              size: 18,
            );
          },
        ),
      ),
    );
  }
}
