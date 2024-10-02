import 'package:flutter/material.dart';

class SoldeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
        children: [
          const Center(
            child: Text(
              'Pour acceder à votre compte et mieux gérer votre argent en toute sécurité, veuillez vous connecter sur cette plateforme',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 30), // Espace entre les éléments

          Center(
              child: Container(
            color: const Color.fromARGB(255, 70, 63,
                62), // Utilisez la propriété 'color' pour définir la couleur de fond
            width: double.infinity,
            alignment: Alignment.center, // Centre le texte dans le Container

            height: 100,
            child: TextButton(
              child: const Text('WWW.FOCUSPAY.COM',
                  style: TextStyle(color: Colors.white, fontSize: 80)),
              onPressed: () {}, // Couleur et taille du texte
            ),
          )),
        ],
      ),
    );
  }
}
