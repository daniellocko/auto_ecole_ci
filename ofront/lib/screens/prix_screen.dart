import 'package:flutter/material.dart';

class PrixScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
          5.0), // Ajout de padding pour espacer le contenu des bords
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
        children: [
          const Center(
            child: Text(
              'Prix Standard',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 30), // Espace entre les éléments
          const Center(
            child: Text(
              'Montant (F CFA)',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
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
            child: const Text(
              '70 000',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 80), // Couleur et taille du texte
            ),
          )),
        ],
      ),
    );
  }
}
