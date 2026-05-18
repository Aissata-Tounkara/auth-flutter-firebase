import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:my_app/services/auth_service.dart';

class HomeController extends ChangeNotifier {
  final AuthService _authService;

  HomeController({AuthService? authService})
    : _authService = authService ?? AuthService();

  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isSigningOut = false;
  bool isDeletingAccount = false;

  String get email {
    return (userData?['email'] as String?) ??
        _authService.getCurrentUser()?.email ??
        '';
  }

  String get displayName {
    final firstName = userData?['firstName'] as String?;
    final lastName = userData?['lastName'] as String?;
    final fullName = [
      if (firstName != null && firstName.trim().isNotEmpty) firstName.trim(),
      if (lastName != null && lastName.trim().isNotEmpty) lastName.trim(),
    ].join(' ');

    return fullName.isEmpty ? 'Utilisateur' : fullName;
  }

  String get initials {
    final words = displayName.trim().split(RegExp(r'\s+'));

    if (words.isEmpty || words.first.isEmpty) {
      return 'U';
    }

    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }

    return '${words.first.substring(0, 1)}${words.last.substring(0, 1)}'
        .toUpperCase();
  }

  bool get isBusy => isSigningOut || isDeletingAccount;

  Future<String?> loadUserData() async {
    try {
      final currentUser = _authService.getCurrentUser();

      if (currentUser != null) {
        userData = await _authService.getUserData(currentUser.uid);
      }

      isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return 'Impossible de charger le profil: $e';
    }
  }

  Future<String?> logout() async {
    if (isBusy) return null;

    isSigningOut = true;
    notifyListeners();

    try {
      await _authService.logout();
      return null;
    } catch (e) {
      isSigningOut = false;
      notifyListeners();
      return 'Erreur: $e';
    }
  }

  Future<String?> deleteAccount() async {
    if (isBusy) return null;

    isDeletingAccount = true;
    notifyListeners();

    try {
      await _authService.deleteAccount();
      return null;
    } on FirebaseAuthException catch (e) {
      isDeletingAccount = false;
      notifyListeners();

      if (e.code == 'requires-recent-login') {
        return 'Reconnectez-vous avant de supprimer votre compte.';
      }

      return e.message ?? 'Impossible de supprimer le compte.';
    } catch (e) {
      isDeletingAccount = false;
      notifyListeners();
      return 'Erreur: $e';
    }
  }
}
