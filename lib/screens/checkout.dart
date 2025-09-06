import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;

// Added Amplify imports
import 'package:amplify_flutter/amplify_flutter.dart';

import '../models/tour_model.dart';
import 'Bottom_Nav_Bar.dart';

class CheckoutScreen extends StatefulWidget {
  final TourModel tour;
  final Map<String, dynamic> selectedPlan;

  const CheckoutScreen({
    super.key,
    required this.tour,
    required this.selectedPlan,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'Credit/Debit Card';
  final List<String> _paymentMethods = [
    'Credit/Debit Card',
    'Pay at Hotel',
  ];
  final _cardFormController = stripe.CardFormEditController();
  final _promoCodeController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String? _appliedPromoCodeName;
  double _discount = 0.0;

  @override
  void dispose() {
    _promoCodeController.dispose();
    _cardFormController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _applyPromoCode() async {
    final code = _promoCodeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a promo code.')));
      return;
    }

    final subtotal = double.parse(widget.selectedPlan['price']?.toString() ?? '0');

    final query = '''
      query ListPromoCodes {
        listPromoCodes(filter: { code: { eq: "$code" } }) {
          items {
            id
            code
            discountType
            discountValue
            isActive
            expiresAt
            usageCount
            maxGlobalUsage
          }
        }
      }
    ''';

    try {
      final response = await Amplify.API
          .query(request: GraphQLRequest<String>(document: query))
          .response;

      if (response.data == null) {
        safePrint('API response data is null for promo code.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to retrieve promo code data.')),
        );
        return;
      }

      final data = jsonDecode(response.data!);
      final items = (data['listPromoCodes']?['items'] as List?) ?? [];

      if (items.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Invalid Promo Code')));
        return;
      }

      final promo = items.first as Map<String, dynamic>;

      final now = DateTime.now().toUtc();
      final expiryString = promo['expiresAt'] as String?;
      final isActive = promo['isActive'] == true;
      final usageCount = (promo['usageCount'] as int?) ?? 0;
      final maxGlobal = (promo['maxGlobalUsage'] as int?) ?? 999;

      if (expiryString == null) {
        safePrint('Promo code expiry date is null.');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Promo code data incomplete.')));
        return;
      }
      final expiry = DateTime.parse(expiryString);

      if (!isActive) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Promo Code is inactive')));
        return;
      }

      if (now.isAfter(expiry)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Promo Code has expired')));
        return;
      }

      if (usageCount >= maxGlobal) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Promo Code limit reached',
                    style: TextStyle(color: Colors.white))));
        return;
      }

      double discount = 0;
      final type = promo['discountType'] as String?;
      final value = (promo['discountValue'] as num?)?.toDouble() ?? 0.0;

      if (type == 'percent') {
        discount = subtotal * (value / 100);
      } else if (type == 'amount') {
        discount = value;
      }

      setState(() {
        _appliedPromoCodeName = promo['code'] as String?;
        _discount = discount;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.green,
            content: Text('Promo Code "$code" Applied!')),
      );
    } catch (e) {
      safePrint('Promo apply error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Something went wrong.')));
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(
      String amount, String currency) async {
    try {
      final response = await http.post(
        Uri.parse(
            'YOUR_SERVER_URL/create-payment-intent'), // REMINDER: Replace with your actual backend endpoint for Stripe integration
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount, 'currency': currency}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to create payment intent: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating payment intent: $e');
    }
  }

  // >>>>>>>>>>>>>> START OF FIX <<<<<<<<<<<<<<<
  Future<void> _storeBookingData({
    required String userName,
    required String email,
    required String phoneNumber,
    required TourModel tour,
    required Map<String, dynamic> selectedPlan,
    required double subtotal,
    required double discount,
    required double serviceFee,
    required double totalAmount,
    required String paymentMethod,
    String? paymentIntentId,
  }) async {
    try {
      final currentUser = await Amplify.Auth.getCurrentUser();
      if (currentUser == null) {
        safePrint('No current user found. Cannot store booking data.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to complete your booking.')),
        );
        return;
      }
      final userId = currentUser.userId;

      // FIX: Get the authenticated user's email using fetchUserAttributes
      // This is the most reliable way to get the email attribute associated
      // with the currently signed-in user, as required by your Booking schema.
      String authUserEmail = email; // Fallback to the entered email
      try {
        final attributes = await Amplify.Auth.fetchUserAttributes();
        for (var attribute in attributes) {
          if (attribute.userAttributeKey == AuthUserAttributeKey.email) {
            authUserEmail = attribute.value;
            break;
          }
        }
      } catch (e) {
        safePrint('Error fetching user attributes for booking: $e');
        // Continue with the 'email' from the form if fetching fails
      }

      // Determine paymentStatus based on logic
      String paymentStatus;
      if (paymentMethod == 'Pay at Hotel') {
        paymentStatus = 'PENDING'; // Status for "Pay at Hotel"
      } else if (paymentMethod == 'Credit/Debit Card' && paymentIntentId != null) {
        paymentStatus = 'PAID'; // Assuming successful Stripe payment
      } else {
        paymentStatus = 'FAILED'; // Default for other cases or if paymentIntentId is null
      }

      final bookingInput = {
        'userId': userId,
        'userEmail': authUserEmail, // POPULATED WITH AUTHENTICATED USER'S EMAIL
        'userName': userName,
        'email': email,
        'phoneNumber': phoneNumber,
        'tourId': tour.id,
        'tourTitle': tour.title,
        'tourLocation': tour.location,
        'tourImageUrl': tour.imageUrl,
        'planName': selectedPlan['name'] ?? 'N/A',
        'planPrice': selectedPlan['price']?.toString() ?? '0', // Stored as String as per schema
        'subtotal': subtotal,
        'discount': discount,
        'serviceFee': serviceFee,
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod,
        'paymentIntentId': paymentIntentId, // Nullable as per schema
        'paymentStatus': paymentStatus,
        'status': paymentMethod == 'Pay at Hotel' ? 'PENDING' : 'CONFIRMED', // Matches enum BookingStatus
        'bookingDate': TemporalDateTime.now().format(),
      };

      safePrint('Sending Booking Input: $bookingInput'); // IMPORTANT for debugging

      String graphQLDocument = '''
        mutation CreateBooking(\$input: CreateBookingInput!) {
          createBooking(input: \$input) {
            id
            userName
            email
            tourTitle
            totalAmount
            status
            bookingDate
            userId
            userEmail # Ensure this is also returned if you need it immediately
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: graphQLDocument,
        variables: {'input': bookingInput},
      );

      final response = await Amplify.API.mutate(request: request).response;

      // Crucial null check here
      if (response.data == null) {
        safePrint('GraphQL response data is null for booking creation.');
        if (response.errors.isNotEmpty) {
          safePrint('GraphQL Errors: ${response.errors.map((e) => e.message).join(", ")}');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get a response for booking. Check logs for details.')),
        );
        return;
      }

      final data = json.decode(response.data!);
      final createBookingResult = data['createBooking'];

      if (response.errors.isEmpty && createBookingResult != null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Booking Successful!')),
        );

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNavigation()),
          );
        }

        // Update promo code usage if a code was used
        if (_appliedPromoCodeName != null) {
          try {
            final fetchQuery = '''
              query ListPromoCodes {
                listPromoCodes(filter: { code: { eq: "${_appliedPromoCodeName!}" } }) {
                  items {
                    id
                    usageCount
                  }
                }
              }
            ''';

            final fetchResponse = await Amplify.API.query(
              request: GraphQLRequest<String>(document: fetchQuery),
            ).response;

            if (fetchResponse.data == null) {
              safePrint('Fetch promo code response data is null.');
              return;
            }

            final promoItems = (jsonDecode(fetchResponse.data!)['listPromoCodes']?['items'] as List?) ?? [];
            if (promoItems.isNotEmpty) {
              final promo = promoItems.first as Map<String, dynamic>;
              final String? promoId = promo['id'] as String?;
              final int usageCount = (promo['usageCount'] as int?) ?? 0;

              if (promoId == null) {
                safePrint('Promo ID is null, cannot update usage count.');
                return;
              }

              final updateMutation = '''
                  mutation UpdatePromoCode {
                    updatePromoCode(input: {
                      id: "$promoId",
                      usageCount: ${usageCount + 1}
                    }) {
                      id
                    }
                  }
                ''';

              await Amplify.API.mutate(
                request: GraphQLRequest(document: updateMutation),
              ).response;
            }
          } catch (e) {
            safePrint('Failed to update promo usage: $e');
          }
        }
      } else {
        safePrint('GraphQL errors: ${response.errors.map((e) => e.message).join(", ")}');
        throw Exception('Failed to store booking data: ${response.errors.map((e) => e.message).join(", ")}');
      }
    } on ApiException catch (e) {
      safePrint('Amplify API Error: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error storing booking data: ${e.message}')),
      );
    } catch (e) {
      safePrint('General error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }
  // >>>>>>>>>>>>>> END OF FIX <<<<<<<<<<<<<<<

  Future<void> _handlePayment(double total) async {
    final String userName = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String phoneNumber = _phoneController.text.trim();

    if (userName.isEmpty || email.isEmpty || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all contact details.')),
      );
      return;
    }

    final double subtotal =
    double.parse(widget.selectedPlan['price']?.toString() ?? '0');
    final double discountedSubtotal = subtotal - _discount;
    const double serviceFeeRate = 0.10;
    final double serviceFee = discountedSubtotal * serviceFeeRate;
    final double calculatedTotal = discountedSubtotal + serviceFee;

    if (_selectedPaymentMethod == 'Pay at Hotel') {
      await _storeBookingData(
        userName: userName,
        email: email,
        phoneNumber: phoneNumber,
        tour: widget.tour,
        selectedPlan: widget.selectedPlan,
        subtotal: subtotal,
        discount: _discount,
        serviceFee: serviceFee,
        totalAmount: calculatedTotal,
        paymentMethod: _selectedPaymentMethod,
      );
      return;
    }

    if (_selectedPaymentMethod == 'Credit/Debit Card') {
      if (!_cardFormController.details.complete) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all card details.')),
        );
        return;
      }

      try {
        final paymentIntentData =
        await _createPaymentIntent((total * 100).toStringAsFixed(0), 'sgd');
        final clientSecret = paymentIntentData['clientSecret'] as String?;
        final paymentIntentId = paymentIntentData['id'] as String?;

        if (clientSecret == null || paymentIntentId == null) {
          throw Exception('Payment intent data is incomplete. Missing clientSecret or ID.');
        }

        await stripe.Stripe.instance.confirmPayment(
          paymentIntentClientSecret: clientSecret,
          data: const stripe.PaymentMethodParams.card(
            paymentMethodData: stripe.PaymentMethodData(),
          ),
        );

        await _storeBookingData(
          userName: userName,
          email: email,
          phoneNumber: phoneNumber,
          tour: widget.tour,
          selectedPlan: widget.selectedPlan,
          subtotal: subtotal,
          discount: _discount,
          serviceFee: serviceFee,
          totalAmount: calculatedTotal,
          paymentMethod: _selectedPaymentMethod,
          paymentIntentId: paymentIntentId,
        );
      } catch (e) {
        String errorMessage = 'Payment failed. Please try again.';
        if (e.toString().contains('canceled')) {
          errorMessage = 'Payment was cancelled.';
        } else if (e.toString().contains('declined')) {
          errorMessage = 'Card was declined.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $errorMessage')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment method "$_selectedPaymentMethod" is not yet fully supported.')),
      );
    }
  }

  Widget _buildPriceRow({
    required String title,
    required String amount,
    bool isTotal = false,
    bool isDiscount = false,
    required Duration delay,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Lora',
            fontSize: 15,
            color: isTotal ? Colors.indigo : Colors.black87,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.teal : (isDiscount ? Colors.red : Colors.black87),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: delay);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    required Duration delay,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            fontFamily: 'Lora', fontSize: 14, color: Colors.grey),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigo, width: 2)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!)),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: delay);
  }

  @override
  Widget build(BuildContext context) {
    final double subtotal =
    double.parse(widget.selectedPlan['price']?.toString() ?? '0');
    final double discountedSubtotal = subtotal - _discount;
    const double serviceFeeRate = 0.10;
    final double serviceFee = discountedSubtotal * serviceFeeRate;
    final double total = discountedSubtotal + serviceFee;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.indigo),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'CHECKOUT',
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 1.2,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white.withOpacity(0.9),
              elevation: 0,
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: widget.tour.imageUrl,
                                height: 100,
                                width: 130,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CupertinoActivityIndicator(
                                        radius: 20.0,
                                        color: CupertinoColors.activeBlue),
                                  ),
                                ).animate().shimmer(duration: 1000.ms),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error,
                                    color: Colors.redAccent),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.tour.title,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 18, color: Colors.teal),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          maxLines: 2,
                                          widget.tour.location,
                                          style: const TextStyle(
                                              fontFamily: 'Lora',
                                              fontSize: 14,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 18, color: Colors.teal),
                                      const SizedBox(width: 6),
                                      Text(
                                        widget.selectedPlan['date'] ??
                                            'No Date Selected',
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .slideY(begin: 0.3, end: 0.0),

                    const SizedBox(height: 24),

                    const Text(
                      'PROMO CODE',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo),
                    ).animate().fadeIn(duration: 800.ms, delay: 100.ms),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _promoCodeController,
                            decoration: InputDecoration(
                              labelText: 'Enter Promo Code',
                              labelStyle: const TextStyle(
                                  fontFamily: 'Lora',
                                  fontSize: 14,
                                  color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Colors.indigo, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _applyPromoCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                          child: const Text('Apply',
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ).animate().fadeIn(duration: 800.ms, delay: 200.ms),

                    const SizedBox(height: 24),

                    const Text(
                      'PRICE DETAILS',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo),
                    ).animate().fadeIn(duration: 800.ms, delay: 300.ms),
                    const SizedBox(height: 12),
                    _buildPriceRow(
                      title:
                      'Subtotal for ${widget.tour.passengers?.toString() ?? 'N/A'} Passengers',
                      amount: 'SGD ${subtotal.toStringAsFixed(0)}',
                      delay: 400.ms,
                    ),
                    if (_discount > 0) ...[
                      const SizedBox(height: 10),
                      _buildPriceRow(
                        title: 'Discount (${_appliedPromoCodeName ?? 'Applied'})',
                        amount: '- SGD ${_discount.toStringAsFixed(0)}',
                        isDiscount: true,
                        delay: 500.ms,
                      ),
                    ],
                    const SizedBox(height: 10),
                    _buildPriceRow(
                      title:
                      'Service Fee & Tax (${(serviceFeeRate * 100).toStringAsFixed(0)}%)',
                      amount: 'SGD ${serviceFee.toStringAsFixed(0)}',
                      delay: 600.ms,
                    ),
                    const SizedBox(height: 10),
                    _buildPriceRow(
                      title: 'Total Amount',
                      amount: 'SGD ${total.toStringAsFixed(0)}',
                      isTotal: true,
                      delay: 700.ms,
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Payment Method',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo),
                    ).animate().fadeIn(duration: 800.ms, delay: 800.ms),
                    const SizedBox(height: 12),
                    ..._paymentMethods.asMap().entries.map((entry) {
                      final index = entry.key;
                      final method = entry.value;
                      return Card(
                        elevation: 2,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: RadioListTile<String>(
                          value: method,
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) =>
                              setState(() => _selectedPaymentMethod = value!),
                          title: Text(
                            method,
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          secondary: Icon(
                            method == 'Credit/Debit Card'
                                ? Icons.credit_card
                                : Icons.hotel,
                            color: Colors.indigo,
                          ),
                          activeColor: Colors.indigo,
                        ),
                      )
                          .animate()
                          .fadeIn(
                          duration: 800.ms, delay: (900 + index * 100).ms)
                          .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1.0, 1.0),
                      );
                    }),

                    const SizedBox(height: 24),

                    if (_selectedPaymentMethod == 'Credit/Debit Card')
                      stripe.CardFormField(
                        controller: _cardFormController,
                        style: stripe.CardFormStyle(
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          placeholderColor: Colors.grey,
                          fontSize: 16,
                          borderRadius: 12,
                          borderColor: Colors.grey[300]!,
                        ),
                      ).animate().fadeIn(duration: 800.ms, delay: 1200.ms),

                    const SizedBox(height: 24),

                    const Text(
                      'Contact Information',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo),
                    ).animate().fadeIn(duration: 800.ms, delay: 1300.ms),
                    const SizedBox(height: 12),
                    _buildTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        keyboardType: TextInputType.text,
                        delay: 1350.ms),
                    const SizedBox(height: 12),
                    _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        delay: 1400.ms),
                    const SizedBox(height: 12),
                    _buildTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        delay: 1500.ms),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Amount',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo)),
                  if (_discount > 0)
                    Text(
                      'SGD ${(subtotal + serviceFee).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    'SGD ${total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _handlePayment(total),
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Colors.indigo, Colors.teal],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14),
                  child: const Text(
                    'Confirm Booking',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}