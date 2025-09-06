import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:convert';

class AdminPromoManager extends StatefulWidget {
  const AdminPromoManager({super.key});

  @override
  State<AdminPromoManager> createState() => _AdminPromoManagerState();
}

class _AdminPromoManagerState extends State<AdminPromoManager> with SingleTickerProviderStateMixin {
  final _codeController = TextEditingController();
  final _valueController = TextEditingController();
  final _perUserController = TextEditingController();
  final _globalLimitController = TextEditingController();

  DateTime? _expiryDate;
  String _discountType = 'percent';
  List<dynamic> _promoCodes = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
    _fetchPromoCodes();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _codeController.dispose();
    _valueController.dispose();
    _perUserController.dispose();
    _globalLimitController.dispose();
    super.dispose();
  }

  Future<void> _addPromoCode() async {
    final code = _codeController.text.trim().toUpperCase();
    final value = int.tryParse(_valueController.text.trim()) ?? 0;
    final maxPerUser = int.tryParse(_perUserController.text.trim()) ?? 1;
    final globalMax = int.tryParse(_globalLimitController.text.trim()) ?? 999;

    if (code.isEmpty || value <= 0 || _expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final now = DateTime.now().toUtc();

    final mutation = '''
      mutation CreatePromo {
        createPromoCode(input: {
          code: "$code",
          discountType: "$_discountType",
          discountValue: $value,
          isActive: true,
          createdAt: "${now.toIso8601String()}",
          expiresAt: "${_expiryDate!.toUtc().toIso8601String()}",
          maxUsagePerUser: $maxPerUser,
          maxGlobalUsage: $globalMax,
          usageCount: 0,
          usedBy: []
        }) {
          id
        }
      }
    ''';

    await Amplify.API.mutate(request: GraphQLRequest(document: mutation)).response;
    _clearForm();
    _fetchPromoCodes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Promo code added successfully')),
    );
  }

  Future<void> _fetchPromoCodes() async {
    const query = '''
      query ListPromoCodes {
        listPromoCodes(limit: 1000) {
          items {
            id code discountType discountValue isActive createdAt expiresAt
            maxUsagePerUser maxGlobalUsage usageCount
          }
        }
      }
    ''';

    final response = await Amplify.API.query(request: GraphQLRequest(document: query)).response;
    final data = jsonDecode(response.data!)['listPromoCodes']['items'];
    setState(() {
      _promoCodes = data;
      _animationController.reset();
      _animationController.forward();
    });
  }

  Future<void> _togglePromo(String id, bool isActive) async {
    final mutation = '''
      mutation UpdatePromo {
        updatePromoCode(input: {
          id: "$id",
          isActive: ${!isActive}
        }) {
          id
        }
      }
    ''';
    await Amplify.API.mutate(request: GraphQLRequest(document: mutation)).response;
    _fetchPromoCodes();
  }

  Future<void> _deletePromo(String id) async {
    final mutation = '''
      mutation DeletePromo {
        deletePromoCode(input: { id: "$id" }) {
          id
        }
      }
    ''';
    await Amplify.API.mutate(request: GraphQLRequest(document: mutation)).response;
    _fetchPromoCodes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Promo code deleted')),
    );
  }

  void _clearForm() {
    _codeController.clear();
    _valueController.clear();
    _perUserController.clear();
    _globalLimitController.clear();
    setState(() => _expiryDate = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Promo Code Manager',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [Colors.teal.shade50, Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    ),
        ),
    child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Form with animated container
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: 'Promo Code',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _discountType,
                      decoration: InputDecoration(
                        labelText: 'Discount Type',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'percent', child: Text('Percent (%)')),
                        DropdownMenuItem(value: 'amount', child: Text('Fixed Amount')),
                      ],
                      onChanged: (val) => setState(() => _discountType = val!),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _valueController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: _discountType == 'percent' ? 'Discount %' : 'Amount',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _perUserController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Max Usage Per User',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _globalLimitController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Global Usage Limit',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _expiryDate == null
                                ? 'No Expiry Date'
                                : 'Expires: ${DateFormat.yMMMd().format(_expiryDate!)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().add(const Duration(days: 30)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(primary: Colors.teal),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) setState(() => _expiryDate = picked);
                          },
                          child: const Text('Pick Date', style: TextStyle(color: Colors.teal)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _addPromoCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 2,
                      ),
                      child: const Text('Add Promo Code', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 32, color: Colors.teal),
              const Text(
                'Existing Promo Codes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 12),

              // Animated Promo Code List
              Expanded(
                child: _promoCodes.isEmpty
                    ? const Center(child: Text('No Promo Codes', style: TextStyle(fontSize: 16)))
                    : ListView.builder(
                  itemCount: _promoCodes.length,
                  itemBuilder: (context, index) {
                    final promo = _promoCodes[index];
                    final isActive = promo['isActive'] == true;
                    return AnimatedOpacity(
                      opacity: isActive ? 1.0 : 0.6,
                      duration: const Duration(milliseconds: 500),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            '${promo['code']} - ${promo['discountValue']} ${promo['discountType'] == 'percent' ? '%' : 'THB'}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            'Expires: ${DateFormat.yMMMd().format(DateTime.parse(promo['expiresAt']))}\n'
                                'Used: ${promo['usageCount']} / ${promo['maxGlobalUsage']}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: isActive,
                                  activeColor: Colors.teal,
                                  onChanged: (_) => _togglePromo(promo['id'], isActive),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deletePromo(promo['id']),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}