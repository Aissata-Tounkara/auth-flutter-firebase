import 'package:flutter/material.dart';
import 'package:my_app/controllers/login_controller.dart';
import 'package:my_app/widgets/custom_input.dart';
import 'package:my_app/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = LoginController();

  String emailError = '';
  String passwordError = '';
  String generalError = '';
  bool isLoading = false;

  @override
  void dispose() {
    loginController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
      emailError = '';
      passwordError = '';
      generalError = '';
    });

    final errors = await loginController.login();

    if (!mounted) return;

    setState(() {
      emailError = errors['email'] ?? '';
      passwordError = errors['password'] ?? '';
      generalError = errors['general'] ?? '';
      isLoading = false;
    });

    if (errors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connexion réussie ✅")),
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Plus de Scaffold ni SafeArea — AuthScreen les fournit
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Connectez-vous pour continuer',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          CustomInput(
            label: "Email",
            controller: loginController.emailController,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
          ),

          if (emailError.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(emailError,
                  style: const TextStyle(color: Colors.red)),
            ),

          const SizedBox(height: 20),

          CustomInput(
            label: "Mot de passe",
            controller: loginController.passwordController,
            obscureText: true,
          ),

          if (passwordError.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(passwordError,
                  style: const TextStyle(color: Colors.red)),
            ),

          if (generalError.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(generalError,
                  style: const TextStyle(color: Colors.red)),
            ),

          const SizedBox(height: 30),

          CustomButton(
            text: isLoading ? "Connexion..." : "Se connecter",
            onPressed: isLoading ? null : handleLogin,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}