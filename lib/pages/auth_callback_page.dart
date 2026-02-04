import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env_config.dart';
import '../routes.dart';

class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({super.key});

  @override
  State<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _handleCallback();
  }

  Future<void> _handleCallback() async {
    if (!EnvConfig.isSupabaseConfigured) {
      if (!mounted) return;
      setState(() => _error = 'Supabase is not configured. Please check your .env.');
      return;
    }

    try {
      await Supabase.instance.client.auth.getSessionFromUrl(Uri.base);
      final session = Supabase.instance.client.auth.currentSession;

      if (!mounted) return;

      if (session == null) {
        setState(() => _error = 'Authentication completed, but no session was created.');
        return;
      }

      NavigationHelper.goToDashboard(context);
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Unexpected error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                if (_error == null) ...[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text(
                    'Finalizing sign-in…',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please wait while we complete authentication.',
                    style: TextStyle(color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  const Icon(Icons.error_outline, size: 40, color: Color(0xFFE5484D)),
                  const SizedBox(height: 16),
                  const Text(
                    'Sign-in failed',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    style: TextStyle(color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => NavigationHelper.goToSignIn(context),
                    child: const Text('Back to Sign In'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

