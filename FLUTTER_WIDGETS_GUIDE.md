# 📚 Guide Complet des Widgets Flutter

**Un guide détaillé et progressif pour comprendre et maîtriser TOUS les widgets Flutter**

---

## Table des matières

### Niveau 1 : Les bases

1. [Qu'est-ce qu'un Widget ?](#quest-ce-quun-widget-)
2. [Widgets de texte](#widgets-de-texte)
3. [Widgets de boutons](#widgets-de-boutons)
4. [Widgets de layout](#widgets-de-layout)
5. [Spacing et padding](#spacing-et-padding)

### Niveau 2 : Interactivité

6. [Widgets d'input](#widgets-dinput)
7. [Gestion des événements](#gestion-des-événements)
8. [Containers et décoration](#containers-et-décoration)

### Niveau 3 : UI Avancée

9. [Dialogs et notifications](#dialogs-et-notifications)
10. [Listes et grilles](#listes-et-grilles)
11. [Scroll et défilement](#scroll-et-défilement)
12. [Navigation](#navigation)

### Niveau 4 : Styling et thème

13. [Colors et styles](#colors-et-styles)
14. [Icons et images](#icons-et-images)
15. [Animations](#animations)

### Bonus

16. [Comparaison Flutter vs React](#comparaison-flutter-vs-react)
17. [Comparaison Flutter vs HTML/CSS](#comparaison-flutter-vs-htmlcss)
18. [Patterns et bonnes pratiques](#patterns-et-bonnes-pratiques)

---

## Qu'est-ce qu'un Widget ? 🎯

### Définition

Un **Widget** est le bloc de construction fondamental dans Flutter. C'est un objet qui décrit une partie de l'interface utilisateur.

**Analogies :**

```
Flutter Widget     ≈     React Component      ≈     HTML Element
──────────────────       ─────────────────           ─────────────
Text()                   <div>...</div>              <div>...</div>
Button()                 <button>...</button>        <button>...</button>
Row()                    <div style="display: flex">  <flex container>
```

### Types de widgets

#### 1️⃣ **StatelessWidget** (Sans état)

Un widget qui ne change jamais après sa création.

```dart
class MyText extends StatelessWidget {
  const MyText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Je ne change jamais');
  }
}
```

**Quand l'utiliser ?**

- Texte statique
- Images statiques
- Composants purement visuels

**Analogie :**

- React : Composant fonctionnel sans hooks
- HTML : Un élément `<p>` qui ne change jamais

#### 2️⃣ **StatefulWidget** (Avec état)

Un widget qui peut changer et se mettre à jour.

```dart
class MyCounter extends StatefulWidget {
  const MyCounter({super.key});

  @override
  State<MyCounter> createState() => _MyCounterState();
}

class _MyCounterState extends State<MyCounter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Compteur: $count'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: Text('Incrémenter'),
        ),
      ],
    );
  }
}
```

**Quand l'utiliser ?**

- Formulaires
- Compteurs
- Animations
- Données qui changent

**Analogie :**

- React : Composant avec `useState()`
- HTML : Un formulaire avec JavaScript qui se met à jour

### Arborescence des widgets

Tous les widgets Flutter s'organisent en arbre (tree) :

```
MyApp (root)
  ├─ MaterialApp (style)
  ├─ Scaffold (structure)
  │   ├─ AppBar (en-tête)
  │   ├─ Body
  │   │   ├─ Column (vertical)
  │   │   │   ├─ Text
  │   │   │   ├─ Button
  │   │   │   └─ Row
  │   │   │       ├─ Icon
  │   │   │       └─ Text
  │   │   └─ FloatingActionButton
  │   └─ BottomNavigationBar
```

---

## Widgets de texte

### 1. **Text** - Afficher du texte simple

**Syntaxe basique :**

```dart
Text('Bonjour le monde')
```

**Avec styles :**

```dart
Text(
  'Bonjour le monde',
  style: TextStyle(
    fontSize: 24,                    // Taille en pixels
    fontWeight: FontWeight.bold,     // Gras
    color: Colors.blue,              // Couleur
    fontStyle: FontStyle.italic,     // Italique
    decoration: TextDecoration.underline,  // Souligné
    letterSpacing: 2.0,              // Espacement entre lettres
    wordSpacing: 5.0,                // Espacement entre mots
  ),
)
```

**Comparaisons :**

| Flutter              | React              | HTML/CSS            |
| -------------------- | ------------------ | ------------------- |
| `Text('texte')`      | `<div>texte</div>` | `<p>texte</p>`      |
| `fontSize: 24`       | `fontSize: 24`     | `font-size: 24px`   |
| `FontWeight.bold`    | `fontWeight: 700`  | `font-weight: bold` |
| `color: Colors.blue` | `color: 'blue'`    | `color: blue`       |

**Exemple complet :**

```dart
Text(
  'Cliquez pour continuer',
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,  // 100-900 (normal=400, bold=700)
    color: Colors.grey[700],       // Gris plus clair
  ),
  textAlign: TextAlign.center,     // Centrer le texte
  maxLines: 2,                     // Maximum 2 lignes
  overflow: TextOverflow.ellipsis, // "..." si trop long
)
```

---

### 2. **RichText** - Texte avec plusieurs styles

**C'est comme du HTML avec du style mixte :**

```dart
RichText(
  text: TextSpan(
    text: 'Bonjour ',
    style: TextStyle(color: Colors.black),
    children: [
      TextSpan(
        text: 'le monde',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: ' !',
        style: TextStyle(color: Colors.red),
      ),
    ],
  ),
)
```

**Résultat :**

```
Bonjour le monde !
       (noir) (bleu gras) (rouge)
```

**Comparaison :**

```html
<!-- HTML -->
<p>
  Bonjour <strong style="color: blue;">le monde</strong> <span style="color: red;">!</span>
</p>

<!-- React -->
<p>
  Bonjour <span style={{color: 'blue', fontWeight: 'bold'}}>le monde</span>{' '}
  <span style={{color: 'red'}}>!</span>
</p>

<!-- Flutter -->
RichText(
  text: TextSpan(
    text: 'Bonjour ',
    children: [
      TextSpan(
        text: 'le monde',
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: ' !',
        style: TextStyle(color: Colors.red),
      ),
    ],
  ),
)
```

---

## Widgets de boutons

### 1. **ElevatedButton** - Bouton surélevé

Le bouton principal et conseillé.

```dart
ElevatedButton(
  onPressed: () {
    print('Bouton cliqué !');
  },
  child: Text('Cliquer ici'),
)
```

**Avec style personnalisé :**

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,           // Couleur de fond
    foregroundColor: Colors.white,          // Couleur du texte
    padding: EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 16,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),  // Coins arrondis
    ),
    elevation: 8,                           // Ombre (hauteur)
  ),
  child: Text('Bouton'),
)
```

**Comparaison :**

```html
<!-- HTML/CSS -->
<button style="
  background-color: blue;
  color: white;
  padding: 16px 32px;
  border-radius: 12px;
  box-shadow: 0 8px 16px rgba(0,0,0,0.3);
  border: none;
">
  Bouton
</button>

<!-- React -->
<button
  style={{
    backgroundColor: 'blue',
    color: 'white',
    padding: '16px 32px',
    borderRadius: '12px',
    boxShadow: '0 8px 16px rgba(0,0,0,0.3)',
  }}
>
  Bouton
</button>

<!-- Flutter -->
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 8,
  ),
  child: Text('Bouton'),
)
```

---

### 2. **OutlinedButton** - Bouton avec bordure

```dart
OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    foregroundColor: Colors.blue,          // Couleur de la bordure
    side: BorderSide(
      color: Colors.blue,
      width: 2,
    ),
  ),
  child: Text('Bouton secondaire'),
)
```

**Vs :**

```html
<!-- HTML -->
<button
  style="
  border: 2px solid blue;
  color: blue;
  background: transparent;
  padding: 10px 20px;
"
>
  Bouton secondaire
</button>
```

---

### 3. **TextButton** - Bouton texte simple

```dart
TextButton(
  onPressed: () {},
  child: Text('Annuler'),
)
```

**Comparaison :**

```html
<!-- HTML -->
<button style="background: none; border: none; cursor: pointer; color: blue;">
  Annuler
</button>

<!-- React -->
<button style={{background: 'none', border: 'none', cursor: 'pointer', color: 'blue'}}>
  Annuler
</button>
```

---

### 4. **IconButton** - Bouton avec icône

```dart
IconButton(
  onPressed: () {},
  icon: Icon(Icons.favorite),           // Icône cœur
  color: Colors.red,
  iconSize: 32,
)
```

---

### 5. **FloatingActionButton** - Bouton flottant

Le petit bouton rond en bas à droite (FAB).

```dart
FloatingActionButton(
  onPressed: () {},
  child: Icon(Icons.add),                // Icône +
  backgroundColor: Colors.blue,
  tooltip: 'Ajouter',                    // Texte au survol
)
```

---

## Widgets de layout

### 1. **Column** - Disposition verticale

Empile les widgets verticalement (un au-dessus de l'autre).

```dart
Column(
  children: [
    Text('Ligne 1'),
    Text('Ligne 2'),
    Text('Ligne 3'),
  ],
)
```

**Avec options :**

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,      // Vertical: center/start/end/space
  crossAxisAlignment: CrossAxisAlignment.start,     // Horizontal: start/center/end
  children: [
    Text('Widget 1'),
    SizedBox(height: 20),                          // Espace
    Text('Widget 2'),
  ],
)
```

**Comparaison :**

```html
<!-- HTML/CSS -->
<div style="display: flex; flex-direction: column;">
  <div>Ligne 1</div>
  <div>Ligne 2</div>
  <div>Ligne 3</div>
</div>

<!-- React -->
<div style={{display: 'flex', flexDirection: 'column'}}>
  <div>Ligne 1</div>
  <div>Ligne 2</div>
  <div>Ligne 3</div>
</div>

<!-- Flutter -->
Column(
  children: [
    Text('Ligne 1'),
    Text('Ligne 2'),
    Text('Ligne 3'),
  ],
)
```

---

### 2. **Row** - Disposition horizontale

Empile les widgets horizontalement (côte à côte).

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // Espacement égal
  crossAxisAlignment: CrossAxisAlignment.center,     // Centre verticalement
  children: [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.settings),
  ],
)
```

**Comparaison :**

```html
<!-- HTML/CSS -->
<div style="display: flex; flex-direction: row; justify-content: space-evenly; align-items: center;">
  <i>🏠</i>
  <i>🔍</i>
  <i>⚙️</i>
</div>

<!-- React -->
<div style={{display: 'flex', justifyContent: 'space-evenly', alignItems: 'center'}}>
  <span>🏠</span>
  <span>🔍</span>
  <span>⚙️</span>
</div>

<!-- Flutter -->
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.settings),
  ],
)
```

---

### 3. **Stack** - Superposition d'éléments

Empile les widgets l'un sur l'autre.

```dart
Stack(
  children: [
    // Widget 1 (dessous)
    Container(
      width: 200,
      height: 200,
      color: Colors.blue,
    ),
    // Widget 2 (sur le dessus)
    Positioned(
      top: 20,
      left: 20,
      child: Text('Texte par-dessus'),
    ),
  ],
)
```

**Comparaison :**

```html
<!-- HTML/CSS -->
<div style="position: relative; width: 200px; height: 200px; background: blue;">
  <div style="position: absolute; top: 20px; left: 20px;">Texte par-dessus</div>
</div>

<!-- Flutter -->
Stack( children: [ Container(width: 200, height: 200, color: Colors.blue),
Positioned(top: 20, left: 20, child: Text('Texte par-dessus')), ], )
```

---

### 4. **Center** - Centrer le contenu

```dart
Center(
  child: Text('Centré'),
)
```

**Équivalent HTML :**

```html
<div
  style="display: flex; justify-content: center; align-items: center; height: 100%;"
>
  Centré
</div>
```

---

### 5. **Expanded** - Remplir l'espace disponible

```dart
Row(
  children: [
    Text('Gauche'),
    Expanded(
      child: Text('Remplit l\'espace'),  // Prend tout l'espace libre
    ),
    Text('Droite'),
  ],
)
```

**Comparaison :**

```html
<!-- HTML -->
<div style="display: flex;">
  <div>Gauche</div>
  <div style="flex: 1;">Remplit l'espace</div>
  <div>Droite</div>
</div>

<!-- React -->
<div style={{display: 'flex'}}>
  <div>Gauche</div>
  <div style={{flex: 1}}>Remplit l'espace</div>
  <div>Droite</div>
</div>

<!-- Flutter -->
Row(
  children: [
    Text('Gauche'),
    Expanded(
      child: Text('Remplit l\'espace'),
    ),
    Text('Droite'),
  ],
)
```

---

## Spacing et padding

### 1. **SizedBox** - Espace fixe ou conteneur de taille fixe

**Pour créer de l'espace :**

```dart
Column(
  children: [
    Text('Haut'),
    SizedBox(height: 20),    // Espace vertical de 20px
    Text('Bas'),
  ],
)
```

**Pour redimensionner :**

```dart
SizedBox(
  width: 100,
  height: 100,
  child: Container(color: Colors.blue),
)
```

**Comparaison :**

```html
<!-- HTML -->
<div style="height: 20px;"></div>

<!-- CSS -->
margin: 20px 0; padding: 20px;

<!-- Flutter -->
SizedBox(height: 20) Padding(padding: EdgeInsets.all(20), child: ...)
```

---

### 2. **Padding** - Ajouter de l'espace interne

```dart
Padding(
  padding: EdgeInsets.all(16),           // Partout
  child: Text('Texte avec padding'),
)
```

**Options de padding :**

```dart
// Tout
EdgeInsets.all(16)

// Horizontal et vertical
EdgeInsets.symmetric(horizontal: 16, vertical: 20)

// Spécifique
EdgeInsets.only(left: 16, right: 16, top: 20)

// À partir d'un directif
EdgeInsets.fromLTRB(left, top, right, bottom)
```

**Comparaison :**

```css
/* CSS */
padding: 16px;                          /* tous les côtés */
padding: 20px 16px;                     /* haut/bas et gauche/droite */
padding: 20px 16px 10px 5px;            /* haut, droite, bas, gauche */

/* Flutter */
EdgeInsets.all(16)
EdgeInsets.symmetric(vertical: 20, horizontal: 16)
EdgeInsets.only(left: 5, top: 20, right: 16, bottom: 10)
```

---

### 3. **Margin** - Espace externe

Flutter n'a pas de "margin" direct, utilisez `SizedBox` ou `Padding` :

```dart
// Technique 1 : SizedBox
Column(
  children: [
    Text('Haut'),
    SizedBox(height: 20),
    Text('Bas'),
  ],
)

// Technique 2 : Padding autour
Container(
  margin: EdgeInsets.all(20),  // Utiliser margin directement
  child: Text('Texte'),
)

// Technique 3 : En nesting
Padding(
  padding: EdgeInsets.all(20),
  child: Text('Texte'),
)
```

---

## Widgets d'input

### 1. **TextField** - Champ texte simple

```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Entrez votre nom',        // Placeholder
    labelText: 'Nom',                    // Label
    border: OutlineInputBorder(),        // Bordure
    prefixIcon: Icon(Icons.person),      // Icône à gauche
    suffixIcon: Icon(Icons.close),       // Icône à droite
  ),
  keyboardType: TextInputType.text,      // Type de clavier
  obscureText: false,                    // Masquer le texte ? (mot de passe)
)
```

**Avec controller :**

```dart
class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
        ),
        ElevatedButton(
          onPressed: () {
            print('Valeur: ${controller.text}');
          },
          child: Text('Soumettre'),
        ),
      ],
    );
  }
}
```

**Comparaison :**

```html
<!-- HTML -->
<input type="text" placeholder="Entrez votre nom" />

<!-- React -->
<input
  type="text"
  placeholder="Entrez votre nom"
  value="{value}"
  onChange="{(e)"
  =""
/>
setValue(e.target.value)} />

<!-- Flutter -->
TextField( controller: controller, decoration: InputDecoration( hintText:
'Entrez votre nom', border: OutlineInputBorder(), ), )
```

---

### 2. **TextFormField** - Champ avec validation

```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Email',
    border: OutlineInputBorder(),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un email';
    }
    if (!value.contains('@')) {
      return 'Email invalide';
    }
    return null;  // Valide
  },
)
```

---

### 3. **Checkbox** - Case à cocher

```dart
bool checked = false;

Checkbox(
  value: checked,
  onChanged: (bool? value) {
    setState(() {
      checked = value ?? false;
    });
  },
)
```

**Avec texte :**

```dart
CheckboxListTile(
  title: Text('J\'accepte les conditions'),
  value: checked,
  onChanged: (bool? value) {
    setState(() {
      checked = value ?? false;
    });
  },
)
```

**Comparaison :**

```html
<!-- HTML -->
<input type="checkbox" id="check" />
<label for="check">J'accepte les conditions</label>

<!-- React -->
<label>
  <input type="checkbox" checked="{checked}" onChange="{(e)" ="" />
  setChecked(e.target.checked)} /> J'accepte les conditions
</label>

<!-- Flutter -->
CheckboxListTile( title: Text('J\'accepte les conditions'), value: checked,
onChanged: (value) => setState(() => checked = value ?? false), )
```

---

### 4. **Radio** - Bouton radio

```dart
int selectedValue = 1;

Column(
  children: [
    Radio(
      value: 1,
      groupValue: selectedValue,
      onChanged: (value) {
        setState(() {
          selectedValue = value!;
        });
      },
    ),
    Text('Option 1'),
    Radio(
      value: 2,
      groupValue: selectedValue,
      onChanged: (value) {
        setState(() {
          selectedValue = value!;
        });
      },
    ),
    Text('Option 2'),
  ],
)
```

**Avec texte :**

```dart
RadioListTile(
  title: Text('Option 1'),
  value: 1,
  groupValue: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value!),
)
```

---

### 5. **DropdownButton** - Liste déroulante

```dart
String selectedValue = 'Option 1';

DropdownButton(
  value: selectedValue,
  onChanged: (String? value) {
    setState(() {
      selectedValue = value!;
    });
  },
  items: [
    DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
    DropdownMenuItem(value: 'Option 2', child: Text('Option 2')),
    DropdownMenuItem(value: 'Option 3', child: Text('Option 3')),
  ],
)
```

**Comparaison :**

```html
<!-- HTML -->
<select>
  <option value="1">Option 1</option>
  <option value="2">Option 2</option>
  <option value="3">Option 3</option>
</select>

<!-- React -->
<select value="{selected}" onChange="{(e)" ="">
  setSelected(e.target.value)}>
  <option value="1">Option 1</option>
  <option value="2">Option 2</option>
  <option value="3">Option 3</option>
</select>

<!-- Flutter -->
DropdownButton( value: selectedValue, onChanged: (value) => setState(() =>
selectedValue = value), items: [ DropdownMenuItem(value: '1', child:
Text('Option 1')), DropdownMenuItem(value: '2', child: Text('Option 2')),
DropdownMenuItem(value: '3', child: Text('Option 3')), ], )
```

---

### 6. **Slider** - Curseur

```dart
double sliderValue = 0.5;

Slider(
  value: sliderValue,
  min: 0,
  max: 100,
  onChanged: (value) {
    setState(() {
      sliderValue = value;
    });
  },
)
```

**Comparaison :**

```html
<!-- HTML -->
<input type="range" min="0" max="100" value="50" />

<!-- React -->
<input type="range" min="0" max="100" value="{value}" onChange="{(e)" ="" />
setValue(e.target.value)} />

<!-- Flutter -->
Slider( value: sliderValue, min: 0, max: 100, onChanged: (value) => setState(()
=> sliderValue = value), )
```

---

## Containers et décoration

### 1. **Container** - Conteneur universel

```dart
Container(
  width: 200,
  height: 200,
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.all(10),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.black, width: 2),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Text('Container'),
)
```

**Comparaison :**

```html
<!-- HTML/CSS -->
<div style="
  width: 200px;
  height: 200px;
  padding: 16px;
  margin: 10px;
  background: blue;
  border-radius: 12px;
  border: 2px solid black;
  box-shadow: 0 4px 10px rgba(0,0,0,0.26);
">
  Container
</div>

<!-- React -->
<div style={{
  width: '200px',
  height: '200px',
  padding: '16px',
  margin: '10px',
  background: 'blue',
  borderRadius: '12px',
  border: '2px solid black',
  boxShadow: '0 4px 10px rgba(0,0,0,0.26)',
}}>
  Container
</div>

<!-- Flutter -->
Container(
  width: 200,
  height: 200,
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.all(10),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.black, width: 2),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Text('Container'),
)
```

---

### 2. **BoxDecoration** - Décorer un container

```dart
BoxDecoration(
  // Couleur
  color: Colors.blue,

  // Forme
  shape: BoxShape.circle,  // ou BoxShape.rectangle

  // Bordure
  border: Border.all(
    color: Colors.black,
    width: 2,
  ),

  // Coins arrondis
  borderRadius: BorderRadius.circular(12),  // Tous les coins
  // ou
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(12),
    topRight: Radius.circular(12),
  ),

  // Ombre
  boxShadow: [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 10,        // Flou
      spreadRadius: 2,       // Étendue
      offset: Offset(0, 4),  // Position (x, y)
    ),
  ],

  // Gradient
  gradient: LinearGradient(
    colors: [Colors.blue, Colors.purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),

  // Image de fond
  image: DecorationImage(
    image: AssetImage('assets/background.jpg'),
    fit: BoxFit.cover,
  ),
)
```

---

## Dialogs et notifications

### 1. **AlertDialog** - Boîte de dialogue

```dart
showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text('Confirmation'),
      content: Text('Êtes-vous sûr ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            // Faire quelque chose
            Navigator.pop(context);
          },
          child: Text('Confirmer'),
        ),
      ],
    );
  },
)
```

**Comparaison :**

```javascript
// JavaScript
alert('Êtes-vous sûr ?');
confirm('Êtes-vous sûr ?');

// React avec bibliothèque
import Dialog from '@material-ui/core/Dialog';
<Dialog open={true}>
  <DialogTitle>Confirmation</DialogTitle>
  <DialogContent>Êtes-vous sûr ?</DialogContent>
  <DialogActions>
    <Button>Annuler</Button>
    <Button>Confirmer</Button>
  </DialogActions>
</Dialog>

// Flutter
showDialog(
  context: context,
  builder: (context) => AlertDialog(...),
)
```

---

### 2. **SnackBar** - Notification en bas

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Message d\'information'),
    duration: Duration(seconds: 3),
    action: SnackBarAction(
      label: 'Annuler',
      onPressed: () {
        // Action au clic
      },
    ),
    backgroundColor: Colors.green,
  ),
)
```

**Comparaison :**

```javascript
// JavaScript
// Notifification native (toast)
// Généralement une bibliothèque comme Toastify

// React
import { toast } from 'react-toastify';
toast.success('Message d\'information');

// Flutter
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Message d\'information')),
)
```

---

### 3. **Bottom Sheet** - Feuille en bas

```dart
showModalBottomSheet(
  context: context,
  builder: (BuildContext context) {
    return Container(
      height: 250,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Éditer'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Supprimer'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  },
)
```

---

## Listes et grilles

### 1. **ListView** - Liste défilante

**Simple :**

```dart
ListView(
  children: [
    ListTile(
      title: Text('Élément 1'),
      subtitle: Text('Sous-titre'),
      leading: Icon(Icons.person),
    ),
    ListTile(
      title: Text('Élément 2'),
    ),
    ListTile(
      title: Text('Élément 3'),
    ),
  ],
)
```

**Avec builder (pour beaucoup d'éléments) :**

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index]),
      onTap: () {
        print('Cliqué sur ${items[index]}');
      },
    );
  },
)
```

**Comparaison :**

```html
<!-- HTML -->
<ul>
  <li>Élément 1</li>
  <li>Élément 2</li>
  <li>Élément 3</li>
</ul>

<!-- React -->
<ul>
  {items.map((item, index) => (
  <li key="{index}">{item}</li>
  ))}
</ul>

<!-- Flutter -->
ListView.builder( itemCount: items.length, itemBuilder: (context, index) {
return ListTile(title: Text(items[index])); }, )
```

---

### 2. **GridView** - Grille

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,  // 2 colonnes
    childAspectRatio: 1.0,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
  ),
  itemCount: 12,
  itemBuilder: (context, index) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text('Item ${index + 1}'),
      ),
    );
  },
)
```

**Comparaison :**

```css
/* CSS Grid */
display: grid;
grid-template-columns: repeat(2, 1fr);
gap: 10px;

/* React */
<div style={{display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '10px'}}>
  {items.map((item) => <div key={item}>{item}</div>)}
</div>

/* Flutter */
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
  ),
  itemBuilder: (context, index) {
    return Container(color: Colors.blue);
  },
)
```

---

### 3. **ListTile** - Élément de liste

```dart
ListTile(
  leading: Icon(Icons.favorite),
  title: Text('Titre'),
  subtitle: Text('Sous-titre'),
  trailing: Icon(Icons.arrow_forward),
  onTap: () => print('Cliqué'),
  selected: true,
  tileColor: Colors.grey[100],
)
```

---

## Scroll et défilement

### 1. **SingleChildScrollView** - Conteneur défilant

```dart
SingleChildScrollView(
  child: Column(
    children: [
      // Beaucoup de widgets
      for (int i = 0; i < 100; i++)
        Container(
          height: 100,
          margin: EdgeInsets.all(10),
          color: Colors.blue,
          child: Text('Item $i'),
        ),
    ],
  ),
)
```

---

### 2. **CustomScrollView** - Scroll personnalisé

```dart
CustomScrollView(
  slivers: [
    SliverAppBar(
      title: Text('Header'),
      floating: true,
      pinned: false,
      expandedHeight: 200,
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return ListTile(
            title: Text('Item $index'),
          );
        },
        childCount: 100,
      ),
    ),
  ],
)
```

---

## Navigation

### 1. **Navigator.push()** - Aller vers une nouvelle page

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SecondPage(),
  ),
)
```

---

### 2. **Navigator.pop()** - Revenir à la page précédente

```dart
Navigator.pop(context)
```

---

### 3. **Named Routes** - Navigation nommée

```dart
// Dans main.dart
MaterialApp(
  routes: {
    '/': (context) => HomePage(),
    '/about': (context) => AboutPage(),
    '/settings': (context) => SettingsPage(),
  },
)

// Pour naviguer
Navigator.pushNamed(context, '/about')
```

---

## Colors et styles

### 1. **Couleurs** - Palettes et utilisation

```dart
// Couleurs nommées
Colors.red
Colors.blue
Colors.green
Colors.grey
Colors.amber

// Teintes
Colors.red[50]    // Très clair
Colors.red[100]   // Plus clair
Colors.red[500]   // Normal (par défaut)
Colors.red[900]   // Très foncé

// Couleur personnalisée
Color.fromARGB(255, 135, 47, 194)  // (Alpha, Red, Green, Blue)
Color(0xFF8730C2)                   // Notation hexadécimale

// Transparence
Colors.blue.withOpacity(0.5)  // 50% transparent
Colors.blue.withAlpha(128)    // Alpha 128 (0-255)
```

**Comparaison :**

```css
/* CSS */
color: red;
color: #FF0000;
color: rgba(255, 0, 0, 0.5);

/* React */
color: 'red'
color: '#FF0000'
color: 'rgba(255, 0, 0, 0.5)'

/* Flutter */
Colors.red
Color(0xFFFF0000)
Colors.red.withOpacity(0.5)
```

---

### 2. **TextStyle** - Style du texte

```dart
TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.blue,
  fontStyle: FontStyle.italic,
  decoration: TextDecoration.underline,
  letterSpacing: 2.0,
  wordSpacing: 5.0,
  height: 1.5,
  shadows: [
    Shadow(
      color: Colors.black26,
      offset: Offset(2, 2),
      blurRadius: 3,
    ),
  ],
)
```

**Poids de police :**

```dart
FontWeight.w100  // Thin
FontWeight.w300  // Light
FontWeight.w400  // Normal
FontWeight.w500  // Medium
FontWeight.w700  // Bold
FontWeight.w900  // Black

// Ou simplement
FontWeight.normal
FontWeight.bold
```

---

### 3. **ThemeData** - Thème global

```dart
MaterialApp(
  theme: ThemeData(
    primaryColor: Colors.blue,
    accentColor: Colors.amber,
    fontFamily: 'Roboto',
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      elevation: 0,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    ),
  ),
  home: HomePage(),
)
```

---

## Icons et images

### 1. **Icon** - Icônes Material

```dart
Icon(
  Icons.favorite,
  size: 32,
  color: Colors.red,
)
```

**Icônes courantes :**

```dart
Icons.home
Icons.search
Icons.settings
Icons.favorite
Icons.arrow_forward
Icons.add
Icons.delete
Icons.edit
Icons.close
Icons.check
Icons.menu
Icons.person
Icons.logout
Icons.shopping_cart
Icons.email
Icons.phone
Icons.location_on
Icons.star
```

---

### 2. **Image** - Afficher des images

**Depuis les assets :**

```dart
Image.asset(
  'assets/images/my_image.png',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
)
```

**Depuis l'internet :**

```dart
Image.network(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
      ),
    );
  },
)
```

**BoxFit (comment adapter l'image) :**

```dart
BoxFit.cover      // Remplir, couper si nécessaire
BoxFit.contain    // Entièrement visible, peut avoir des espaces
BoxFit.fill       // Remplir sans garder le ratio
BoxFit.fitWidth   // Adapter à la largeur
BoxFit.fitHeight  // Adapter à la hauteur
BoxFit.scaleDown  // Réduire si nécessaire, sinon original
```

**Comparaison :**

```html
<!-- HTML -->
<img src="image.jpg" style="width: 200px; height: 200px; object-fit: cover;" />

<!-- React -->
<img src="image.jpg" style={{width: '200px', height: '200px', objectFit: 'cover'}} />

<!-- Flutter -->
Image.asset(
  'assets/image.jpg',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
)
```

---

### 3. **CircleAvatar** - Avatar circulaire

```dart
CircleAvatar(
  radius: 50,
  backgroundColor: Colors.blue,
  child: Icon(Icons.person, size: 40),
)

// Ou avec image
CircleAvatar(
  radius: 50,
  backgroundImage: AssetImage('assets/profile.jpg'),
)
```

---

## Animations

### 1. **AnimatedContainer** - Container animé

```dart
bool expanded = false;

AnimatedContainer(
  width: expanded ? 200 : 100,
  height: expanded ? 200 : 100,
  color: expanded ? Colors.blue : Colors.red,
  duration: Duration(seconds: 1),
  curve: Curves.easeInOut,
  child: Center(
    child: GestureDetector(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Text('Cliquer'),
    ),
  ),
)
```

---

### 2. **Opacity** - Transparence animée

```dart
bool visible = true;

AnimatedOpacity(
  opacity: visible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 500),
  child: Text('Visible ?'),
)
```

---

### 3. **SlideTransition** - Animation de déplacement

```dart
late AnimationController controller;
late Animation<Offset> offsetAnimation;

@override
void initState() {
  super.initState();
  controller = AnimationController(
    duration: Duration(seconds: 1),
    vsync: this,
  );

  offsetAnimation = Tween<Offset>(
    begin: Offset(-1, 0),  // De la gauche
    end: Offset(0, 0),     // À la position normale
  ).animate(controller);

  controller.forward();
}

@override
Widget build(BuildContext context) {
  return SlideTransition(
    position: offsetAnimation,
    child: Text('Slide in'),
  );
}
```

---

## Patterns et bonnes pratiques

### 1. **Pattern MVC dans Flutter**

```dart
// Model : les données
class User {
  final String name;
  final String email;

  User({required this.name, required this.email});
}

// Controller : la logique
class UserController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Map<String, String> validate() {
    Map<String, String> errors = {};

    if (nameController.text.isEmpty) {
      errors['name'] = 'Nom requis';
    }

    if (!emailController.text.contains('@')) {
      errors['email'] = 'Email invalide';
    }

    return errors;
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
  }
}

// View : l'interface
class UserForm extends StatefulWidget {
  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final UserController controller = UserController();
  String nameError = '';
  String emailError = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleSubmit() {
    final errors = controller.validate();
    setState(() {
      nameError = errors['name'] ?? '';
      emailError = errors['email'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: controller.nameController),
        if (nameError.isNotEmpty) Text(nameError),
        TextField(controller: controller.emailController),
        if (emailError.isNotEmpty) Text(emailError),
        ElevatedButton(
          onPressed: handleSubmit,
          child: Text('Soumettre'),
        ),
      ],
    );
  }
}
```

---

### 2. **Widgets réutilisables**

```dart
// Créer un widget personnalisé
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
      child: Text(text),
    );
  }
}

// Utiliser le widget
CustomButton(
  text: 'Cliquer',
  onPressed: () => print('Cliqué'),
  color: Colors.green,
)
```

---

### 3. **Composition plutôt qu'héritage**

```dart
// ❌ Mauvaise approche : héritage
class MyRedButton extends ElevatedButton {
  // ...
}

// ✅ Bonne approche : composition
class MyButton extends StatelessWidget {
  final String label;

  const MyButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text(label),
    );
  }
}
```

---

## Comparaison Flutter vs React

### Structure basique

```dart
// Flutter
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Ma App')),
        body: Center(child: Text('Bonjour')),
      ),
    );
  }
}

// React
function MyApp() {
  return (
    <div className="app">
      <header>Ma App</header>
      <div className="container">
        <p>Bonjour</p>
      </div>
    </div>
  );
}
```

### État et mise à jour

```dart
// Flutter
class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: Text('Incrémenter'),
        ),
      ],
    );
  }
}

// React
function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>{count}</p>
      <button onClick={() => setCount(count + 1)}>
        Incrémenter
      </button>
    </div>
  );
}
```

### Listes

```dart
// Flutter
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(items[index]));
  },
)

// React
{items.map((item, index) => (
  <div key={index}>{item}</div>
))}
```

---

## Comparaison Flutter vs HTML/CSS

### Layout

```dart
// Flutter - Column (vertical)
Column(
  children: [
    Text('Haut'),
    Text('Milieu'),
    Text('Bas'),
  ],
)

// HTML/CSS
<div style="display: flex; flex-direction: column;">
  <p>Haut</p>
  <p>Milieu</p>
  <p>Bas</p>
</div>

// Flutter - Row (horizontal)
Row(
  children: [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.settings),
  ],
)

// HTML/CSS
<div style="display: flex; flex-direction: row;">
  <i class="icon-home"></i>
  <i class="icon-search"></i>
  <i class="icon-settings"></i>
</div>
```

### Box model

```dart
// Flutter
Container(
  width: 100,
  height: 100,
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.all(10),
  decoration: BoxDecoration(
    color: Colors.blue,
    border: Border.all(width: 2),
  ),
)

// HTML/CSS
<div style="
  width: 100px;
  height: 100px;
  padding: 16px;
  margin: 10px;
  background: blue;
  border: 2px solid;
"></div>
```

### Flexbox

```dart
// Flutter - Flex
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [Text('Gauche'), Text('Droite')],
)

// HTML/CSS
<div style="
  display: flex;
  justify-content: space-between;
  align-items: center;
">
  <p>Gauche</p>
  <p>Droite</p>
</div>
```

### Styling

```dart
// Flutter
Text(
  'Styled text',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
)

// HTML/CSS
<p style="
  font-size: 24px;
  font-weight: bold;
  color: blue;
">
  Styled text
</p>
```

---

## Conclusion

Flutter offre une approche **composant-first** similaire à React avec une syntaxe **Dart** unique. Le paradigme est similaire :

✅ **Similaire à React :**

- Composition de composants
- État réactif (setState)
- Props et paramètres
- Lifecycle

✅ **Similaire à HTML/CSS :**

- Layout avec Flexbox
- Box model (padding, margin, borders)
- Colors et Typography
- Responsive design

🎯 **Unique à Flutter :**

- Tout est widget
- Performance native
- Material Design intégré
- Pas de DOM, pas de CSS séparé

---

**Créé le :** 13 mai 2026  
**Version :** 1.0  
**Niveau :** Débutant → Avancé  
**Status :** ✅ Complet
