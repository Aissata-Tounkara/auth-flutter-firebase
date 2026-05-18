import 'package:flutter/material.dart';
import 'package:my_app/controllers/register_controller.dart';
import 'package:my_app/widgets/custom_input.dart';
import 'package:my_app/widgets/custom_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController registerController = RegisterController();

  String firstNameError = '';
  String lastNameError = '';
  String emailError = '';
  String passwordError = '';
  String generalError = '';
  bool isLoading = false;

  @override
  void dispose() {
    registerController.dispose();
    super.dispose();
  }

  Future<void> handleRegister() async {
    setState(() {
      isLoading = true;
      firstNameError = '';
      lastNameError = '';
      emailError = '';
      passwordError = '';
      generalError = '';
    });

    final errors = await registerController.register();

    if (!mounted) return;

    setState(() {
      firstNameError = errors['firstName'] ?? '';
      lastNameError = errors['lastName'] ?? '';
      emailError = errors['email'] ?? '';
      passwordError = errors['password'] ?? '';
      generalError = errors['general'] ?? '';
      isLoading = false;
    });

    if (errors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inscription réussie ✅")),
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ❌ Plus de Scaffold ni SafeArea — AuthScreen les fournit
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Créez votre compte',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          if (generalError.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(generalError,
                  style: const TextStyle(color: Colors.red)),
            ),

          CustomInput(
            label: "Prénom",
            controller: registerController.firstNameController,
            keyboardType: TextInputType.text,
            autocorrect: false,
          ),

          if (firstNameError.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(firstNameError,
                  style: const TextStyle(color: Colors.red)),
            ),

          const SizedBox(height: 20),

          CustomInput(
            label: "Nom",
            controller: registerController.lastNameController,
            keyboardType: TextInputType.text,
            autocorrect: false,
          ),

          if (lastNameError.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(lastNameError,
                  style: const TextStyle(color: Colors.red)),
            ),

          const SizedBox(height: 20),

          CustomInput(
            label: "Email",
            controller: registerController.emailController,
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
            controller: registerController.passwordController,
            obscureText: true,
          ),

          if (passwordError.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(passwordError,
                  style: const TextStyle(color: Colors.red)),
            ),

          const SizedBox(height: 30),

          CustomButton(
            text: isLoading ? "Création..." : "Créer un compte",
            onPressed: isLoading ? null : handleRegister,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}