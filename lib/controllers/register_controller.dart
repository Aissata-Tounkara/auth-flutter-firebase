import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Importe ton service
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController {
  final AuthService _authService = AuthService();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<Map<String, String>> register() async {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    Map<String, String> errors = {};

    if (firstName.isEmpty) {
      errors["firstName"] = "Prénom requis";
    }

    if (lastName.isEmpty) {
      errors["lastName"] = "Nom requis";
    }

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
      await _authService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      return {};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        errors["email"] = "Email déjà utilisé";
      } else {
        errors["general"] = "Erreur d'inscription : ${e.message}";
      }
      return errors;
    } catch (e) {
      errors["general"] = "Erreur d'inscription : ${e.toString()}";
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
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
