import 'package:flutter/material.dart';

class DropdownSelector extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final ValueChanged<bool>? onDropdownStateChanged;

  const DropdownSelector({
    super.key,
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.onDropdownStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.yellow[700],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          hint: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          dropdownColor: Colors.yellow[700],
          iconEnabledColor: Colors.black,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),

          // Set the items in the dropdown menu
          items: items
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),

          // Set the selected value to null if it is not in the list of items
          onChanged: (value) {
            onChanged(value); // update selected value
            if (onDropdownStateChanged != null) {
              onDropdownStateChanged!(false);
            }
          },
          // Show the dropdown menu when the user taps on the button
          onTap: () {
            if (onDropdownStateChanged != null) {
              onDropdownStateChanged!(true);
            }
          },
        ),
      ),
    );
  }
}
