import 'package:flutter/material.dart';

import '../app_debouncer.dart';

class FilterSearchBar extends StatefulWidget {
  final void Function(String? value) onChangeSearch;
  const FilterSearchBar({super.key, required this.onChangeSearch});

  @override
  State<FilterSearchBar> createState() => _FilterSearchBarState();
}

class _FilterSearchBarState extends State<FilterSearchBar> {
  final _debouncer = Debouncer(delay: Duration(milliseconds: 500));
  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search tours...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (value) {
            _debouncer.run(() {
              widget.onChangeSearch(value);
            });
          },
        ),
      );
}
