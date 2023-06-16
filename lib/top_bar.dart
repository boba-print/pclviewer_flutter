import 'package:flutter/material.dart';

const BobaLogo = "assets/boba_logo.png";

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Image.asset(
          BobaLogo,
          width: 48,
          height: 48,
        ),
      ),
    ]);
  }
}
