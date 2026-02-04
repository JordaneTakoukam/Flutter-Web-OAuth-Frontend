import 'package:flutter/material.dart';
import '../routes.dart';

/// Layout split-screen réutilisable pour les pages d'auth
class AuthSplitLayout extends StatelessWidget {
  final Widget leftChild;
  final Widget rightChild;

  const AuthSplitLayout({
    super.key,
    required this.leftChild,
    required this.rightChild,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width > 900;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: leftChild,
              ),
            ),
            Expanded(
              flex: 1,
              child: rightChild,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: leftChild,
      ),
    );
  }
}

/// Bouton de retour réutilisable
class AuthBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AuthBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap ?? () => NavigationHelper.goToLanding(context),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFEAEAEA)),
          ),
          child: const Icon(
            Icons.arrow_back,
            size: 20,
            color: Color(0xFF666666),
          ),
        ),
      ),
    );
  }
}

/// Bouton Google Sign-In - Design officiel
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onTap;

  const GoogleSignInButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFDADCE0), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1967D2).withValues(alpha: 0.1),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/google.png',
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildGoogleGLogo();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Continue with Google',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3C4043),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleGLogo() {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _GoogleLogoPainter(),
    );
  }
}

/// Painter pour le logo Google "G" multicolore
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final colors = [
      const Color(0xFF4285F4), // Blue
      const Color(0xFFEA4335), // Red
      const Color(0xFFFBBC05), // Yellow
      const Color(0xFF34A853), // Green
    ];

    final path = Path();
    final rect = Rect.fromCircle(center: center, radius: radius);
    final segmentAngle = 2 * 3.14159 / 4;

    path.addArc(rect, -segmentAngle / 2, segmentAngle);
    canvas.drawPath(path, Paint()..color = colors[0]..style = PaintingStyle.fill);

    path.reset();
    path.addArc(rect, 3.14159 - segmentAngle / 2, segmentAngle);
    canvas.drawPath(path, Paint()..color = colors[1]..style = PaintingStyle.fill);

    path.reset();
    path.addArc(rect, 3.14159 * 1.5 - segmentAngle / 2, segmentAngle);
    canvas.drawPath(path, Paint()..color = colors[2]..style = PaintingStyle.fill);

    path.reset();
    path.addArc(rect, -3.14159 / 2 - segmentAngle / 2, segmentAngle);
    canvas.drawPath(path, Paint()..color = colors[3]..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Grille de boutons OAuth (seulement Google maintenant)
class AuthProviderGrid extends StatelessWidget {
  final VoidCallback onGoogleTap;

  const AuthProviderGrid({super.key, required this.onGoogleTap});

  @override
  Widget build(BuildContext context) {
    return GoogleSignInButton(onTap: onGoogleTap);
  }
}

/// Diviseur "OR" réutilisable
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: const Color(0xFFEAEAEA))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF999999),
              letterSpacing: 1,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: const Color(0xFFEAEAEA))),
      ],
    );
  }
}

/// Bouton de soumission réutilisable
class AuthSubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;

  const AuthSubmitButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF0070F3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Chip avec image depuis assets
class AuthFeatureChip extends StatelessWidget {
  final String imagePath;
  final String label;

  const AuthFeatureChip({
    super.key,
    required this.imagePath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 16,
                height: 16,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.login,
                    size: 16,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Panneau droit gradient réutilisable
class AuthRightPanel extends StatelessWidget {
  final String title;
  final String description;
  final List<String> featureIcons;
  final List<String> featureLabels;

  const AuthRightPanel({
    super.key,
    required this.title,
    required this.description,
    required this.featureIcons,
    required this.featureLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0070F3),
            const Color(0xFF0060DF),
            const Color(0xFF7928CA).withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 64),
            for (int i = 0; i < featureIcons.length; i++) ...[
              if (i > 0) const SizedBox(height: 16),
              AuthFeatureChip(
                imagePath: featureIcons[i],
                label: featureLabels[i],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Lien pour basculer entre connexion et inscription
class AuthSwitchMode extends StatelessWidget {
  final bool isLogin;

  const AuthSwitchMode({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? "Don't have an account?" : 'Already have an account?',
          style: const TextStyle(color: Color(0xFF666666), fontSize: 14),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: TextButton(
            onPressed: () {
              if (isLogin) {
                NavigationHelper.goToSignUp(context);
              } else {
                NavigationHelper.goToSignIn(context);
              }
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Text(
              isLogin ? 'Sign up' : 'Sign in',
              style: const TextStyle(
                color: Color(0xFF0070F3),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
