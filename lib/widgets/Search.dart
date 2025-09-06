import 'package:flutter/material.dart';

class FilterSearchBar extends StatelessWidget {
  const FilterSearchBar({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Search tours...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}