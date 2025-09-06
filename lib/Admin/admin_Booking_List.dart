import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:convert';

enum BookingStatus { PENDING, CONFIRMED, COMPLETED, CANCELED }

class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({super.key});

  @override
  State<AdminBookingScreen> createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen> {
  List<Map<String, dynamic>> bookings = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final Map<String, bool> _isUpdating = {};

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      String graphQLDocument = '''
        query ListBookings {
          listBookings {
            items {
              id
              bookingDate
              createdAt
              discount
              email
              paymentIntentId
              paymentMethod
              phoneNumber
              planName
              planPrice
              serviceFee
              status
              subtotal
              totalAmount
              tourId
              tourImageUrl
              tourLocation
              tourTitle
              updatedAt
              userId
              userName
            }
          }
        }
      ''';

      final request = GraphQLRequest<String>(document: graphQLDocument);
      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final decoded = jsonDecode(response.data!);
        final items = (decoded['listBookings']['items'] as List)
            .map<Map<String, dynamic>>((item) => {
          'id': item['id'],
          'bookingDate': item['bookingDate'],
          'createdAt': item['createdAt'],
          'discount': item['discount'],
          'email': item['email'],
          'paymentIntentId': item['paymentIntentId'],
          'paymentMethod': item['paymentMethod'],
          'phoneNumber': item['phoneNumber'],
          'planName': item['planName'],
          'planPrice': item['planPrice'],
          'serviceFee': item['serviceFee'],
          'status': item['status'] ?? 'PENDING',
          'subtotal': item['subtotal'],
          'totalAmount': item['totalAmount'],
          'tourId': item['tourId'],
          'tourImageUrl': item['tourImageUrl'],
          'tourLocation': item['tourLocation'],
          'tourTitle': item['tourTitle'],
          'updatedAt': item['updatedAt'],
          'userId': item['userId'],
          'userName': item['userName'],
        })
            .toList();

        setState(() {
          bookings = items;
          for (int i = 0; i < items.length; i++) {
            _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 500));
          }
        });
      } else if (response.errors.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading bookings: ${response.errors.first.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bookings: $e')),
      );
    }
  }

  Future<void> _updateBookingStatus(String bookingId, BookingStatus newStatus) async {
    setState(() {
      _isUpdating[bookingId] = true;
    });

    try {
      String graphQLDocument = '''
        mutation UpdateBookingStatus(\$id: ID!, \$status: BookingStatus!) {
          updateBooking(input: { id: \$id, status: \$status }) {
            id
            status
            updatedAt
          }
        }
      ''';

      final variables = {
        'id': bookingId,
        'status': newStatus.name,
      };

      final request = GraphQLRequest<String>(
        document: graphQLDocument,
        variables: variables,
        decodePath: 'updateBooking',
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        final decoded = jsonDecode(response.data!);
        final updatedBooking = decoded['updateBooking'];
        setState(() {
          final booking = bookings.firstWhere((b) => b['id'] == bookingId);
          booking['status'] = updatedBooking['status'] ?? newStatus.name;
          booking['updatedAt'] = updatedBooking['updatedAt'] ?? booking['updatedAt'];
          _isUpdating[bookingId] = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking status updated to ${newStatus.name}')),
        );
      } else if (response.errors.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.errors.first.message}')),
        );
        setState(() {
          _isUpdating[bookingId] = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
      setState(() {
        _isUpdating[bookingId] = false;
      });
    }
  }

  Widget _buildBookingCard(BuildContext context, int index, Animation<double> animation) {
    final booking = bookings[index];
    final bookingId = booking['id'] ?? '';
    final isUpdating = _isUpdating[bookingId] ?? false;

    BookingStatus currentStatus = BookingStatus.values.firstWhere(
          (e) => e.name == (booking['status'] ?? 'PENDING'),
      orElse: () => BookingStatus.PENDING,
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(animation),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${booking['id'] ?? 'N/A'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('User: ${booking['userName'] ?? 'Unknown'} (${booking['userId'] ?? 'N/A'})'),
                Text('Email: ${booking['email'] ?? 'No email'}'),
                Text('Phone: ${booking['phoneNumber'] ?? 'No phone'}'),
                const SizedBox(height: 6),
                Text('Plan: ${booking['planName'] ?? 'N/A'} - ${booking['planPrice'] ?? 'N/A'}'),
                Text('Discount: ${booking['discount'] ?? '0'}'),
                Text('Subtotal: ${booking['subtotal'] ?? '0'}'),
                Text('Service Fee: ${booking['serviceFee'] ?? '0'}'),
                Text('Total: ${booking['totalAmount'] ?? '0'}'),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    isUpdating
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : DropdownButton<BookingStatus>(
                      value: currentStatus,
                      items: BookingStatus.values.map((BookingStatus status) {
                        return DropdownMenuItem<BookingStatus>(
                          value: status,
                          child: Text(status.name),
                        );
                      }).toList(),
                      onChanged: (BookingStatus? newValue) {
                        if (newValue != null && newValue != currentStatus && bookingId.isNotEmpty) {
                          _updateBookingStatus(bookingId, newValue);
                        }
                      },
                    ),
                  ],
                ),
                Text('Payment Method: ${booking['paymentMethod'] ?? 'N/A'}'),
                Text('Payment Intent ID: ${booking['paymentIntentId'] ?? 'N/A'}'),
                const SizedBox(height: 6),
                Text('Tour: ${booking['tourTitle'] ?? 'N/A'} (${booking['tourLocation'] ?? 'N/A'})'),
                Text('Tour ID: ${booking['tourId'] ?? 'N/A'}'),
                if (booking['tourImageUrl'] != null && booking['tourImageUrl'].toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Image.network(
                      booking['tourImageUrl'],
                      height: 100,
                      errorBuilder: (context, error, stackTrace) => const Text('Failed to load image'),
                    ),
                  ),
                const Divider(),
                Text('Booked At: ${booking['createdAt'] ?? 'N/A'}'),
                Text('Updated At: ${booking['updatedAt'] ?? 'N/A'}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Booking View'),
        backgroundColor: Colors.indigo,
        elevation: 2,
      ),
      body: bookings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : AnimatedList(
        key: _listKey,
        initialItemCount: bookings.length,
        itemBuilder: (context, index, animation) =>
            _buildBookingCard(context, index, animation),
      ),
    );
  }
}
