import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:convert';

enum BookingStatus { PENDING, CONFIRMED, COMPLETED, CANCELED }

class UserBookingScreen extends StatefulWidget {
  const UserBookingScreen({super.key});

  @override
  State<UserBookingScreen> createState() => _UserBookingScreenState();
}

class _UserBookingScreenState extends State<UserBookingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchUserBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserBookings() async {
    setState(() => _isLoading = true);
    try {
      final authUser = await Amplify.Auth.getCurrentUser();
      final userId = authUser.userId;

      String graphQLDocument = '''
        query ListUserBookings(\$userId: ID!) {
          listBookings(filter: {userId: {eq: \$userId}}) {
            items {
              id
              bookingDate
              createdAt
              discount
              email
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

      final request = GraphQLRequest<String>(
        document: graphQLDocument,
        variables: {'userId': userId},
      );
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
          _isLoading = false;
        });
      } else if (response.errors.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading bookings: ${response.errors.first.message}')),
        );
        setState(() => _isLoading = false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bookings: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> _filterBookingsByStatus(BookingStatus status) {
    return bookings.where((booking) {
      final bookingStatus = BookingStatus.values.firstWhere(
            (e) => e.name == (booking['status'] ?? 'PENDING'),
        orElse: () => BookingStatus.PENDING,
      );
      return bookingStatus == status;
    }).toList();
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.CONFIRMED:
      case BookingStatus.COMPLETED:
        return Colors.green;
      case BookingStatus.PENDING:
        return Colors.yellow;
      case BookingStatus.CANCELED:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getMonthYear(String dateStr) {
    if (dateStr.isEmpty) return 'Unknown';
    final date = DateTime.parse(dateStr);
    return '${DateTime.now().year == date.year ? '' : '${date.year} '}${date.month.toString().padLeft(2, '0')}-${date.year.toString().substring(2)}';
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = BookingStatus.values.firstWhere(
          (e) => e.name == (booking['status'] ?? 'PENDING'),
      orElse: () => BookingStatus.PENDING,
    );
    final statusColor = _getStatusColor(status);
    final date = DateTime.parse(booking['bookingDate'] ?? DateTime.now().toIso8601String());
    final monthYear = _getMonthYear(booking['bookingDate'] ?? '');

    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              if (booking['tourImageUrl'] != null && booking['tourImageUrl'].toString().isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    booking['tourImageUrl'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
                  ),
                ),
              Positioned(
                top: 8,
                left: 8,
                child: Text(
                  '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white, backgroundColor: Colors.black54),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      booking['tourTitle'] ?? 'Unknown Tour',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            status.name,
                            style: const TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    Text(booking['tourLocation'] ?? 'No Location', style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Booking: ${booking['id'] ?? 'N/A'}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${booking['totalAmount'] ?? '0.00'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/booking-details', arguments: booking['id']);
                          },
                          child: const Text('View Details'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Placeholder for download ticket logic
                          },
                          child: const Text('Download Ticket'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MY BOOKING',
          style: TextStyle(
            color: Colors.indigo,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: const [Icon(Icons.notifications)],
        bottom: TabBar(
          labelPadding: const EdgeInsets.symmetric(horizontal: 0),
          controller: _tabController,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          tabs: const [
            Tab(text: 'PENDING'),
            Tab(text: 'CONFIRMED'),
            Tab(text: 'COMPLETED'),
            Tab(text: 'CANCELED'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
        child: CupertinoActivityIndicator(
          radius: 20.0,
          color: CupertinoColors.activeBlue,
        ),
      )
          : Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingsList(BookingStatus.PENDING),
                _buildBookingsList(BookingStatus.CONFIRMED),
                _buildBookingsList(BookingStatus.COMPLETED),
                _buildBookingsList(BookingStatus.CANCELED),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(BookingStatus status) {
    final filteredBookings = _filterBookingsByStatus(status);
    if (filteredBookings.isEmpty) {
      return const Center(child: Text('No bookings found'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) => _buildBookingCard(filteredBookings[index]),
    );
  }
}
