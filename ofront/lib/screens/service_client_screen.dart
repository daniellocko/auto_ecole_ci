import 'package:flutter/material.dart';

class ServiceClientScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      // Ajout de padding pour espacer le contenu des bords
      child: Container(
          height: 200,
          color: const Color.fromARGB(255, 158, 148,
              147), // Utilisez la propriété 'color' pour définir la couleur de fond
          width: double.infinity,
          alignment: Alignment.center, // Centre le texte dans le Container
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.email,
                    size: 100,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'autoecole@gmail.com',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 100,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '00225 0709030780',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
