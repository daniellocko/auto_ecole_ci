import 'dart:convert';

import 'package:epik/models/login.dart';
import 'package:epik/screens/home_screen.dart';
import 'package:epik/screens/subscription_screen.dart';
import 'package:epik/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isFilled = false;
  bool _isSending = false;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
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

  void _login() async {
    try {
      setState(() {
        _isSending = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final login = _loginController.text;
      final password = _passwordController.text;

      PostLogin inputData = PostLogin(username: login, password: password);
      final response = await authService.logIn(inputData);

      if (response.code == '1') {
        prefs.setString('User', json.encode(response.user.toJson()));
        prefs.setString(
            'Instructor', json.encode(response.instructor?.toJson()));

        prefs.setString('Student', json.encode(response.student?.toJson()));

        prefs.setString('Token', response.token);
        prefs.setString('Refresh', response.refresh);

        setState(() {
          _isSending = false;
        });

        if (response.user.is_instructor || response.user.username == 'azkone') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: const Color.fromARGB(255, 2, 52, 28),
            duration: const Duration(seconds: 10),
            content: Text('Connexion réussie !'),
          ));

          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          showAlert(
              title: 'Erreur !',
              description: "Vous n'êtes pas habileté à vous connecter !");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Vous n'êtes pas habilité à vous connecter !"),
          ));
        }
      } else {
        setState(() {
          _isSending = false;
        });

        showAlert(
            title: 'Erreur !',
            description: "Utilisateur ou mot de passe incorrect.");

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Echec de la connexion'),
        ));
      }
    } catch (e) {
      setState(() {
        _isSending = false;
      });
      showAlert(
          title: 'Erreur !',
          description: "Utilisateur ou mot de passe incorrect.");

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Failed to login $e'),
      // ));
    }
  }

  void _moveToSubscribe() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SusbcriptionScreen()));
  }

  void _forgotPassword() {
    // Implémente la logique pour mot de passe oublié ici
  }

  final _formKey = GlobalKey<FormState>();
  bool showTelError = false;
  String _errorText = '';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double horizontalPadding = screenWidth * 0.05;
    double verticalPadding = screenHeight * 0.02;

    return Stack(
      children: [
        // Opacity(
        //   opacity: 0, // Set transparency (0.0 - 1.0)
        //   child: Container(
        //     decoration: const BoxDecoration(
        //       image: DecorationImage(
        //         image: AssetImage('assets/images/background.jpg'),
        //         fit: BoxFit.fill,
        //       ),
        //     ),
        //   ),
        // ),
        Scaffold(
            // appBar: AppBar(
            //   title: Container(
            //     color: Colors.amberAccent,
            //     child: const Padding(
            //       padding: EdgeInsets.all(30),
            //       child: Text("Connectez vous"),
            //     ),
            //   ),
            // ),
            body: Padding(
          padding: const EdgeInsets.all(2),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //const SizedBox(height: 16.0),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _loginController,
                          decoration: const InputDecoration(
                            labelText: 'Numéro de Téléphone',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _isSending ? null : _login,
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
                                  : const Text('Se connecter',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                            ),
                            TextButton(
                              onPressed: _moveToSubscribe,
                              child: const Text('Je cree mon compte'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ))
      ],
    );
  }
}
