import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'widgets/credit_card.dart';

final cardColors = [
  Colors.purple,
  Colors.black,
  Colors.blue,
];

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isExpanded = false;

  void _onExpanded() {
    setState(() {
      _isExpanded = true;
    });
  }

  void _onShrink() {
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: _onExpanded,
          onVerticalDragEnd: (_) => _onShrink(),
          child: Column(
            children: [
              for (var index = 0; index < cardColors.length; index++)
                Hero(
                  tag: "$index",
                  child: CreditCard(
                    index: index,
                    isExpanded: _isExpanded,
                  )
                      .animate(
                        delay: 1.5.seconds,
                        target: _isExpanded ? 0 : 1,
                      )
                      .flipV(end: 0.1)
                      .slideY(end: -0.8 * index),
                ),
            ]
                .animate(interval: 500.ms)
                .fadeIn(begin: 0)
                .slideX(begin: -1, end: 0),
          ),
        ),
      ),
    );
  }
}
