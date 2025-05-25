// ====================================================
// Location Search Bar
// ----------------------------------------------------
// - Text input for searching locations
// - Calls onChanged when user types
// - Styled with dark theme and search icon
// ====================================================

import 'package:flutter/material.dart';

class LocationSearchBar extends StatelessWidget {
  final String? query;
  final ValueChanged<String> onChanged;

  const LocationSearchBar({
    super.key,
    required this.query,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search location...',
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}
