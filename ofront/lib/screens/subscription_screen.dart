import 'package:epik/models/eleve.dart';
import 'package:epik/screens/login_screen.dart';
import 'package:epik/services/auth_service.dart';
import 'package:epik/services/student_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker_web/image_picker_web.dart';

class SusbcriptionScreen extends StatefulWidget {
  const SusbcriptionScreen({super.key});

  @override
  State<SusbcriptionScreen> createState() {
    return _SusbcriptionScreenState();
  }
}

class _SusbcriptionScreenState extends State<SusbcriptionScreen> {
  final AuthService authService = AuthService();
  final StudentService stdService = StudentService();

  final _nomController = TextEditingController();
  final _prenomsController = TextEditingController();
  final _labelController = TextEditingController();
  final _identifiantController = TextEditingController();
  final _mdpController = TextEditingController();
  final _mdp2Controller = TextEditingController();
  final _cappController = TextEditingController();
  final _telController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isSending = false;

  String errorPwd = "";
  Uint8List? _imageData; // Pour stocker les données de l'image sélectionnée

  Future<void> _pickImage() async {
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    setState(() {
      _imageData = bytesFromPicker;
    });
  }

  bool _isFilled = false;

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  void _moveToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
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
    // if (!_formKey.currentState!.validate()) {
    //   showAlert(title: 'Erreur!', description: 'Données invalides');
    //   //return;
    // }

    setState(() {
      _isSending = true;
    });

    final name = _labelController.text;
    final nom = _nomController.text;
    final telephone = _telController.text;
    final email = _emailController.text;
    final prenoms = _prenomsController.text;
    final pwd = _mdpController.text;
    final pwd2 = _mdp2Controller.text;
    final capp = _cappController.text;

    if (name != "" &&
        nom != "" &&
        prenoms != "" &&
        pwd != "" &&
        telephone != "" &&
        email != "") {
      if (pwd != pwd2) {
        showAlert(title: 'Erreur !', description: _errorText);
        return;
      }

      if (pwd.length < 8) {
        showAlert(
            title: 'Erreur !', description: "Le mot de passe est trop court");
        return;
      }

      Instructor input = Instructor(
        name: name,
        email: email,
        firstName: prenoms,
        lastName: nom,
        telephone: telephone,
        password: pwd,
        password2: pwd,
        logo: _imageData,
        capp: capp,
      );

      try {
        Instructor insResut = await stdService.createInsctructor(input);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color.fromARGB(255, 2, 52, 28),
          duration: const Duration(seconds: 10),
          content: Text(
              '${insResut.name} a été inscrit avec Succès ! Vous avez désormais accès à la plateforme.'),
        ));
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      } catch (e) {
        showAlert(
            title: 'Erreur !',
            description:
                "Une erreur a été rencontrée.\n Ce nom d'utilisateur existe déjà.");
      }

      setState(() {
        _isFilled = false;
        _isSending = false;
      });

      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(
      //     builder: (context) => const FeedbackScreen(
      //       title: 'Félicitations!',
      //       description: 'Vous avez été inscrit avec Succès',
      //       success: true,
      //     ),
      //   ),
      //   (route) => false,
      // );
    } else {
      showAlert(
          title: 'Erreur !',
          description: "Veuillez renseigner tous les champs svp.");

      setState(() {
        _isSending = false;
        _isFilled = true;
      });
    }

    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  final _formKey = GlobalKey<FormState>();
  bool showTelError = false;
  String _errorText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Container(
      //     color: Colors.amberAccent,
      //     child: const Padding(
      //       padding: EdgeInsets.all(30),
      //       child: Text("Demarrez l'enregistrement de votre auto ecole"),
      //     ),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align left by default
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.amberAccent,
                        child: const Padding(
                          padding: EdgeInsets.all(30),
                          child: Text(
                              textAlign: TextAlign.center,
                              "Demarrez l'enregistrement de votre auto ecole"),
                        ),
                      ),
                      const SizedBox(height: 4.0),
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
                              ? const Center(child: Text('Choisir une image.'))
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
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
                                controller: _cappController,
                                decoration: const InputDecoration(
                                  labelText: "CAPP",
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  helperText: "Entrez un email valide",
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                controller: _telController,
                                decoration: const InputDecoration(
                                  helperText:
                                      "Entrez un numéro de téléphone valide", // Add helper text here
                                  helperStyle: TextStyle(color: Colors.grey),
                                  labelText: "Téléphone",
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
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
                                  controller: _mdpController,
                                  maxLength: 10,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    helperText:
                                        "Un mélange de majuscules, miniscule, chiffres et caractères spéciaux",
                                    helperStyle: TextStyle(color: Colors.grey),
                                    labelText: "Mot de passe",
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    errorPwd = "";
                                    if (value != _mdp2Controller.text) {
                                      setState(() {
                                        errorPwd =
                                            "Les 2 mots de passe ne sont pas identiques";
                                      });
                                    }
                                  }),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                  maxLength: 10,
                                  controller: _mdp2Controller,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    helperText: errorPwd,
                                    helperStyle:
                                        const TextStyle(color: Colors.grey),
                                    labelText: "Répéter le Mot de passe",
                                    labelStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    border: const OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      errorPwd = "";
                                    });

                                    if (value != _mdpController.text) {
                                      setState(() {
                                        errorPwd =
                                            "Les 2 mots de passe ne sont pas identiques";
                                      });
                                    }
                                  }),
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
                                  borderRadius:
                                      BorderRadius.zero, // Bords rectangulaires
                                ),
                              ),
                              child: _isSending
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Text('Creer mon compte',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                            ),
                            TextButton(
                              onPressed: _moveToLogin,
                              child: const Text("Je me connecte"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
