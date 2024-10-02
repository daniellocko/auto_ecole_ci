import 'package:epik/models/eleve.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuipuxScreen extends StatefulWidget {
  final Student e;
  const QuipuxScreen({super.key, required this.e});
  @override
  State<QuipuxScreen> createState() {
    return _QuipuxScreenState();
  }
}

class _QuipuxScreenState extends State<QuipuxScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 320,
        color: Colors.orange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Alignement à gauche
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                'Accès Quipux',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 30), // Espace entre les éléments

            Center(
                child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                // Utilisez la propriété 'color' pour définir la couleur de fond
                width: double.infinity,
                alignment:
                    Alignment.center, // Centre le texte dans le Container
                height: 100,
                child: Text(
                  textAlign: TextAlign.center,
                  "Chère utilisateur, Merci d'avoir rempli vos obligations.\nVous avez désormais accès à QUIPUX de ${widget.e.firstName} ${widget.e.lastName}.",
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            )),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.zero, // Bords rectangulaires
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: widget.e.qid != null
                            ? Row(children: [
                                Text(widget.e.qid!,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: Icon(Icons.copy),
                                  onPressed: () async {
                                    try {
                                      await Clipboard.setData(
                                          ClipboardData(text: widget.e.qid!));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Le Numero a bien été copié")),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text('Echec de la copie')),
                                      );
                                    }
                                  },
                                ),
                              ])
                            : const Text(
                                'ND',
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.zero, // Bords rectangulaires
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          'Retour',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
