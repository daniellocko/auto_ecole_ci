import 'package:epik/models/eleve.dart';
import 'package:epik/models/topup_methods.dart';
import 'package:epik/widgets/method_item.dart';
import 'package:flutter/material.dart';

class MoyenPaiementScreen extends StatefulWidget {
  final Student e;
  const MoyenPaiementScreen({super.key, required this.e});

  @override
  State<MoyenPaiementScreen> createState() {
    return _MoyenPaiementScreenState();
  }
}

class _MoyenPaiementScreenState extends State<MoyenPaiementScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define padding as a percentage of the screen width or height
    double horizontalPadding = screenWidth * 0.05; // 5% of screen width
    double verticalPadding = screenHeight * 0.02; // 2% of screen height

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Payer les frais de ${widget.e.firstName} ${widget.e.lastName} ',
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: verticalPadding, horizontal: horizontalPadding),
              child: ListView.builder(
                  itemCount: topup_methods.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                        onTap: () {},
                        child: MethodItem(method: topup_methods[index]));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
