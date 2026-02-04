import 'package:flutter/material.dart';
import '../routes.dart';

/// Page tableau de bord avec navigation par onglets
/// Design software UI minimaliste avec sidebar à gauche
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  /// Index de l'onglet sélectionné (0: Overview, 1: Users, 2: Security, 3: Settings)
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width > 900;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar de navigation (desktop uniquement)
          if (isDesktop) _buildSidebar(),
          // Contenu principal
          Expanded(
            child: Scaffold(
              appBar: _buildAppBar(),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: _buildContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Barre supérieure avec titre et actions
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Dashboard',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF111111),
        ),
      ),
      actions: [
        _buildActionButton(Icons.notifications_outlined, () {}),
        const SizedBox(width: 8),
        // Avatar utilisateur avec gradient
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _showProfileMenu(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0070F3), Color(0xFF0060DF)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  /// Bouton d'action dans l'app bar
  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFEAEAEA)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Icon(icon, size: 18, color: const Color(0xFF666666)),
          ),
        ),
      ),
    );
  }

  /// Sidebar de navigation avec logo et items
  Widget _buildSidebar() {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFEAEAEA))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildLogo(),
          const SizedBox(height: 32),
          _buildSidebarItem(Icons.dashboard_outlined, 'Overview', 0),
          _buildSidebarItem(Icons.people_outline, 'Users', 1),
          _buildSidebarItem(Icons.shield_outlined, 'Security', 2),
          _buildSidebarItem(Icons.settings_outlined, 'Settings', 3),
          const Spacer(),
          _buildSidebarLogout(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Logo de l'application dans la sidebar
  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF0070F3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.lock_rounded,
              size: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Auth Sandbox',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111111),
            ),
          ),
        ],
      ),
    );
  }

  /// Item de navigation dans la sidebar
  Widget _buildSidebarItem(IconData icon, String label, int index) {
    final isSelected = _selectedTab == index;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF0070F3).withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? const Color(0xFF0070F3)
                    : const Color(0xFF666666),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF0070F3)
                      : const Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bouton de déconnexion en bas de sidebar
  Widget _buildSidebarLogout() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => NavigationHelper.goToLanding(context),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE5484D).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.logout_rounded, size: 20, color: Color(0xFFE5484D)),
              SizedBox(width: 12),
              Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE5484D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Affiche le contenu selon l'onglet sélectionné
  Widget _buildContent() {
    switch (_selectedTab) {
      case 0:
        return _buildOverview();
      case 1:
        return _buildUsers();
      case 2:
        return _buildSecurity();
      case 3:
        return _buildSettings();
      default:
        return _buildOverview();
    }
  }

  /// Onglet Vue d'ensemble avec statistiques
  Widget _buildOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111111),
          ),
        ),
        const SizedBox(height: 24),
        // Cartes de statistiques
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildStatCard(
              'Total Users',
              '2,847',
              Icons.people_rounded,
              const Color(0xFF0070F3),
            ),
            _buildStatCard(
              'Active Sessions',
              '142',
              Icons.devices_rounded,
              const Color(0xFF00A345),
            ),
            _buildStatCard(
              'Auth Today',
              '89',
              Icons.login_rounded,
              const Color(0xFFFFB800),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Actions rapides
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEAEAEA)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 16),
              _buildQuickAction(
                Icons.add_circle_outline,
                'Add New User',
                () {},
              ),
              _buildQuickAction(Icons.mail_outline, 'Send Invitation', () {}),
              _buildQuickAction(
                Icons.security_outlined,
                'Security Settings',
                () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Carte de statistique avec icône colorée
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF999999),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Ligne d'action rapide cliquable
  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: const Color(0xFF666666)),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Color(0xFFCCCCCC),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Onglet Gestion des utilisateurs (placeholder)
  Widget _buildUsers() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Color(0xFFEAEAEA)),
          SizedBox(height: 16),
          Text(
            'Users Management',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111111),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'User management coming soon',
            style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  /// Onglet Paramètres de sécurité (placeholder)
  Widget _buildSecurity() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, size: 64, color: Color(0xFFEAEAEA)),
          SizedBox(height: 16),
          Text(
            'Security Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111111),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Security settings coming soon',
            style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  /// Onglet Paramètres généraux (placeholder)
  Widget _buildSettings() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings_outlined, size: 64, color: Color(0xFFEAEAEA)),
          SizedBox(height: 16),
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111111),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Settings panel coming soon',
            style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  /// Affiche le menu profil de l'utilisateur
  void _showProfileMenu() {}
}
