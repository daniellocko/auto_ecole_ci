import 'package:epik/models/topup_method.dart';
import 'package:flutter/material.dart';

class MethodItem extends StatelessWidget {
  const MethodItem({super.key, required this.method});
  final TopUpMethod method;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(method.icon),
                  ),
                  title: Text(
                    method.label,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  subtitle: Text(
                    method.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              TextButton(
                child: Icon(Icons.forward),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );

    // return CustomCard(
    //     imagePath: "assets/images/male.png", label: "Initier un retrait");
  }
}
