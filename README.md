# Auth Sandbox - Flutter Authentication App

A Flutter application demonstrating Supabase authentication with Google OAuth support.

## Features

- **Email/Password Authentication**: Sign up and sign in with email
- **Google OAuth**: Sign in with Google account
- **Form Validation**: Real-time validation with error messages
- **Beautiful UI**: Modern Material Design 3 interface
- **Toast Notifications**: Success and error feedback
- **Supabase Integration**: Secure authentication powered by Supabase

## Prerequisites

1. **Flutter SDK** (>= 3.10.0)
2. **Supabase Project**: Create a free project at [supabase.com](https://supabase.com)

## Setup

### 1. Create a Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Create a new project
3. Go to **Project Settings** > **API**
4. Copy your `SUPABASE_URL` and `SUPABASE_ANON_KEY`

### 2. Configure Google OAuth in Supabase

1. In Supabase Dashboard, go to **Authentication** > **Providers**
2. Enable **Google** provider
3. Add your Google OAuth credentials (get them from [Google Cloud Console](https://console.cloud.google.com))
4. Add redirect URL: `http://localhost:3000/#/auth/callback`

### 3. Configure Environment Variables

Create a `.env` file in the project root:

```env
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key

# Optional Configuration
AUTH_API_URL=http://localhost:8080
APP_NAME=Auth Sandbox
OAUTH_REDIRECT_TO=http://localhost:3000/#/auth/callback
```

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Run the App

```bash
flutter run
```

The app will start at `http://localhost:3000` (web) or on your connected device/emulator.

## Project Structure

```
authsandbox/
├── lib/
│   ├── config/
│   │   └── env_config.dart       # Environment configuration
│   ├── models/
│   │   └── user_info.dart        # User data models
│   ├── pages/
│   │   ├── auth_page.dart        # Authentication page
│   │   ├── auth_callback_page.dart # OAuth callback handler
│   │   ├── landing_page.dart     # Landing page
│   │   └── dashboard_page.dart   # Dashboard (after login)
│   ├── services/
│   │   └── supabase_auth_service.dart  # Supabase auth service
│   ├── widgets/
│   │   └── auth_widgets.dart     # Reusable auth widgets
│   ├── routes.dart               # App routes (go_router)
│   └── main.dart                 # App entry point
├── assets/
│   └── icons/                    # Provider icons
├── .env                          # Environment variables (create this)
└── pubspec.yaml                  # Dependencies
```

## Authentication Flow

### Email/Password

1. User enters email and password
2. Form validates inputs (email format, password length)
3. On validation success:
   - **Sign In**: Calls `SupabaseAuthService.signInWithEmail()`
   - **Sign Up**: Calls `SupabaseAuthService.signUpWithEmail()`
4. On success, navigates to dashboard

### Google OAuth

1. User clicks "Continue with Google"
2. Calls `SupabaseAuthService.signInWithGoogle()`
3. Redirects to Google OAuth page
4. After authentication, redirects back to app with access token
5. User is logged in

## Form Validation

| Field    | Validation Rules                     |
|----------|--------------------------------------|
| Name     | Required (registration only), min 2 characters |
| Email    | Required, valid email format         |
| Password | Required, min 6 characters           |

## Services

### SupabaseAuthService

The main service for authentication:

```dart
// Sign in with Google
await SupabaseAuthService.signInWithGoogle();

// Sign in with email
await SupabaseAuthService.signInWithEmail(
  email: email,
  password: password,
);

// Sign up with email
await SupabaseAuthService.signUpWithEmail(
  email: email,
  password: password,
  name: name,
);

// Get current user
final user = SupabaseAuthService.getCurrentUser();

// Sign out
await SupabaseAuthService.signOut();
```

## Configuration Warning

If Supabase is not configured, the app will show a warning message with instructions on how to set up the `.env` file.

## Troubleshooting

### Supabase Not Configured

Make sure your `.env` file exists in the project root and contains valid `SUPABASE_URL` and `SUPABASE_ANON_KEY`.

### Google OAuth Not Working

1. Make sure Google provider is enabled in Supabase Dashboard
2. Check that the redirect URL matches exactly
3. Verify your Google OAuth credentials are correct

### Build Issues

Run `flutter clean` and then `flutter pub get` to resolve dependency issues.

## License

MIT
