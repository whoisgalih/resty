import 'package:flutter/material.dart';
import 'package:resty/themes/colors.dart';
import 'package:resty/views/widgets/small_button.dart';

class SelectButton extends StatelessWidget {
  final List<dynamic> options;
  final dynamic selectedOption;
  final Function(dynamic) onSelected;
  final IconData icon;

  const SelectButton({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SmallButton(
      icon: icon,
      text: selectedOption.toString(),
      isSelector: true,
      onTap: () {
        // show modal bottom sheet
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: selectedOption == options[index]
                      ? primaryColor[100]
                      : null,
                  title: Text(
                    "${options[index]}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: selectedOption == options[index]
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                  ),
                  onTap: () {
                    onSelected(options[index]);
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
