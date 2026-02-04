import 'package:flutter/material.dart';

/// Loading dialog widget for showing auth progress
class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({
    super.key,
    this.message = 'Signing in...',
  });

  /// Show the loading dialog
  static Future<T?> show<T>({
    required BuildContext context,
    String message = 'Signing in...',
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingDialog(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0070F3)),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

/// Success dialog widget
class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onContinue;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.onContinue,
  });

  /// Show the success dialog
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onContinue,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: onContinue == null,
      builder: (context) => SuccessDialog(
        title: title,
        message: message,
        onContinue: onContinue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (onContinue != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onContinue?.call();
                },
                child: const Text('Continue'),
              ),
            ),
        ],
      ),
    );
  }
}

/// Error dialog widget
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorDialog({
    super.key,
    this.title = 'Authentication Failed',
    required this.message,
    this.onRetry,
  });

  /// Show the error dialog
  static Future<void> show({
    required BuildContext context,
    String title = 'Authentication Failed',
    required String message,
    VoidCallback? onRetry,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        onRetry: onRetry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFE5484D).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: Color(0xFFE5484D),
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              if (onRetry != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
              if (onRetry != null) const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onRetry?.call();
                  },
                  child: Text(onRetry != null ? 'Retry' : 'OK'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
