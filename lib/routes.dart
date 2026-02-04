import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/landing_page.dart';
import 'pages/auth_page.dart';
import 'pages/auth_callback_page.dart';
import 'pages/reset_password_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/not_found_page.dart';

/// Configuration des routes avec go_router
/// Routes disponibles :
/// - / → Landing page
/// - /signin → Connexion
/// - /signup → Inscription
/// - /reset-password → Reset mot de passe
/// - /dashboard → Dashboard
final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    /// Route racine → Landing page
    GoRoute(
      path: '/',
      name: 'landing',
      builder: (context, state) => const LandingPage(),
    ),

    /// Route connexion
    GoRoute(
      path: '/signin',
      name: 'signin',
      builder: (context, state) => const AuthPage(isLogin: true),
    ),

    /// Route inscription
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const AuthPage(isLogin: false),
    ),

    /// Route reset password
    GoRoute(
      path: '/reset-password',
      name: 'reset-password',
      builder: (context, state) => const ResetPasswordPage(),
    ),

    /// OAuth callback route (Supabase redirect)
    GoRoute(
      path: '/auth/callback',
      name: 'auth-callback',
      builder: (context, state) => const AuthCallbackPage(),
    ),

    /// Route dashboard
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
  ],
);

/// Helper pour la navigation entre les pages
class NavigationHelper {
  /// Navigue vers la page d'accueil
  static void goToLanding(BuildContext context) {
    context.go('/');
  }

  /// Navigue vers la page de connexion
  static void goToSignIn(BuildContext context) {
    context.go('/signin');
  }

  /// Navigue vers la page d'inscription
  static void goToSignUp(BuildContext context) {
    context.go('/signup');
  }

  /// Navigue vers la page de réinitialisation du mot de passe
  static void goToResetPassword(BuildContext context) {
    context.go('/reset-password');
  }

  /// Navigue vers le tableau de bord
  static void goToDashboard(BuildContext context) {
    context.go('/dashboard');
  }

  /// Retour à la page précédente
  static void goBack(BuildContext context) {
    context.pop();
  }
}

/// Noms des routes (pour référence)
class Routes {
  static const String landing = '/';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String resetPassword = '/reset-password';
  static const String authCallback = '/auth/callback';
  static const String dashboard = '/dashboard';
}
