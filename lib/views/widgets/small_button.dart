import 'package:flutter/material.dart';
import 'package:resty/themes/colors.dart';

class SmallButton extends StatelessWidget {
  const SmallButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.isSelector = false,
  });

  final String text;
  final IconData icon;
  final GestureTapCallback onTap;
  final bool isSelector;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: primaryColor[400],
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: primaryColor[400],
                      ),
                ),
                const SizedBox(width: 4),
                isSelector
                    ? Icon(
                        Icons.keyboard_arrow_down,
                        color: primaryColor[400],
                        size: 16,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
