// ignore_for_file: prefer_const_constructors
import 'package:epik/components/custom_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:epik/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen(
      {Key? key,
      required this.title,
      required this.description,
      required this.success})
      : super(key: key);

  final String title;
  final String description;
  final bool success;

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);

  moveToHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Navigator.push(context, MaterialPageRoute(builder: (ctx) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    Color themeColor = widget.success
        ? Color.fromARGB(255, 62, 221, 163)
        : Color.fromARGB(255, 209, 8, 8);

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 170,
                padding: EdgeInsets.all(35),
                decoration: BoxDecoration(
                  color: themeColor,
                  shape: BoxShape.circle,
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: widget.success
                      ? FaIcon(FontAwesomeIcons.solidThumbsUp)
                      : FaIcon(FontAwesomeIcons.ban),
                )),
            SizedBox(height: screenHeight * 0.1),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: themeColor,
                    fontSize: 36,
                  ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              widget.description,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Colors.black87,
                    fontSize: 17,
                  ),
            ),
            SizedBox(height: screenHeight * 0.06),
            Flexible(
              child: CustomButton(
                onPress: moveToHome,
                label: 'Acceuil',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
