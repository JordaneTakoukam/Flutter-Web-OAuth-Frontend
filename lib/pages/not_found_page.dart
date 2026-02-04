import 'package:flutter/material.dart';
import '../routes.dart';

/// Page 404 - Route non trouvée
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF0070F3).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 40,
                  color: Color(0xFF0070F3),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '404',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111111),
                  height: 1,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Page not found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'The page you\'re looking for doesn\'t exist.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 32),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0070F3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => NavigationHelper.goToLanding(context),
                      borderRadius: BorderRadius.circular(10),
                      child: const Center(
                        child: Text(
                          'Go back home',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
