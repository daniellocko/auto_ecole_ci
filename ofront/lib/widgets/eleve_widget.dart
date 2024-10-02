import 'package:epik/models/eleve.dart';
import 'package:epik/screens/moyen_paiement_screen.dart';
import 'package:epik/screens/quipux_screen.dart';
import 'package:epik/utils/formatter.dart';
import 'package:flutter/material.dart';

class EleveWidget extends StatelessWidget {
  const EleveWidget({super.key, required this.eleve});
  final Student eleve;

  @override
  Widget build(BuildContext context) {
    void _goPay({required Student e}) {
      showDialog(
          context: context,
          barrierColor: Colors.black
              .withOpacity(0.5), // Assure que le fond est partiellement visible

          builder: (BuildContext context) {
            return Dialog(
                backgroundColor: Colors.white.withOpacity(
                    0.8), // Rendre le fond du pop-up légèrement transparent

                child: MoyenPaiementScreen(
                  e: e,
                ));
          });
    }

    void _goQuipux({required Student e}) {
      showDialog(
          context: context,
          barrierColor: Colors.black
              .withOpacity(0), // Assure que le fond est partiellement visible

          builder: (BuildContext context) {
            return Dialog(
                backgroundColor: Colors.white.withOpacity(
                    0), // Rendre le fond du pop-up légèrement transparent

                child: QuipuxScreen(
                  e: e,
                ));
          });
    }

    double progress = eleve.amountPaid / 70000;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 119, 112, 112),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Nom & Prenoms',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    color: const Color.fromARGB(255, 247, 243, 243),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('${eleve.lastName}  ${eleve.firstName}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    width: 200,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('N° Telephone',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    color: const Color.fromARGB(255, 247, 243, 243),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(formatPhoneNumber(eleve.telephone!)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  LinearProgressIndicator(
                      minHeight: 20,
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 213, 137, 14),
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    formatAmount(eleve.amountPaid) + ' F CFA',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: eleve.amountPaid == 70000
                        ? null
                        : () {
                            _goPay(e: eleve);
                          },
                    child: Text(
                      'Payer',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Bords rectangulaires
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: eleve.amountPaid == 70000
                        ? () {
                            _goQuipux(e: eleve);
                          }
                        : null,
                    child: Text(
                      'CGI-QUIPUX',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 82, 3, 124),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Bords rectangulaires
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
