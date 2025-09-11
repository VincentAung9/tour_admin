import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../api/tour_api.dart';

class TourEditScreen extends StatefulWidget {
  final Map<String, dynamic> tourData;

  const TourEditScreen({super.key, required this.tourData});

  @override
  State<TourEditScreen> createState() => _TourEditScreenState();
}

class _TourEditScreenState extends State<TourEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _passengerController = TextEditingController();
  final _tagsController = TextEditingController();

  late List<Map<String, dynamic>> _plans;
  late List<Map<String, dynamic>> _days;
  late List<Map<String, dynamic>> _additionalInfo;
  late List<String> _tags;
  String? _selectedCountry;
  String? _selectedCategory;
  String? _selectedSeason;
  bool _isLoading = false;
  final List<String> _countries = [
    'Indonesia',
    'Mongolia',
    'China',
    'Bhutan',
    'Africa',
    'Laos',
    'Central Asia',
  ];

  final List<String> _categories = [
    'Adventure',
    'Cultural',
    'Nature',
    'Historical',
    'Luxury'
  ];
  final List<String> _seasons = ['Winter', 'Spring', 'Summer', 'Autumn'];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    _titleController.text = widget.tourData['title'] ?? '';
    _locationController.text = widget.tourData['location'] ?? '';
    _descriptionController.text = widget.tourData['description'] ?? '';
    _imageUrlController.text = widget.tourData['imageUrl'] ?? '';
    _passengerController.text = widget.tourData['passengers'] ?? '';

    final incomingCategory = widget.tourData['category'];
    _selectedCategory =
        _categories.contains(incomingCategory) ? incomingCategory : null;

    final incomingSeason = widget.tourData['season'];
    final country = widget.tourData["country"];
    debugPrint("🔥---COUNTRY SELECTED: ${widget.tourData["country"]}");
    _selectedSeason = _seasons.contains(incomingSeason) ? incomingSeason : null;
    _selectedCountry = _countries.contains(country) ? country : null;

    _tags = List<String>.from(widget.tourData['tags'] ?? []);
    _plans = List<Map<String, dynamic>>.from(widget.tourData['plans'] ?? []);
    _days = List<Map<String, dynamic>>.from(widget.tourData['days'] ?? []);
    _additionalInfo = List<Map<String, dynamic>>.from(
        widget.tourData['additionalInfo'] ?? []);
  }

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

  void _addDay() =>
      setState(() => _days.add({'title': '', 'subtitle': '', 'imageUrl': ''}));
  void _removeDay(int index) => setState(() => _days.removeAt(index));

  void _addAdditionalInfo() =>
      setState(() => _additionalInfo.add({'title': '', 'subtitle': ''}));
  void _removeAdditionalInfo(int index) =>
      setState(() => _additionalInfo.removeAt(index));

  Future<void> _updateTour() async {
    if (!_formKey.currentState!.validate()) return;
    if (_plans.isEmpty || _days.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please add at least one plan and one day')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Update'),
        content: const Text('Are you sure you want to update this tour?'),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Update',
                  style: TextStyle(
                    color: Colors.white,
                  ))),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      final tourData = {
        'id': widget.tourData['id'],
        'title': _titleController.text.trim(),
        'location': _locationController.text.trim(),
        'description': _descriptionController.text.trim(),
        'imageUrl': _imageUrlController.text.trim(),
        'passengers': _passengerController.text.trim(),
        'country': _selectedCountry,
        'season': _selectedSeason,
        'rating': widget.tourData['rating'] ?? 0.0,
        'category': _selectedCategory,
        'tags': _tags,
        'plans': _plans,
        'days': _days,
        'badge': widget.tourData["badge"] ?? "",
        'additionalInfo': _additionalInfo,
        'createdBy': widget.tourData['createdBy'] ?? 'anonymous',
        'createdAt': widget.tourData['createdAt'],
        'updatedAt': TemporalDateTime.now().format(),
      };
      debugPrint(
          "🔥 EditTourData: ${tourData.entries.where((td) => td.value == null).toList()}");
      await updateTour(tourData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tour updated successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update tour: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.teal,
      ),
    );
    const focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.teal,
      ),
    );

    Widget _buildTextField(
        {required TextEditingController controller,
        required String label,
        IconData? icon,
        bool multiline = false}) {
      return TextFormField(
        controller: controller,
        maxLines: multiline ? 3 : 1,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '🌴 Edit Tour',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1,
            color: Colors.teal,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image preview
              if (_imageUrlController.text.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: _imageUrlController.text,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, size: 50),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(begin: const Offset(0.95, 0.95)),

              const SizedBox(height: 20),

              _buildTextField(
                  controller: _titleController,
                  label: "Tour Title",
                  icon: Icons.title),
              _buildTextField(
                  controller: _locationController,
                  label: "Location",
                  icon: Icons.location_on),
              _buildTextField(
                  controller: _descriptionController,
                  label: "Description",
                  multiline: true,
                  icon: Icons.description),
              _buildTextField(
                  controller: _imageUrlController,
                  label: "Image URL",
                  icon: Icons.image),
              _buildTextField(
                  controller: _passengerController,
                  label: "Passengers",
                  icon: Icons.people),

              const SizedBox(height: 12),
              //Countries
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: _countries
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                value: _selectedCountry,
                onChanged: (val) => setState(() => _selectedCountry = val),
              ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.2, end: 0),

              const SizedBox(height: 12),
              // Dropdowns
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Season',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: _seasons
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                value: _selectedSeason,
                onChanged: (val) => setState(() => _selectedSeason = val),
              ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.2, end: 0),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                value: _selectedCategory,
                onChanged: (val) => setState(() => _selectedCategory = val),
              ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),

              const SizedBox(height: 16),

              // Tags
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                        controller: _tagsController,
                        label: 'Add Tag',
                        icon: Icons.tag),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle,
                        color: Colors.teal, size: 32),
                    onPressed: _addTag,
                  )
                ],
              ),
              Wrap(
                spacing: 8,
                children: _tags
                    .map((tag) => Chip(
                          label: Text(tag),
                          backgroundColor: Colors.teal.shade100,
                          onDeleted: () => setState(() => _tags.remove(tag)),
                        ))
                    .toList(),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.8, 0.8)),

              //Add Plan
              const SizedBox(height: 16),
              Container(
                width: size.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plans',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._plans.asMap().entries.map((entry) {
                      int index = entry.key;
                      return Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Plan Name',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                            initialValue: _plans[index]['name'],
                            onChanged: (val) => _plans[index]['name'] = val,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter a plan name'
                                : null,
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Price',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            initialValue: _plans[index]['price'],
                            onChanged: (val) => _plans[index]['price'] = val,
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter a price' : null,
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 36,
                            width: size.width,
                            child: ElevatedButton(
                              onPressed: () => {_removePlan(index)},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              child: TextButton.icon(
                                onPressed: null,
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                label: const Text(
                                  'Remove Plan',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    }),
                    SizedBox(
                      height: 36,
                      width: size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: _addPlan,
                        child: TextButton.icon(
                          onPressed: null,
                          icon:
                              const Icon(Icons.add_circle, color: Colors.white),
                          label: const Text(
                            'Add Plan',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Add Day
              const SizedBox(height: 20),
              Container(
                width: size.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Days (Itinerary)',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._days.asMap().entries.map((entry) {
                      int index = entry.key;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Day ${index + 1} Title',
                              border: border,
                              focusedBorder: focusedBorder,
                            ),
                            initialValue: _days[index]['title'],
                            onChanged: (val) => _days[index]['title'] = val,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter a day title'
                                : null,
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Subtitle',
                              border: border,
                              focusedBorder: focusedBorder,
                            ),
                            initialValue: _days[index]['subtitle'],
                            onChanged: (val) => _days[index]['subtitle'] = val,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter a subtitle'
                                : null,
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Image URL',
                              border: border,
                              focusedBorder: focusedBorder,
                            ),
                            initialValue: _days[index]['imageUrl'],
                            onChanged: (val) => _days[index]['imageUrl'] = val,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter an image URL'
                                : null,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 36,
                            width: size.width,
                            child: ElevatedButton(
                              onPressed: () => _removeDay(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              child: TextButton.icon(
                                onPressed: null,
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                label: const Text(
                                  'Remove Day',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    }),
                    SizedBox(
                      height: 36,
                      width: size.width,
                      child: ElevatedButton(
                        onPressed: _addDay,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: TextButton.icon(
                          onPressed: null,
                          icon:
                              const Icon(Icons.add_circle, color: Colors.white),
                          label: const Text(
                            'Add Day',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //
              const SizedBox(
                height: 20,
              ),
              //Add Info
              Container(
                width: size.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Additional Info',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._additionalInfo.asMap().entries.map((entry) {
                      int index = entry.key;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                            initialValue: _additionalInfo[index]['title'],
                            onChanged: (val) =>
                                _additionalInfo[index]['title'] = val,
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter a title' : null,
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Subtitle'),
                            initialValue: _additionalInfo[index]['subtitle'],
                            onChanged: (val) =>
                                _additionalInfo[index]['subtitle'] = val,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter a subtitle'
                                : null,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          SizedBox(
                            height: 36,
                            width: size.width,
                            child: ElevatedButton(
                              onPressed: _addAdditionalInfo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              child: TextButton.icon(
                                onPressed: () => _removeAdditionalInfo(index),
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                label: const Text(
                                  'Remove Info',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    }),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 36,
                      width: size.width,
                      child: ElevatedButton(
                        onPressed: _addAdditionalInfo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: TextButton.icon(
                          onPressed: null,
                          icon:
                              const Icon(Icons.add_circle, color: Colors.white),
                          label: const Text(
                            'Add Info',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                  ),
                  onPressed: _isLoading ? null : _updateTour,
                  icon: const Icon(Icons.flight_takeoff, color: Colors.white),
                  label: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Edit Tour',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(begin: const Offset(0.9, 0.9)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
