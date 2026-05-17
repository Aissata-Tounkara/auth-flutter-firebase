# 🔥 Guide Firebase + Flutter

**Configuration et intégration Firebase dans votre application Flutter**

---

## Table des matières

1. [Commandes exécutées](#commandes-exécutées)
2. [Résultats de la configuration](#résultats-de-la-configuration)
3. [Exécution sans exposer les clés](#exécution-sans-exposer-les-clés)
4. [Étapes Firebase Console](#étapes-firebase-console)
5. [Firestore Database](#firestore-database)

---

## Commandes exécutées

### 1. Installation de Firebase CLI

```bash
curl -sL https://firebase.tools | upgrade=true bash
```

✅ Résultat : `firebase-tools@15.18.0 is now installed`

### 2. Installation globale firebase-tools via npm

```bash
npm install -g firebase-tools
```

✅ Résultat : `added 674 packages in 57s`

### 3. Connexion à Firebase

```bash
firebase login
```

✅ Résultat : `Success! Logged in as korobaramahamane311@gmail.com`

### 4. Ajout des packages Flutter

```bash
# Firebase Core
flutter pub add firebase_core
# ✅ Résultat : firebase_core 4.8.0

# Firebase Auth
flutter pub add firebase_auth
# ✅ Résultat : "firebase_auth" is already in "dependencies"

# FlutterFire CLI
dart pub global activate flutterfire_cli
# ✅ Résultat : Installed executable flutterfire

# Ajouter au PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### 5. Configuration FlutterFire

```bash
flutterfire configure
```

✅ Résultat : Sélectionné le projet **TestFlutter** et généré `lib/firebase_options.dart`

```
Firebase configuration file lib/firebase_options.dart generated successfully with the following Firebase apps:

Platform  Firebase App Id
web       1:948030505702:web:3791e978b2ab3973443127
android   1:948030505702:android:84450ff53fe78588443127
ios       1:948030505702:ios:3dec2e85e552a0c1443127
macos     1:948030505702:ios:3dec2e85e552a0c1443127
windows   1:948030505702:web:7f37f87101827f5f443127
```

### 6. Ajout de Cloud Firestore

```bash
flutter pub add cloud_firestore
```

✅ Résultat : `cloud_firestore 6.4.0` ajouté

---

## Résultats de la configuration

✅ **Fichiers générés :**

- `lib/firebase_options.dart` - Configuration Firebase pour toutes les plateformes

✅ **Packages ajoutés :**

- `firebase_core` (4.8.0)
- `firebase_auth` (déjà présent)
- `cloud_firestore` (6.4.0)

---

## Exécution sans exposer les clés

Le dépôt ne versionne plus les clés API Firebase.

`lib/firebase_options.dart` attend maintenant ces variables au lancement :

- `FIREBASE_WEB_API_KEY`
- `FIREBASE_ANDROID_API_KEY`
- `FIREBASE_IOS_API_KEY`

Notes :

- Windows réutilise `FIREBASE_WEB_API_KEY`
- macOS réutilise `FIREBASE_IOS_API_KEY`

### Exemple pour Android

```bash
flutter run \
  --dart-define=FIREBASE_ANDROID_API_KEY=VOTRE_CLE_ANDROID
```

### Exemple pour Web

```bash
flutter run -d chrome \
  --dart-define=FIREBASE_WEB_API_KEY=VOTRE_CLE_WEB
```

### Exemple pour iOS

```bash
flutter run -d ios \
  --dart-define=FIREBASE_IOS_API_KEY=VOTRE_CLE_IOS
```

### Important

Les anciennes clés déjà poussées sur GitHub doivent quand même être :

- restreintes ou régénérées dans Google Cloud / Firebase
- puis marquées comme résolues dans l’alerte GitHub

---

## Étapes Firebase Console

### Étape 1 : Activer l'authentification

1. Allez sur [Firebase Console](https://console.firebase.google.com)
2. Sélectionnez votre projet **TestFlutter**
3. Dans le menu de gauche, cliquez sur **Authentication**
4. Cliquez sur **Get started**
5. Cliquez sur **Email/Password** dans la liste
6. Activez l'option **Email/Password** (basculez le bouton)
7. Cliquez sur **Save**

✅ Résultat : L'authentification par email/mot de passe est maintenant activée

### Étape 2 : Configurer Firestore

1. Dans le menu de gauche, cliquez sur **Firestore Database**
2. Cliquez sur **Create database**
3. Choisissez le mode : **Start in test mode** (pour le développement)
4. Choisissez la région la plus proche
5. Cliquez sur **Create**

✅ Résultat : Firestore Database créée et prête à l'usage

### Structure de données recommandée

```
firestore/
├── users/ (collection)
│   └── {uid} (document)
│       ├── firstName: string
│       ├── lastName: string
│       ├── email: string
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
└── posts/ (collection)
    └── {postId} (document)
        ├── uid: string (référence utilisateur)
        ├── title: string
        ├── content: string
        ├── likes: number
        ├── createdAt: timestamp
        └── updatedAt: timestamp
```

---

**Créé le :** 14 mai 2026  
**Version :** 1.0  
**Status :** ✅ Configuration terminée
