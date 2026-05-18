import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../widgets/auth_tab_switcher.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _selectedIndex = 0;

  final List<Map<String, String>> _content = [
    {
    'title': 'Bon retour',
    'subtitle': 'Remplissez les informations ci-dessous pour\naccéder à votre compte.',
    },
    {
    'title': 'Créer un compte',
    'subtitle': 'Créez votre compte dès aujourd’hui et commencez\nune belle aventure.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

        Positioned.fill(
        child: Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,   // couvre tout l'écran
        ),
        ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                const Text(
                  'My App ✦',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Titre dynamique ──
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _content[_selectedIndex]['title']!,
                    key: ValueKey(_selectedIndex),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // ── Sous-titre dynamique ──
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _content[_selectedIndex]['subtitle']!,
                    key: ValueKey('sub_$_selectedIndex'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Carte blanche qui prend tout le reste ──
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [

                          // ── Switcher ──
                          AuthTabSwitcher(
                            selectedIndex: _selectedIndex,
                            onTabChanged: (index) {
                              setState(() => _selectedIndex = index);
                            },
                          ),

                          const SizedBox(height: 24),

                          // ── Formulaire ──
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _selectedIndex == 0
                                ? const LoginPage(key: ValueKey('login'))
                                : const RegisterPage(key: ValueKey('register')),
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

