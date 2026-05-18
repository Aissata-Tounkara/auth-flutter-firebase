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
      'title': 'Welcome Back',
      'subtitle': 'Fill out the information below in order to\naccess your account.',
    },
    {
      'title': 'Create Account',
      'subtitle': 'Create your account today and start\na wonderful journey.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // ── Fond dégradé ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A5C6B), Color(0xFF2A8A7A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ── Points décoratifs ──
          const Positioned(top: 60,  left: 30,  child: _Star(size: 6)),
          const Positioned(top: 100, right: 50, child: _Star(size: 4)),
          const Positioned(top: 140, left: 80,  child: _Star(size: 3)),
          const Positioned(top: 80,  right: 120,child: _Star(size: 5)),
          const Positioned(top: 160, right: 30, child: _Star(size: 3)),

          // ── Contenu principal ──
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // ── Nom de l'app ──
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

// ── Point étoile décoratif ──
class _Star extends StatelessWidget {
  final double size;
  const _Star({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white54,
        shape: BoxShape.circle,
      ),
    );
  }
}