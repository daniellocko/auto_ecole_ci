import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:epik/env.dart';
import 'package:epik/models/eleve.dart';
import 'package:epik/models/user.dart';
import 'package:epik/screens/login_screen.dart';
import 'package:epik/screens/prix_screen.dart';
import 'package:epik/screens/profil_screen.dart';
import 'package:epik/screens/registration_screen.dart';
import 'package:epik/screens/service_client_screen.dart';
import 'package:epik/screens/solde_screen.dart';
import 'package:epik/screens/subscription_screen.dart';
import 'package:epik/services/student_service.dart';
import 'package:epik/widgets/eleve_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:epik/widgets/menu_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  User? userConnected;
  Instructor? instructorConnected;
  Student? studentConnected;
  List<Student> eleves = [];
  final StudentService stdService = StudentService();
  String _searchEmail = '';

  Future<void> fetchActivePage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = prefs.getInt('page') == null ? 0 : prefs.getInt('page')!;
    });
  }

  @override
  void initState() {
    print('We are initializing your app...');
    retrieveUser();
    fetchActivePage();
    fetchStudents();
    super.initState();
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

  Future<void> retrieveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('User');
    String? instructorJson = prefs.getString('Instructor');
    String? studentJson = prefs.getString('Student');

    if (userJson != null) {
      Map<String, dynamic> userMap = json.decode(userJson);

      setState(() {
        userConnected = User.fromJson(userMap);
        if (!userConnected!.is_instructor && !userConnected!.is_student) {
          showAlert(
              title: 'Erreur !', description: "Une erreur s'est produite !");

          _disconnect();
        }
        if (!instructorJson!.startsWith("null")) {
          Map<String, dynamic> insMap = json.decode(instructorJson);
          instructorConnected = Instructor.fromJson(insMap);
        }
        if (!studentJson!.startsWith("null")) {
          Map<String, dynamic> studentMap = json.decode(studentJson);
          studentConnected = Student.fromJson(studentMap);
        }
      });
    } else {
      print('No user found in preferences.');
    }
  }

  final List<String> menu = [
    'Ajouter',
    'Liste des élèves',
    'Paramètre prix',
    'Solde',
    'Service client',
    'Profil'
  ];
  void _onMenuItemSelected(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = index;
      prefs.setInt('page', _selectedIndex);
    });
  }

  fetchStudents() async {
    print('Fetching students...');
    eleves = await stdService.getStudents("");

    print('${eleves.length} Students');
  }

  searchStudents(String value) async {
    print('Searching students...');
    eleves = await stdService.getStudents(value);

    print('${eleves.length} Students');
  }

  void _disconnect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Connected !!!!');

    Widget ajouter() {
      return RegistrationScreen();
    }

    Widget searchBar() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: const InputDecoration(
            labelText: 'Recherche',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _searchEmail = value;
              searchStudents(value);
            });
          },
        ),
      );
    }

    Widget listingEleve() {
      return Column(children: [
        searchBar(),
        eleves.isEmpty
            ? const Center(
                child: Text('Aucun elève enregistré'),
              )
            : Expanded(
                child: ListView.builder(
                    itemCount: eleves.length,
                    itemBuilder: (context, index) {
                      return EleveWidget(eleve: eleves[index]);
                    }),
              )
      ]);
    }

    final List<Widget> pages = [
      ajouter(),
      listingEleve(),
      PrixScreen(),
      SoldeScreen(),
      ServiceClientScreen(),
      instructorConnected != null
          ? ProfilScreen(
              actualInstructor: instructorConnected!,
              actualUser: userConnected!,
            )
          : const Text('...'),
    ];

    return instructorConnected == null
        ? const Text('----')
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  instructorConnected == null
                      ? "Chargement..."
                      : 'Bienvenue sur le portail de l\'auto ecole ${instructorConnected!.name} , '),
            ),
            body: instructorConnected == null
                ? const Center(
                    child: Text('Chargement...'),
                  )
                : Row(
                    children: [
                      Container(
                        width: 250.0, // Largeur du volet de gauche
                        color: Colors.grey[200],
                        child: Column(
                          children: [
                            instructorConnected!.logoUrl == null
                                ? const Center(child: Text(''))
                                : SizedBox(
                                    //width: 250,
                                    height: 150,
                                    child: Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: CachedNetworkImage(
                                        imageUrl: imageSrc +
                                            instructorConnected!.logoUrl!,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  '${instructorConnected?.name}'),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: _disconnect,
                              child: const Text("Se deconnecter"),
                            ),
                            Expanded(
                              child: MenuWidget(
                                menuItems: menu,
                                selectedIndex: _selectedIndex,
                                onMenuItemSelected: _onMenuItemSelected,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: pages[_selectedIndex],
                          ),
                        ),
                      ),
                    ],
                  ));
  }
}
