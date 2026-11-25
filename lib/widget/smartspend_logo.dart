import 'package:flutter/material.dart';

class SmartSpendLogo extends StatelessWidget {
  final double size;

  const SmartSpendLogo({
    super.key,
    this.size = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/smartspend_logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
