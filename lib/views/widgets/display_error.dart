import 'package:flutter/material.dart';
import 'package:resty/themes/colors.dart';

class DisplayError extends StatelessWidget {
  const DisplayError({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final Widget text;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 100,
              color: primaryColor[300],
            ),
            const SizedBox(height: 24),
            text,
          ],
        ),
      ),
    );
  }
}
