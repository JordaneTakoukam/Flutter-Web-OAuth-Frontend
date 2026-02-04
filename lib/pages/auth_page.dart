import 'package:flutter/material.dart';
import '../config/env_config.dart';
import '../routes.dart';
import '../services/supabase_auth_service.dart';
import '../models/user_info.dart';
import '../widgets/auth_widgets.dart';

/// Page d'authentification avec validation des formulaires
class AuthPage extends StatefulWidget {
  final bool isLogin;

  const AuthPage({super.key, this.isLogin = true});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Form keys
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Validation states
  bool _nameError = false;
  bool _emailError = false;
  bool _passwordError = false;
  String _nameErrorMsg = '';
  String _emailErrorMsg = '';
  String _passwordErrorMsg = '';

  // Loading state
  bool _isLoading = false;

  // User info
  UserInfo? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeEnv();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _initializeEnv() async {
    await EnvConfig.init();
  }

  @override
  Widget build(BuildContext context) {
    return AuthSplitLayout(
      leftChild: _buildLeftContent(context),
      rightChild: _buildRightSide(),
    );
  }

  Widget _buildLeftContent(BuildContext context) {
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
            _buildAuthCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isLogin ? 'Welcome back' : 'Create account',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111111),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.isLogin
              ? 'Enter your credentials to access your account'
              : 'Start your journey with Auth Sandbox',
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthCard(BuildContext context) {
    // Check if Supabase is configured
    if (!EnvConfig.isSupabaseConfigured) {
      return _buildConfigWarning(context);
    }

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF111111).withValues(alpha: 0.03),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthProviderGrid(onGoogleTap: _handleGoogleSignIn),
            const SizedBox(height: 24),
            const AuthDivider(),
            const SizedBox(height: 24),
            if (!widget.isLogin) _buildNameField(),
            if (!widget.isLogin) const SizedBox(height: 16),
            _buildEmailField(),
            const SizedBox(height: 16),
            _buildPasswordField(),
            if (widget.isLogin) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: _buildForgotPasswordLink(context),
              ),
            ],
            const SizedBox(height: 24),
            AuthSubmitButton(
              text: widget.isLogin ? 'Sign In' : 'Create Account',
              onTap: _handleSubmit,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),
            AuthSwitchMode(isLogin: widget.isLogin),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigWarning(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFB300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFFF6D00)),
              SizedBox(width: 12),
              Text(
                'Supabase Not Configured',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Please configure your Supabase credentials in the .env file:',
            style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          const SizedBox(height: 12),
          const SelectableText(
            'SUPABASE_URL=https://your-project.supabase.co\nSUPABASE_ANON_KEY=your_supabase_anon_key',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: Color(0xFF0070F3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Full Name',
            prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF999999)),
            errorText: _nameError ? _nameErrorMsg : null,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5484D), width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5484D), width: 2),
            ),
          ),
          onChanged: (value) {
            if (_nameError) {
              setState(() {
                _nameError = false;
                _nameErrorMsg = '';
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Email address',
            prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF999999)),
            errorText: _emailError ? _emailErrorMsg : null,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5484D), width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5484D), width: 2),
            ),
          ),
          onChanged: (value) {
            if (_emailError) {
              setState(() {
                _emailError = false;
                _emailErrorMsg = '';
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF999999)),
            suffixIcon: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {},
                child: const Icon(Icons.visibility_outlined, color: Color(0xFF999999), size: 20),
              ),
            ),
            errorText: _passwordError ? _passwordErrorMsg : null,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5484D), width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5484D), width: 2),
            ),
          ),
          onChanged: (value) {
            if (_passwordError) {
              setState(() {
                _passwordError = false;
                _passwordErrorMsg = '';
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildForgotPasswordLink(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => NavigationHelper.goToResetPassword(context),
        child: const Text(
          'Forgot password?',
          style: TextStyle(
            color: Color(0xFF0070F3),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRightSide() {
    return AuthRightPanel(
      title: widget.isLogin ? 'Welcome Back' : 'Join Us Today',
      description: widget.isLogin
          ? 'Access your secure dashboard and manage your authentication settings.'
          : 'Get started with the most secure authentication solution for your applications.',
      featureIcons: const ['assets/icons/google.png'],
      featureLabels: const ['Sign in with Google'],
    );
  }

  /// Google Sign In with Supabase
  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final response = await SupabaseAuthService.signInWithGoogle();

      if (mounted) {
        setState(() => _isLoading = false);
      }

      if (response.success) {
        // OAuth flow initiated - user will be redirected to Google
        if (mounted) {
          _showSuccessToast('Redirecting to Google...');
        }
      } else {
        if (mounted) {
          _showErrorToast(response.error ?? 'Authentication failed');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorToast('An error occurred: $e');
      }
    }
  }

  /// Form submission with validation
  Future<void> _handleSubmit() async {
    // Clear previous errors
    setState(() {
      _nameError = false;
      _emailError = false;
      _passwordError = false;
      _nameErrorMsg = '';
      _emailErrorMsg = '';
      _passwordErrorMsg = '';
    });

    bool hasError = false;

    // Validate name (for registration)
    if (!widget.isLogin) {
      if (_nameController.text.trim().isEmpty) {
        setState(() {
          _nameError = true;
          _nameErrorMsg = 'Name is required';
        });
        hasError = true;
      } else if (_nameController.text.trim().length < 2) {
        setState(() {
          _nameError = true;
          _nameErrorMsg = 'Name must be at least 2 characters';
        });
        hasError = true;
      }
    }

    // Validate email
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _emailError = true;
        _emailErrorMsg = 'Email is required';
      });
      hasError = true;
    } else if (!_isValidEmail(_emailController.text.trim())) {
      setState(() {
        _emailError = true;
        _emailErrorMsg = 'Please enter a valid email';
      });
      hasError = true;
    }

    // Validate password
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = true;
        _passwordErrorMsg = 'Password is required';
      });
      hasError = true;
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = true;
        _passwordErrorMsg = 'Password must be at least 6 characters';
      });
      hasError = true;
    }

    if (hasError) {
      _showErrorToast('Please fix the errors below');
      return;
    }

    // Process form with Supabase
    setState(() => _isLoading = true);

    try {
      AuthResponse response;

      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final name = _nameController.text.trim();

      if (widget.isLogin) {
        response = await SupabaseAuthService.signInWithEmail(
          email: email,
          password: password,
        );
      } else {
        response = await SupabaseAuthService.signUpWithEmail(
          email: email,
          password: password,
          name: name.isEmpty ? null : name,
        );
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }

      if (response.success && response.user != null) {
        setState(() => _currentUser = response.user);
        if (mounted) {
          _showSuccessToast(widget.isLogin ? 'Sign in successful!' : 'Account created successfully!');
        }
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          NavigationHelper.goToDashboard(context);
        }
      } else {
        if (mounted) {
          _showErrorToast(response.error ?? 'Authentication failed');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorToast('An error occurred: $e');
      }
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Show error toast notification
  void _showErrorToast(String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.clearSnackBars();
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFE5484D),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show success toast notification
  void _showSuccessToast(String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.clearSnackBars();
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
