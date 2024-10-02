import 'dart:convert';

import 'package:epik/env.dart';
import 'package:epik/models/eleve.dart';
import 'package:epik/models/user.dart';
import 'package:epik/screens/feedback.dart';
import 'package:epik/screens/home_screen.dart';
import 'package:epik/screens/login_screen.dart';
import 'package:epik/services/auth_service.dart';
import 'package:epik/services/student_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen(
      {super.key, required this.actualInstructor, required this.actualUser});
  final Instructor actualInstructor;
  final User actualUser;
  @override
  State<ProfilScreen> createState() {
    return _ProfilScreenState();
  }
}

class _ProfilScreenState extends State<ProfilScreen> {
  final AuthService authService = AuthService();
  final StudentService stdService = StudentService();
  final _nomController = TextEditingController();
  final _prenomsController = TextEditingController();
  final _labelController = TextEditingController();
  final _telController = TextEditingController();
  final _emailController = TextEditingController();

  Uint8List? _imageData; // Pour stocker les données de l'image sélectionnée

  void initForm() {
    if (widget.actualInstructor.logoUrl != null) {
      loadImage(imageSrc + widget.actualInstructor.logoUrl!);
    }
    _labelController.text = widget.actualInstructor.name!.trim();
    _nomController.text = widget.actualUser.last_name.trim();
    _prenomsController.text = widget.actualUser.first_name.trim();
    _emailController.text = widget.actualUser.email.trim();
    _telController.text = widget.actualInstructor.telephone!.trim() ?? '';
  }

  @override
  void initState() {
    super.initState();
    initForm();
  }

  void loadImage(String imageUrl) async {
    Uint8List? bytesFromImage = await stdService.urlToUint8List(imageUrl);
    setState(() {
      _imageData = bytesFromImage;
    });
  }

  Future<void> _pickImage() async {
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    setState(() {
      _imageData = bytesFromPicker;
    });
  }

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

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

  Future<void> _subscribe() async {
    try {
      final name = _labelController.text.trim();
      final nom = _nomController.text.trim();
      final telephone = _telController.text.trim();
      final email = _emailController.text.trim();
      final prenoms = _prenomsController.text.trim();
      if (name != "" &&
          nom != null &&
          prenoms != null &&
          telephone != null &&
          email != null) {
        Instructor input = Instructor(
          id: widget.actualInstructor.id,
          name: name,
          email: email,
          firstName: prenoms,
          lastName: nom,
          telephone: telephone,
          logo: _imageData!,
        );

        Instructor insResut = await stdService.updateInsctructor(input);
        if (insResut == null) {
          showAlert(title: 'Erreur!', description: 'Données invalides');
          return;
        }

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("Mise à jour réussie !"),
        // ));
        showAlert(
            title: 'Réussie !', description: 'Profil modifié avec succès');

        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('Instructor', json.encode(insResut.toJson()));

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );

        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (context) => const FeedbackScreen(
        //       title: 'Félicitations!',
        //       description: 'Mise à jour réussie !',
        //       success: true,
        //     ),
        //   ),
        //   (route) => false,
        // );
      } else {
        showAlert(title: 'Erreur!', description: 'Formulaire non valide');
      }
    } catch (e) {
      showAlert(title: 'Erreur!', description: 'Impossible de modifier');
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool showTelError = false;
  String _errorText = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0.4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align left by default
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //const SizedBox(height: 20.0),
            InkWell(
              onTap: _pickImage,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.transparent,
                ),
                height: 250,
                width: 200,
                child: _imageData == null
                    ? const Center(child: Text('Aucune image sélectionnée.'))
                    : Image.memory(
                        _imageData!,
                        width: 250,
                        height: 200,
                        fit: BoxFit.fitWidth,
                      ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextField(
                      controller: _labelController,
                      decoration: const InputDecoration(
                        labelText: "Nom Auto Ecole",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextField(
                      controller: _nomController,
                      decoration: const InputDecoration(
                        labelText: "Nom",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: _prenomsController,
                      decoration: const InputDecoration(
                        labelText: "Prénoms",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextField(
                      controller: _emailController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: _telController,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        labelText: "Téléphone",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _subscribe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Bords rectangulaires
                      ),
                    ),
                    child: const Text('Valider',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
