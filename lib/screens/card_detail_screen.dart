import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animations/screens/widgets/credit_card.dart';

class CardDetailScreen extends StatelessWidget {
  const CardDetailScreen({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Hero(
            tag: "$index",
            child: CreditCard(
              index: index,
              isExpanded: false,
            ),
          ),
          ...[
            for (var i in [1, 1, 1, 1, 1, 1])
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  tileColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: const Icon(
                      Icons.shopping_bag,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    "Uniqlo",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    "Gangnam Branch",
                    style: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                  ),
                  trailing: Text(
                    "\$452,89$i",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ]
              .animate(interval: 500.ms)
              .fadeIn(begin: 0)
              .flipV(begin: -1.0, end: 0, curve: Curves.bounceOut),
        ]),
      ),
    );
  }
}
