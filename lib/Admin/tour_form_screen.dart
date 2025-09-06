import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../api/tour_api.dart';

class TourFormScreen extends StatefulWidget {
  const TourFormScreen({super.key});

  @override
  State<TourFormScreen> createState() => _TourFormScreenState();
}

class _TourFormScreenState extends State<TourFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _passengerController = TextEditingController();
  final _tagsController = TextEditingController();

  final List<Map<String, dynamic>> _plans = [];
  final List<Map<String, dynamic>> _days = [];
  final List<Map<String, dynamic>> _additionalInfo = [];
  final List<String> _tags = [];

  String? _selectedCategory;
  String? _selectedSeason;
  bool _isLoading = false;

  final List<String> _categories = ['Adventure', 'Cultural', 'Nature', 'Historical', 'Luxury'];
  final List<String> _seasons = ['Winter', 'Spring', 'Summer', 'Autumn'];

  void _addTag() {
    final tag = _tagsController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagsController.clear();
      });
    }
  }

  void _addPlan() => setState(() => _plans.add({'name': '', 'price': ''}));
  void _removePlan(int index) => setState(() => _plans.removeAt(index));

  void _addDay() => setState(() => _days.add({'title': '', 'subtitle': '', 'imageUrl': ''}));
  void _removeDay(int index) => setState(() => _days.removeAt(index));

  void _addAdditionalInfo() => setState(() => _additionalInfo.add({'title': '', 'subtitle': ''}));
  void _removeAdditionalInfo(int index) => setState(() => _additionalInfo.removeAt(index));

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_plans.isEmpty || _days.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one plan and one day')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Submission'),
        content: const Text('Are you sure you want to submit this tour?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Submit')),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      final tourData = {
        'title': _titleController.text.trim(),
        'location': _locationController.text.trim(),
        'description': _descriptionController.text.trim(),
        'imageUrl': _imageUrlController.text.trim(),
        'passengers': _passengerController.text.trim(),
        'season': _selectedSeason,
        'rating': 0.0,
        'category': _selectedCategory,
        'tags': _tags,
        'plans': _plans,
        'days': _days,
        'additionalInfo': _additionalInfo,
        'createdBy': 'anonymous',
        'createdAt': TemporalDateTime.now().format(),
      };

      await createTour(tourData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tour added successfully!')),
      );

      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create tour: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _locationController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    _passengerController.clear();
    _tagsController.clear();
    _tags.clear();
    _plans.clear();
    _days.clear();
    _additionalInfo.clear();
    _selectedCategory = null;
    _selectedSeason = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Tour')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextFormField(controller: _locationController, decoration: const InputDecoration(labelText: 'Location')),
              TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description')),
              TextFormField(controller: _imageUrlController, decoration: const InputDecoration(labelText: 'Image URL')),
              TextFormField(controller: _passengerController, decoration: const InputDecoration(labelText: 'Passengers')),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Season'),
                items: _seasons.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                value: _selectedSeason,
                onChanged: (val) => setState(() => _selectedSeason = val),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                value: _selectedCategory,
                onChanged: (val) => setState(() => _selectedCategory = val),
              ),

              Row(children: [
                Expanded(child: TextFormField(controller: _tagsController, decoration: const InputDecoration(labelText: 'Add Tag'))),
                IconButton(icon: const Icon(Icons.add), onPressed: _addTag),
              ]),
              Wrap(spacing: 8, children: _tags.map((tag) => Chip(label: Text(tag), onDeleted: () => setState(() => _tags.remove(tag)))).toList()),

              const SizedBox(height: 20),
              const Text('Add Plans'),
              ..._plans.asMap().entries.map((entry) {
                int index = entry.key;
                return Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Plan Name'),
                      initialValue: _plans[index]['name'],
                      onChanged: (val) => _plans[index]['name'] = val,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      initialValue: _plans[index]['price'],
                      onChanged: (val) => _plans[index]['price'] = val,
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Remove Plan'),
                      onPressed: () => _removePlan(index),
                    ),
                    const Divider(),
                  ],
                );
              }),
              ElevatedButton(
                onPressed: _addPlan,
                child: const Text('Add Plan'),
              ),

              const SizedBox(height: 20),
              const Text('Add Days (Itinerary)'),
              ..._days.asMap().entries.map((entry) {
                int index = entry.key;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Day ${index + 1} Title'),
                      initialValue: _days[index]['title'],
                      onChanged: (val) => _days[index]['title'] = val,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Subtitle'),
                      initialValue: _days[index]['subtitle'],
                      onChanged: (val) => _days[index]['subtitle'] = val,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      initialValue: _days[index]['imageUrl'],
                      onChanged: (val) => _days[index]['imageUrl'] = val,
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Remove Day'),
                      onPressed: () => _removeDay(index),
                    ),
                    const Divider(),
                  ],
                );
              }),
              ElevatedButton(
                onPressed: _addDay,
                child: const Text('Add Day'),
              ),

              const SizedBox(height: 20),
              const Text('Add Additional Info'),
              ..._additionalInfo.asMap().entries.map((entry) {
                int index = entry.key;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Title'),
                      initialValue: _additionalInfo[index]['title'],
                      onChanged: (val) => _additionalInfo[index]['title'] = val,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Subtitle'),
                      initialValue: _additionalInfo[index]['subtitle'],
                      onChanged: (val) => _additionalInfo[index]['subtitle'] = val,
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Remove Info'),
                      onPressed: () => _removeAdditionalInfo(index),
                    ),
                    const Divider(),
                  ],
                );
              }),
              ElevatedButton(
                onPressed: _addAdditionalInfo,
                child: const Text('Add Info'),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading ? const CircularProgressIndicator() : const Text('Submit Tour'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
