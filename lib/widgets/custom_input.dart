import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {  // ← StatefulWidget au lieu de StatelessWidget
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
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late bool _isObscured;  // État local pour afficher/cacher

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;  // Initialiser avec la valeur passée
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,          // ← utilise l'état local
      autocorrect: widget.autocorrect,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),

        // ── Icône œil — visible SEULEMENT si c'est un champ mot de passe
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isObscured
                      ? Icons.visibility_outlined       // œil ouvert
                      : Icons.visibility_off_outlined,  // œil barré
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;  // Inverser l'état
                  });
                },
              )
            : null,  // Pas d'icône pour les autres champs
      ),
    );
  }
}