import 'package:flutter/material.dart';
import '../routes.dart';
import '../widgets/auth_widgets.dart';

/// Page de réinitialisation du mot de passe
/// Design split-screen sur desktop (1/2 gauche, 1/2 droite)
class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthSplitLayout(
      leftChild: _buildContent(context),
      rightChild: _buildRightSide(),
    );
  }

  /// Construit le contenu principal (formulaire)
  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AuthBackButton(),
            const SizedBox(height: 40),
            _buildHeader(),
            const SizedBox(height: 32),
            _buildForm(context),
          ],
        ),
      ),
    );
  }

  /// En-tête avec icône et description
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF0070F3).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.lock_reset_rounded,
            color: Color(0xFF0070F3),
            size: 24,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Reset your password',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111111),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Enter your email address and we\'ll send you a link to reset your password.',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  /// Formulaire de réinitialisation
  Widget _buildForm(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TextField(
            decoration: InputDecoration(
              hintText: 'Email address',
              prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF999999)),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          AuthSubmitButton(
            text: 'Send reset link',
            onTap: () => _handleSubmit(context),
          ),
          const SizedBox(height: 24),
          Center(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => NavigationHelper.goToSignIn(context),
                child: const Text(
                  'Back to sign in',
                  style: TextStyle(
                    color: Color(0xFF0070F3),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Panneau droit avec visuel gradient
  Widget _buildRightSide() {
    return const AuthRightPanel(
      title: 'Secure Password\nRecovery',
      description: 'We prioritize your account security with encrypted password resets.',
      featureIcons: [
        'assets/icons/google.png',
        'assets/icons/linkedin.png',
        'assets/icons/apple.png',
      ],
      featureLabels: [
        'Reset with Google',
        'Reset with LinkedIn',
        'Reset with Apple',
      ],
    );
  }

  /// Gère la soumission du formulaire
  void _handleSubmit(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset link sent! Check your email.'),
        backgroundColor: Color(0xFF00A345),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
