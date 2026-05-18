import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<Map<String, String>> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    Map<String, String> errors = {};

    if (email.isEmpty) {
      errors["email"] = "Email requis";
    } else if (!validateEmail(email)) {
      errors["email"] = "Format email invalide";
    }

    if (password.isEmpty) {
      errors["password"] = "Mot de passe requis";
    } else if (!validatePassword(password)) {
      errors["password"] = "Min 6 caractères";
    }

    if (errors.isNotEmpty) {
      return errors;
    }

    try {
      final emailExists = await _authService.userEmailExists(email);

      if (!emailExists) {
        errors["email"] = "Aucun compte trouvé avec cet email";
        return errors;
      }

      await _authService.login(email: email, password: password);

      return {};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errors["email"] = "Aucun compte trouvé avec cet email";
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errors["password"] = "Mot de passe incorrect";
      } else if (e.code == 'invalid-email') {
        errors["email"] = "Format email invalide";
      } else {
        errors["general"] = "Erreur de connexion : ${e.message}";
      }
      return errors;
    } catch (e) {
      errors["general"] = "Erreur de connexion : ${e.toString()}";
      return errors;
    }
  }

  bool validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool validatePassword(String password) {
    return password.length >= 6;
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
