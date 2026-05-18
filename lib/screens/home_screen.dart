import 'package:flutter/material.dart';
import 'package:my_app/controllers/home_controller.dart';
import 'package:my_app/widgets/home_action_button.dart';
import 'package:my_app/widgets/home_header.dart';
import 'package:my_app/widgets/home_info_panel.dart';
import 'package:my_app/widgets/home_profile_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _primaryColor = Color(0xFF1A5C6B);
  static const Color _dangerColor = Color(0xFFE84C4F);

  final HomeController homeController = HomeController();

  @override
  void initState() {
    super.initState();
    homeController.addListener(_refresh);
    _loadUserData();
  }

  @override
  void dispose() {
    homeController.removeListener(_refresh);
    homeController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadUserData() async {
    final error = await homeController.loadUserData();
    if (!mounted || error == null) return;

    _showMessage(error);
  }

  Future<void> _logout() async {
    final error = await homeController.logout();
    if (!mounted) return;

    if (error == null) {
      Navigator.of(context).pushReplacementNamed('/auth');
      return;
    }

    _showMessage(error);
  }

  Future<void> _confirmDeleteAccount() async {
    if (homeController.isBusy) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Supprimer le compte'),
        content: const Text(
          'Cette action supprimera définitivement votre compte Firebase. Elle ne peut pas être annulée.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: _dangerColor),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await _deleteAccount();
    }
  }

  Future<void> _deleteAccount() async {
    final error = await homeController.deleteAccount();
    if (!mounted) return;

    if (error == null) {
      Navigator.of(context).pushReplacementNamed('/auth');
      _showMessage('Compte supprimé avec succès.');
      return;
    }

    _showMessage(error);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: homeController.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Column(
                    children: [
                      HomeHeader(
                        isSigningOut: homeController.isSigningOut,
                        onLogout: _logout,
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                HomeProfileHeader(
                                  name: homeController.displayName,
                                  email: homeController.email,
                                  initials: homeController.initials,
                                ),
                                const SizedBox(height: 24),
                                const HomeInfoPanel(
                                  icon: Icons.verified_user_outlined,
                                  title: 'Connexion active',
                                  subtitle:
                                      'Vous êtes connecté à votre compte Firebase.',
                                ),
                                const SizedBox(height: 14),
                                const HomeInfoPanel(
                                  icon: Icons.lock_outline_rounded,
                                  title: 'Compte sécurisé',
                                  subtitle:
                                      'Vous pouvez quitter la session ou supprimer le compte.',
                                ),
                                const SizedBox(height: 28),
                                HomeActionButton(
                                  label: homeController.isSigningOut
                                      ? 'Déconnexion...'
                                      : 'Se déconnecter',
                                  icon: Icons.logout_rounded,
                                  backgroundColor: _primaryColor,
                                  foregroundColor: Colors.white,
                                  isLoading: homeController.isSigningOut,
                                  onPressed: _logout,
                                ),
                                const SizedBox(height: 12),
                                HomeActionButton(
                                  label: homeController.isDeletingAccount
                                      ? 'Suppression...'
                                      : 'Supprimer mon compte',
                                  icon: Icons.delete_outline_rounded,
                                  backgroundColor: const Color(0xFFFFEEEE),
                                  foregroundColor: _dangerColor,
                                  isLoading: homeController.isDeletingAccount,
                                  onPressed: _confirmDeleteAccount,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
