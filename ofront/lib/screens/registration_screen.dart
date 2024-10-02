import 'package:epik/models/post_data.dart';
import 'package:epik/screens/feedback.dart';
import 'package:epik/services/student_service.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final StudentService stdService = StudentService();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomsController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController numeroPieceController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool showError = false;
  bool _isSending = false;
  String _errorText = '';
  // Variables pour stocker les valeurs des champs

  void showAlert({required String title, required String description}) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(title),
              content: Text(description),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  void _sumbit() async {
    try {
      final String _nom;
      final String _prenoms;
      final String _telephone;
      final String _numeroPiece;
      final String _email;

      _nom = nomController.text;
      _prenoms = prenomsController.text;
      _telephone = telephoneController.text;
      _numeroPiece = numeroPieceController.text;
      _email = emailController.text;

      if (_nom.isEmpty ||
          _prenoms.isEmpty ||
          _numeroPiece.isEmpty ||
          _telephone.isEmpty) {
        setState(() {
          showError = true;
          _errorText = 'Données invalides';
        });
      } else {
        setState(() {
          _isSending = true;
        });
        _formKey.currentState!.save();
        setState(() {
          _isSending = false;
        });

        UserRegistration input = UserRegistration(
            email: 'example@mail.com',
            firstName: _prenoms,
            lastName: _nom,
            telephone: _telephone,
            numPiece: _numeroPiece,
            enrollmentDate: DateTime.now().toString(),
            dateOfBirth: DateTime.now().toString());

        BackRegistration enrollmentResut =
            await stdService.createStudent(input);

        // Go to payment page
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const FeedbackScreen(
              title: 'Félicitations!',
              description: 'Eleve inscrit avec Succès',
              success: true,
            ),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      showAlert(
          title: 'Erreur !',
          description:
              "Un individu avec le même numero de téléphone existe déjà.");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to login $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nom',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nomController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 20.0),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Prénoms',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: prenomsController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 20.0),
              ),
            ),
            const SizedBox(height: 20),
            // const Text(
            //   'Email',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // TextField(
            //   controller: emailController,
            //   keyboardType: TextInputType.emailAddress,
            //   decoration: const InputDecoration(
            //     contentPadding: EdgeInsets.symmetric(vertical: 20.0),
            //   ),
            // ),
            const SizedBox(height: 20),
            const Text(
              'Téléphone',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: telephoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 20.0),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Numéro de pièce',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              maxLength: 10,
              controller: numeroPieceController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 20.0),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity *
                        0.1, // Prend toute la largeur de l'écran
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _sumbit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.zero, // Bords rectangulaires
                        ),
                      ),
                      child: const Text(
                        'Valider',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10), // Espace entre les deux boutons

                Expanded(
                  child: SizedBox(
                    //width: double.infinity, // Prend toute la largeur de l'écran
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Annuler',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 197, 195, 192),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.zero, // Bords rectangulaires
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
