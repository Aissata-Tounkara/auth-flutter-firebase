import 'package:flutter/material.dart';
import 'package:my_app/controllers/login_controller.dart';
import 'package:my_app/widgets/custom_input.dart';
import 'package:my_app/screens/register_screen.dart';
import 'package:my_app/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Connexion réussie ✅")));

      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

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
                  child: Text(
                    emailError,
                    style: const TextStyle(color: Colors.red),
                  ),
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
                  child: Text(
                    passwordError,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              if (generalError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    generalError,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 30),

              CustomButton(
                text: isLoading ? "Connexion..." : "Se connecter",
                onPressed: isLoading ? null : handleLogin,
                isLoading: isLoading,
              ),
              const SizedBox(height: 30),

              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Je n'ai pas de compte 🤨 ",
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Dans ce cas je le créé",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 135, 47, 194),
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
