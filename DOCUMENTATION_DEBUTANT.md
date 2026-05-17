# Documentation Complete - Guide pour Debutant

## Table des matieres

1. Introduction
2. Structure du projet
3. Architecture generale
4. `main.dart`
5. `login_screen.dart`
6. `login_controller.dart`
7. `register_screen.dart`
8. `register_controller.dart`
9. `auth_service.dart`
10. `home_screen.dart`
11. `custom_input.dart`
12. `custom_button.dart`
13. Le loading : screen vs controller vs service vs Firebase
14. Resume du flux complet

---

## 1. Introduction

Cette application Flutter permet :

- de creer un compte
- de se connecter
- d'enregistrer des informations utilisateur dans Firebase
- d'afficher une page d'accueil apres connexion
- de se deconnecter

Le projet utilise :

- Flutter pour l'interface
- Firebase Auth pour la connexion et l'inscription
- Cloud Firestore pour stocker le profil utilisateur

Le but de cette documentation est de t'expliquer :

- le role de chaque fichier
- les widgets utilises
- les fonctions importantes
- pourquoi telle chose est utilisee
- comment les fichiers travaillent ensemble

---

## 2. Structure du projet

```text
└── lib
    ├── controllers
    │   ├── login_controller.dart
    │   └── register_controller.dart
    ├── models
    ├── screens
    │   ├── home_screen.dart
    │   ├── login_screen.dart
    │   └── register_screen.dart
    ├── services
    │   └── auth_service.dart
    ├── utils
    ├── widgets
    │   ├── custom_button.dart
    │   └── custom_input.dart
    ├── firebase_options.dart
    └── main.dart
```

### Role de chaque dossier

| Dossier | Role |
|---|---|
| `screens/` | Les pages visibles de l'application |
| `controllers/` | La logique des formulaires |
| `services/` | Les appels a Firebase |
| `widgets/` | Les composants reutilisables |
| `models/` | Les modeles de donnees, pour plus tard |
| `utils/` | Les fonctions utilitaires, pour plus tard |

### Pourquoi cette organisation est utile

Au lieu de tout mettre dans un seul fichier :

- `screen` affiche
- `controller` valide et decide
- `service` communique avec Firebase
- `widget` reutilisable evite la repetition

Cette separation rend le code plus propre et plus facile a maintenir.

---

## 3. Architecture generale

Dans ce projet, le chemin normal est :

```text
Utilisateur -> Screen -> Controller -> Service -> Firebase
```

Puis le resultat revient dans l'autre sens :

```text
Firebase -> Service -> Controller -> Screen -> Interface
```

### Exemple avec la connexion

1. l'utilisateur clique sur "Se connecter"
2. `LoginPage` appelle `handleLogin()`
3. `handleLogin()` appelle `loginController.login()`
4. `LoginController` valide les champs
5. `LoginController` appelle `_authService.login(...)`
6. `AuthService` appelle Firebase Auth
7. Firebase renvoie succes ou erreur
8. l'ecran affiche les erreurs ou navigue vers `HomeScreen`

---

## 4. `main.dart`

`main.dart` est le point d'entree de l'application.

### Code actuel

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
```

### Explication

#### `void main() async`

`main()` est la premiere fonction executee au lancement de l'application.

Le mot `async` est necessaire parce qu'on utilise `await` pour attendre l'initialisation de Firebase.

#### `WidgetsFlutterBinding.ensureInitialized()`

Cette ligne prepare Flutter avant d'executer certaines operations asynchrones au demarrage.

Pourquoi c'est necessaire ici ?

Parce que Firebase doit etre initialise avant que l'application ne commence a utiliser ses services.

#### `await Firebase.initializeApp(...)`

Cette ligne connecte ton application Flutter a Firebase.

Sans elle :

- l'inscription ne marcherait pas
- la connexion ne marcherait pas
- Firestore ne marcherait pas

#### `DefaultFirebaseOptions.currentPlatform`

Cette configuration vient de `firebase_options.dart`.
Elle contient les parametres Firebase adaptes a Android, iOS, web, etc.

#### `runApp(const MyApp())`

Cette ligne lance l'application et affiche le widget principal.

#### `MaterialApp`

`MaterialApp` sert a :

- definir l'application globale
- gerer la navigation
- fournir le style Material Design

#### `home: const LoginPage()`

Cela veut dire que le premier ecran affiche sera la page de connexion.

#### `routes`

```dart
routes: {
  '/login': (context) => const LoginPage(),
  '/home': (context) => const HomeScreen(),
}
```

Ces routes permettent de naviguer avec un nom simple.

Exemple :

```dart
Navigator.pushReplacementNamed(context, '/home');
```

### Pourquoi `pushReplacementNamed` est pratique

Au lieu d'empiler un nouvel ecran en gardant l'ancien, on remplace l'ecran actuel.

Dans ce projet :

- apres connexion, on remplace login par home
- apres deconnexion, on remplace home par login

Cela evite un mauvais retour arriere.

---

## 5. `login_screen.dart`

Ce fichier contient l'ecran de connexion.

### Code important

```dart
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
```

### Pourquoi `StatefulWidget`

Parce que cet ecran doit changer pendant l'execution.

Exemples :

- afficher un message d'erreur
- afficher ou retirer le loading
- desactiver le bouton pendant la connexion

Un `StatelessWidget` ne suffit pas pour ce besoin.

### Variables principales

```dart
final LoginController loginController = LoginController();

String emailError = '';
String passwordError = '';
String generalError = '';
bool isLoading = false;
```

### Role de ces variables

- `loginController` : contient la logique du formulaire
- `emailError` : erreur du champ email
- `passwordError` : erreur du champ mot de passe
- `generalError` : erreur globale
- `isLoading` : indique qu'une requete est en cours

### Pourquoi `dispose()` est present

```dart
@override
void dispose() {
  loginController.dispose();
  super.dispose();
}
```

Le `LoginController` contient des `TextEditingController`.
Ils doivent etre liberes quand l'ecran disparait.

### Fonction `handleLogin()`

```dart
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
```

### Explication pas a pas

#### 1. `setState(...)` au debut

On met :

- `isLoading = true`
- les erreurs a vide

Pourquoi ?

- pour afficher le spinner
- pour desactiver le bouton
- pour supprimer les anciens messages d'erreur

#### 2. `await loginController.login()`

Le screen ne parle pas directement a Firebase.
Il demande au controller de faire le travail.

#### 3. `if (!mounted) return;`

Si l'utilisateur quitte la page pendant l'attente, on evite d'appeler `setState()` sur un widget deja detruit.

#### 4. Deuxieme `setState(...)`

Quand la reponse revient :

- on affiche les erreurs
- on remet `isLoading = false`

#### 5. `SnackBar`

Si `errors.isEmpty`, cela veut dire que la connexion a reussi.
On affiche donc un message rapide en bas de l'ecran.

#### 6. Navigation

```dart
Navigator.pushReplacementNamed(context, '/home');
```

Cela remplace la page login par la page home.

### Champs de formulaire

```dart
CustomInput(
  label: "Email",
  controller: loginController.emailController,
  keyboardType: TextInputType.emailAddress,
  autocorrect: false,
),
```

### Pourquoi ce `CustomInput` est utile

Il reutilise le meme composant de champ au lieu de recrire un `TextFormField` complet a chaque fois.

### Affichage conditionnel des erreurs

```dart
if (emailError.isNotEmpty)
  Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Text(
      emailError,
      style: const TextStyle(color: Colors.red),
    ),
  ),
```

On n'affiche l'erreur que si elle existe.

### Bouton de connexion

```dart
CustomButton(
  text: isLoading ? "Connexion..." : "Se connecter",
  onPressed: isLoading ? null : handleLogin,
  isLoading: isLoading,
),
```

### Ce qu'il faut comprendre ici

- le texte change pendant le chargement
- le bouton est desactive si `isLoading` est vrai
- `CustomButton` affiche aussi un spinner grace a `isLoading`

### Lien vers l'inscription

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const RegisterPage(),
  ),
);
```

Ici, on ouvre l'ecran d'inscription par-dessus l'ecran de connexion.

---

## 6. `login_controller.dart`

Ce fichier contient la logique metier de la connexion.

### Code important

```dart
final AuthService _authService = AuthService();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
```

### Pourquoi ces variables existent

- `_authService` : pour appeler Firebase via le service
- `emailController` : pour lire le champ email
- `passwordController` : pour lire le champ mot de passe

### Fonction `login()`

```dart
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
    await _authService.login(email: email, password: password);
    return {};
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      errors["email"] = "Utilisateur non trouvé";
    } else if (e.code == 'wrong-password') {
      errors["password"] = "Mot de passe incorrect";
    } else {
      errors["general"] = "Erreur de connexion : ${e.message}";
    }
    return errors;
  } catch (e) {
    errors["general"] = "Erreur de connexion : ${e.toString()}";
    return errors;
  }
}
```

### Ce que fait cette fonction

1. lit les valeurs du formulaire
2. supprime les espaces inutiles avec `trim()`
3. valide les champs
4. retourne les erreurs si le formulaire est invalide
5. appelle le service si tout est bon
6. transforme les erreurs Firebase en messages comprenables

### Pourquoi `Future<Map<String, String>>`

- `Future` : parce que la connexion a besoin d'attendre Firebase
- `Map<String, String>` : parce qu'on veut lier chaque erreur a une cle

Exemple :

```dart
{
  "email": "Email requis",
  "password": "Min 6 caractères"
}
```

### Pourquoi la validation est dans le controller

Le controller est l'endroit ideal pour la logique du formulaire.

Le screen, lui, doit surtout afficher.

### Fonctions de validation

```dart
bool validateEmail(String email) {
  return email.contains("@");
}

bool validatePassword(String password) {
  return password.length >= 6;
}
```

Ce sont des regles simples, mais elles montrent bien que la logique metier est separee de l'interface.

### Fonction `dispose()`

Elle libere les `TextEditingController`.

---

## 7. `register_screen.dart`

Ce fichier contient l'ecran d'inscription.

### Pourquoi `StatefulWidget`

Comme pour la connexion, cet ecran doit mettre a jour :

- plusieurs erreurs
- l'etat de loading

### Variables principales

```dart
final RegisterController registerController = RegisterController();

String firstNameError = '';
String lastNameError = '';
String emailError = '';
String passwordError = '';
String confirmPasswordError = '';
String generalError = '';
bool isLoading = false;
```

### Pourquoi il y a plus d'erreurs ici

Parce que le formulaire d'inscription contient plus de champs.

### Fonction `handleRegister()`

```dart
Future<void> handleRegister() async {
  setState(() {
    isLoading = true;
    firstNameError = '';
    lastNameError = '';
    emailError = '';
    passwordError = '';
    confirmPasswordError = '';
    generalError = '';
  });

  final errors = await registerController.register();

  if (!mounted) return;

  setState(() {
    firstNameError = errors['firstName'] ?? '';
    lastNameError = errors['lastName'] ?? '';
    emailError = errors['email'] ?? '';
    passwordError = errors['password'] ?? '';
    confirmPasswordError = errors['confirmPassword'] ?? '';
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
```

### Ce que fait cette fonction

- active le loading
- nettoie les anciennes erreurs
- appelle le controller
- affiche les nouvelles erreurs
- arrete le loading
- navigue vers l'accueil si tout va bien

### Retour vers la connexion

```dart
Navigator.pop(context);
```

Pourquoi ?

Parce que l'ecran d'inscription a ete ouvert depuis la page de connexion avec `Navigator.push(...)`.
Donc `pop()` revient simplement a la page precedente.

---

## 8. `register_controller.dart`

Ce controller gere la logique de l'inscription.

### Les `TextEditingController`

```dart
final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController =
    TextEditingController();
```

Ils servent a lire les valeurs de chaque champ.

### Fonction `register()`

```dart
Future<Map<String, String>> register() async {
  String firstName = firstNameController.text.trim();
  String lastName = lastNameController.text.trim();
  String email = emailController.text.trim();
  String password = passwordController.text.trim();
  String confirmPassword = confirmPasswordController.text.trim();

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

  if (confirmPassword.isEmpty) {
    errors["confirmPassword"] = "Confirmation requise";
  } else if (password != confirmPassword) {
    errors["confirmPassword"] = "Les mots de passe ne correspondent pas";
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
```

### Ce que fait la fonction

1. lit les champs
2. valide chaque valeur
3. verifie que les deux mots de passe correspondent
4. appelle le service si tout est valide
5. retourne des erreurs lisibles

### Pourquoi la verification de confirmation est ici

Parce que c'est une regle du formulaire.
Elle doit etre dans la logique, pas directement dans le widget.

### Pourquoi on valide avant Firebase

Cela evite :

- des appels reseau inutiles
- une attente pour une erreur evidente
- une mauvaise experience utilisateur

---

## 9. `auth_service.dart`

Ce fichier contient tous les appels Firebase du projet.

### Code principal

```dart
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
```

### Role de ces objets

- `_auth` : inscription, connexion, deconnexion
- `_firestore` : ecriture et lecture des donnees utilisateur

### Fonction `register(...)`

```dart
Future<User?> register({
  required String email,
  required String password,
  required String firstName,
  required String lastName,
}) async {
  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = result.user;

    if (user != null) {
      await _firestore.collection("users").doc(user.uid).set({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }

    return user;
  } catch (e) {
    rethrow;
  }
}
```

### Ce qui se passe ici

#### 1. Creation du compte

Firebase Auth cree le compte avec :

```dart
_auth.createUserWithEmailAndPassword(...)
```

#### 2. Recuperation de l'utilisateur

`result.user` contient l'utilisateur cree.

#### 3. Enregistrement du profil dans Firestore

Ensuite on cree un document dans :

```text
users/<uid>
```

avec :

- `firstName`
- `lastName`
- `email`
- `createdAt`

### Pourquoi Firestore est utilise en plus de Firebase Auth

Firebase Auth gere surtout :

- l'email
- le mot de passe
- la session

Mais il ne sert pas a stocker tout le profil applicatif.

Pour le prenom, le nom et d'autres infos, Firestore est plus adapte.

### Pourquoi `user.uid` est utilise comme id du document

Parce que c'est un identifiant unique fourni par Firebase.
Il permet de retrouver facilement le bon document utilisateur.

### Fonction `login(...)`

```dart
Future<User?> login({required String email, required String password}) async {
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  } catch (e) {
    rethrow;
  }
}
```

Cette fonction tente de connecter un utilisateur deja cree.

### Fonction `logout()`

```dart
Future<void> logout() async {
  try {
    await _auth.signOut();
  } catch (e) {
    rethrow;
  }
}
```

Elle ferme la session en cours.

### Fonction `getCurrentUser()`

```dart
User? getCurrentUser() {
  return _auth.currentUser;
}
```

Elle retourne l'utilisateur connecte actuellement, ou `null`.

### Fonction `getUserData(String uid)`

```dart
Future<Map<String, dynamic>?> getUserData(String uid) async {
  try {
    DocumentSnapshot doc = await _firestore
        .collection("users")
        .doc(uid)
        .get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
  } catch (e) {
    rethrow;
  }
}
```

Cette fonction va lire le document Firestore de l'utilisateur.

---

## 10. `home_screen.dart`

Cet ecran s'affiche apres connexion ou inscription reussie.

### Variables principales

```dart
final AuthService _authService = AuthService();
Map<String, dynamic>? userData;
bool isLoading = true;
```

### Explication

- `_authService` : lit les donnees et gere la deconnexion
- `userData` : contient les informations du profil
- `isLoading` : indique si les donnees sont en cours de chargement

### Chargement au demarrage

```dart
@override
void initState() {
  super.initState();
  _loadUserData();
}
```

`initState()` est le bon endroit pour lancer un chargement initial.

### Fonction `_loadUserData()`

```dart
Future<void> _loadUserData() async {
  try {
    final currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      final data = await _authService.getUserData(currentUser.uid);
      if (!mounted) return;

      setState(() {
        userData = data;
        isLoading = false;
      });
      return;
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }
}
```

### Ce que fait cette fonction

1. recupere l'utilisateur courant
2. lit les donnees Firestore
3. met `userData` a jour
4. coupe le loading

### Affichage conditionnel

```dart
body: isLoading
    ? const Center(child: CircularProgressIndicator())
    : Padding(
        ...
      ),
```

Si les donnees ne sont pas encore disponibles, on affiche un loader.
Sinon on montre le contenu de la page.

### Affichage du profil

```dart
Text('${userData!['firstName']} ${userData!['lastName']}')
Text(userData!['email'])
```

Le `!` signifie :
"je suis sur que la valeur n'est pas nulle ici".

### Fonction `_logout()`

```dart
Future<void> _logout() async {
  final navigator = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Déconnexion'),
      content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(dialogContext);

            try {
              await _authService.logout();

              if (!mounted) return;

              navigator.pushReplacementNamed('/login');
            } catch (e) {
              if (!mounted) return;

              messenger.showSnackBar(
                SnackBar(content: Text('Erreur: $e')),
              );
            }
          },
          child: const Text('Déconnexion'),
        ),
      ],
    ),
  );
}
```

### Pourquoi `showDialog(...)`

La deconnexion est une action importante.
On demande donc une confirmation.

### Pourquoi `navigator` et `messenger` sont recuperes au debut

Cela rend le code plus propre et evite certains problemes d'usage du `context` apres une operation asynchrone.

---

## 11. `custom_input.dart`

Ce widget est un champ texte reutilisable.

### Code

```dart
class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool autocorrect;
  final bool obscureText;

  const CustomInput({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.autocorrect = true,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      autocorrect: autocorrect,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
```

### Pourquoi ce widget est utile

Au lieu de recrire plusieurs fois le meme `TextFormField`, on cree un composant reutilisable.

### A quoi servent les proprietes

- `controller` : lit le texte saisi
- `label` : texte du champ
- `keyboardType` : adapte le clavier
- `autocorrect` : active ou desactive la correction
- `obscureText` : masque le texte pour les mots de passe

### Pourquoi c'est un `StatelessWidget`

Parce qu'il n'a pas besoin de gerer un etat interne complexe.

---

## 12. `custom_button.dart`

Ce widget est un bouton reutilisable.

### Code principal

```dart
class CustomButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;

  const CustomButton({
    super.key,
    this.text,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = isDisabled || isLoading;

    return ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: _buildChild(),
    );
  }
}
```

### Pourquoi ce widget existe

Pour centraliser :

- le style
- la logique de desactivation
- l'affichage du loading

### Pourquoi `disabled = isDisabled || isLoading`

Si une requete est deja en cours, on empeche un nouveau clic.

Cela evite :

- double connexion
- double inscription
- appels multiples vers Firebase

### Methode `_buildChild()`

Elle decide quoi afficher :

- un spinner si `isLoading == true`
- une icone + un texte si les deux existent
- seulement une icone si besoin
- seulement du texte sinon

---

## 13. Le loading : screen vs controller vs service vs Firebase

Cette partie est tres importante.

### Point cle

Firebase ne gere pas directement ton `isLoading`.

Dans ce projet, le loading est gere par le `screen`.

### Repartition des responsabilites

#### `screen`

Le screen :

- met `isLoading = true`
- affiche ou masque le spinner
- desactive le bouton
- remet `isLoading = false`

#### `controller`

Le controller :

- valide les donnees
- appelle le service
- retourne des erreurs ou un succes

Il ne fait pas de `setState()`.

#### `service`

Le service :

- appelle Firebase Auth
- appelle Firestore
- renvoie le resultat

Il ne connait pas l'interface.

#### `Firebase`

Firebase :

- execute la requete
- renvoie une reponse
- ou lance une erreur

Il ne sait rien du bouton, du spinner ou du `setState()`.

### Exemple complet pour la connexion

```text
1. LoginPage met isLoading = true
2. LoginPage appelle await loginController.login()
3. LoginController valide et appelle await _authService.login(...)
4. AuthService appelle Firebase Auth
5. Firebase repond
6. AuthService renvoie le resultat
7. LoginController renvoie {} ou une map d'erreurs
8. LoginPage remet isLoading = false
9. LoginPage affiche l'erreur ou navigue
```

### Exemple complet pour l'inscription

```text
1. RegisterPage met isLoading = true
2. RegisterPage appelle await registerController.register()
3. RegisterController valide les champs
4. RegisterController appelle await _authService.register(...)
5. AuthService cree le compte dans Firebase Auth
6. AuthService enregistre le profil dans Firestore
7. Le resultat remonte jusqu'au screen
8. RegisterPage remet isLoading = false
9. RegisterPage affiche les erreurs ou navigue vers /home
```

### Pourquoi le loading doit etre gere par le screen

Parce que seul le screen connait l'interface utilisateur.

Le `controller` et le `service` ne doivent pas manipuler directement :

- `setState()`
- le bouton
- le spinner
- les widgets

Sinon on melangerait la logique et l'interface.

### Lien direct avec `CustomButton`

Dans les screens, on envoie :

```dart
isLoading: isLoading
```

Puis `CustomButton` affiche le spinner.

Donc :

- le screen decide s'il y a loading
- le bouton se contente de l'afficher

---

## 14. Resume du flux complet

### Flux de connexion

1. L'utilisateur remplit le formulaire dans `LoginPage`
2. `handleLogin()` met le loading a `true`
3. `loginController.login()` valide les champs
4. `_authService.login()` appelle Firebase Auth
5. le resultat revient au screen
6. `handleLogin()` remet le loading a `false`
7. l'ecran affiche les erreurs ou navigue vers `HomeScreen`

### Flux d'inscription

1. L'utilisateur remplit le formulaire dans `RegisterPage`
2. `handleRegister()` met le loading a `true`
3. `registerController.register()` valide les champs
4. `_authService.register()` appelle Firebase Auth
5. `_authService.register()` ecrit aussi le profil dans Firestore
6. le resultat revient au screen
7. `handleRegister()` remet le loading a `false`
8. l'ecran affiche les erreurs ou navigue vers `HomeScreen`

### Flux de deconnexion

1. L'utilisateur clique sur deconnexion
2. `showDialog(...)` demande confirmation
3. `_authService.logout()` ferme la session
4. l'application revient vers `'/login'`

---

## Conclusion

Ton projet a une architecture simple et saine pour apprendre Flutter :

- `main.dart` demarre Flutter et Firebase
- `screens` affichent l'interface
- `controllers` gerent la logique des formulaires
- `services` parlent avec Firebase
- `widgets` reutilisables evitent la repetition

La regle la plus importante a retenir est :

```text
Screen = affiche et gere le loading
Controller = valide et decide
Service = parle avec Firebase
Firebase = execute la requete
```

Si tu comprends bien cette separation, tu pourras faire evoluer l'application beaucoup plus facilement.
