import 'package:flutter/material.dart';
import '../routes.dart';

/// Page d'accueil minimaliste avec navbar centré
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width > 900;

    return Scaffold(
      body: Column(
        children: [
          _buildNavbar(context),
          Expanded(
            child: SingleChildScrollView(
              child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
            ),
          ),
        ],
      ),
    );
  }

  /// Navbar avec logo à gauche (1/2) et boutons à droite (1/2)
  Widget _buildNavbar(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: const Color(0xFFEAEAEA))),
      ),
      child: Row(
        children: [
          // Left side - Logo (1/2)
          Expanded(
            child: _buildLogo(),
          ),
          // Right side - Auth buttons (1/2)
          Expanded(
            child: _buildAuthButtons(context),
          ),
        ],
      ),
    );
  }

  /// Logo de l'application
  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF0070F3),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.lock_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Auth Sandbox',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111111),
          ),
        ),
      ],
    );
  }

  /// Boutons Sign In et Sign Up alignés à droite avec fond noir
  Widget _buildAuthButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildAuthButton(
          'Sign In',
          () => NavigationHelper.goToSignIn(context),
          isFilled: false,
        ),
        const SizedBox(width: 12),
        _buildAuthButton(
          'Sign Up',
          () => NavigationHelper.goToSignUp(context),
          isFilled: true,
        ),
      ],
    );
  }

  /// Bouton d'authentique (sans icône) avec couleur GitHub
  Widget _buildAuthButton(String text, VoidCallback onTap, {bool isFilled = false}) {
    final githubColor = const Color(0xFF24292e);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isFilled ? githubColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: githubColor,
            width: isFilled ? 0 : 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(6),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: isFilled ? Colors.white : githubColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Bouton avec style GitHub
  Widget _buildGithubButton(String text, VoidCallback onTap, {bool isFilled = false}) {
    final githubColor = const Color(0xFF24292e);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isFilled ? githubColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: githubColor,
            width: isFilled ? 0 : 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/github.png',
                  width: 16,
                  height: 16,
                  color: isFilled ? Colors.white : githubColor,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.code,
                      size: 16,
                      color: isFilled ? Colors.white : githubColor,
                    );
                  },
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                      color: isFilled ? Colors.white : githubColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Layout desktop épuré
  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeroSection(),
          const SizedBox(height: 80),
          _buildDownloadSection(),
        ],
      ),
    );
  }

  /// Layout mobile épuré
  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          _buildHeroSection(),
          const SizedBox(height: 60),
          _buildDownloadSection(),
        ],
      ),
    );
  }

  /// Section hero principale
  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF0070F3).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Text(
            'v1.0.0 — Open Source',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF0070F3),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Authentication\nmade simple',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.02,
            color: Color(0xFF111111),
            height: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const Text(
          'Complete auth solution with Flutter frontend, Dart API,\nPostgreSQL database, and Supabase integration.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF666666),
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Section download avec illustration GitHub et boutons
  Widget _buildDownloadSection() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Column(
        children: [
          // GitHub icon illustration
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF24292e).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              'assets/icons/github.png',
              width: 32,
              height: 32,
              color: const Color(0xFF24292e),
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.code_rounded,
                  size: 32,
                  color: Color(0xFF24292e),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Get the code',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Download the complete source code from GitHub',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 32),
          _buildDownloadButtons(),
        ],
      ),
    );
  }

  /// Boutons de download Frontend et Backend
  Widget _buildDownloadButtons() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        _buildDownloadCard(
          'Frontend',
          'Flutter Web App',
          Icons.web,
          'View on GitHub',
          () {},
        ),
        _buildDownloadCard(
          'Backend',
          'Dart API',
          Icons.code_rounded,
          'View on GitHub',
          () {},
        ),
      ],
    );
  }

  /// Carte de download avec style GitHub
  Widget _buildDownloadCard(
    String title,
    String subtitle,
    IconData icon,
    String buttonText,
    VoidCallback onTap,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEAEAEA)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF24292e).withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // GitHub icon header
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF24292e).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/icons/github.png',
                  width: 24,
                  height: 24,
                  color: const Color(0xFF24292e),
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(icon, color: const Color(0xFF24292e), size: 24);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 20),
              _buildGithubButton(buttonText, onTap, isFilled: true),
            ],
          ),
        ),
      ),
    );
  }
}
