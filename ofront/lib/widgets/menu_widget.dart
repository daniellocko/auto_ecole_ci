import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  final List<String> menuItems;
  final int selectedIndex;
  final ValueChanged<int> onMenuItemSelected;

  MenuWidget({
    required this.menuItems,
    required this.selectedIndex,
    required this.onMenuItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0, // Largeur du volet de gauche
      color: Colors.grey[200],
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () => onMenuItemSelected(index),
                  child: Container(
                    height: 100, // Hauteur fixe des boîtes de menu
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.orange
                          : const Color.fromARGB(255, 105, 103,
                              103), // Fond orange pour le sélectionné, gris pour les autres
                      border: const Border(
                        top: BorderSide(
                          color: Colors.white,
                          width: 5, // Épaisseur de la bordure supérieure
                        ),
                        // bottom: BorderSide(
                        //   color: Colors.white,
                        //   width: 2.0, // Épaisseur de la bordure inférieure
                        // ),
                      ),
                    ),

                    alignment: Alignment
                        .center, // Centre le texte horizontalement et verticalement
                    child: Text(
                      menuItems[index],
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
