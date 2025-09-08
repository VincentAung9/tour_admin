import 'dart:convert';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

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



  Future<void> generateInvoicePdf(Map<String, dynamic> booking) async {
    final pdf = pw.Document();

    try {
      final arialFont = pw.Font.ttf(await rootBundle.load('assets/arial.ttf'));

      // Load company logo
      final logoBytes = await rootBundle.load('assets/logo_header.png');
      final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

      // Load tour image if available
      pw.MemoryImage? tourImage;
      try {
        if (booking['tourImageUrl'] != null && booking['tourImageUrl'].toString().isNotEmpty) {
          final tourBytes = (await NetworkAssetBundle(Uri.parse(booking['tourImageUrl'])).load(""))
              .buffer
              .asUint8List();
          tourImage = pw.MemoryImage(tourBytes);
        }
      } catch (_) {}

      final date = DateTime.tryParse(booking['bookingDate'] ?? "") ?? DateTime.now();
      final formattedDate = "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')} "
          "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

      // Generate QR code (booking ID)
      final qr = pw.Barcode.qrCode();
      final qrSvg = qr.toSvg(
        booking['id'] ?? 'N/A',
        width: 100,
        height: 100,
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Image(logoImage, height: 60),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text("INVOICE",
                              style: pw.TextStyle(
                                  font: arialFont,
                                  fontSize: 22,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.indigo)),
                          pw.Text("Booking.com Style",
                              style: pw.TextStyle(font: arialFont, fontSize: 10)),
                        ],
                      )
                    ],
                  ),
                  pw.SizedBox(height: 15),

                  // Tour Image
                  if (tourImage != null)
                    pw.ClipRRect(
                      horizontalRadius: 10,
                      verticalRadius: 10,
                      child: pw.Image(tourImage, height: 180, fit: pw.BoxFit.cover),
                    ),
                  pw.SizedBox(height: 15),

                  // Customer Details
                  pw.Container(
                    padding: const pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(10),
                      color: PdfColors.grey100,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Customer Details",
                            style: pw.TextStyle(
                                font: arialFont,
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.indigo900)),
                        pw.SizedBox(height: 5),
                        pw.Text("Name: ${booking['userName'] ?? 'N/A'}"),
                        pw.Text("Email: ${booking['email'] ?? 'N/A'}"),
                        pw.Text("Phone: ${booking['phoneNumber'] ?? 'N/A'}"),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 15),

                  // Booking Info Card
                  pw.Container(
                    padding: const pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(10),
                      color: PdfColors.grey100,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(booking['tourTitle'] ?? 'Unknown Tour',
                            style: pw.TextStyle(
                                font: arialFont,
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.indigo900)),
                        pw.SizedBox(height: 5),
                        pw.Text(booking['tourLocation'] ?? 'No Location',
                            style: pw.TextStyle(font: arialFont, fontSize: 12, color: PdfColors.grey800)),
                        pw.SizedBox(height: 10),
                        pw.Divider(),
                        _priceRow("Booking ID", booking['id'] ?? 'N/A'),
                        _priceRow("Date & Time", formattedDate),
                        _priceRow("Status", booking['status'] ?? 'PENDING'),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),

                  // Price Details
                  pw.Text("Payment Summary",
                      style: pw.TextStyle(
                          font: arialFont,
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.indigo)),
                  pw.SizedBox(height: 8),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(10),
                    ),
                    child: pw.Column(
                      children: [
                        _priceRow("Plan", "\$${booking['planPrice']}"),
                        _priceRow("Service Fee", "\$${booking['serviceFee']}"),
                        _priceRow("Discount", "-\$${booking['discount']}"),
                        pw.Divider(),
                        _priceRow("Total", "\$${booking['totalAmount']}",
                            isBold: true, color: PdfColors.indigo900),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),

                  // QR Code
                  pw.Center(
                    child: pw.Column(
                      children: [
                        pw.Text("Scan QR for Booking Details",
                            style: pw.TextStyle(font: arialFont, fontSize: 12, color: PdfColors.grey800)),
                        pw.SizedBox(height: 5),
                        pw.SvgImage(svg: qrSvg, width: 100, height: 100),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),

                  // Footer
                  pw.Center(
                    child: pw.Text("Thank you for booking with us!",
                        style: pw.TextStyle(font: arialFont, fontSize: 12, color: PdfColors.grey700)),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Save PDF
      final outputDir = await getTemporaryDirectory();
      final file = File('${outputDir.path}/invoice_${booking['id']}.pdf');
      await file.writeAsBytes(await pdf.save());

      // Open PDF
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => InvoiceViewerScreen(pdfFile: file)),
        );
      }
    } catch (e) {
      print('Error generating PDF: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate PDF: $e')),
        );
      }
    }
  }

// Helper for price rows
  pw.Widget _priceRow(String label, String value, {bool isBold = false, PdfColor? color}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label,
            style: pw.TextStyle(
                fontSize: 12,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: color ?? PdfColors.black)),
        pw.Text(value,
            style: pw.TextStyle(
                fontSize: 12,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: color ?? PdfColors.black)),
      ],
    );
  }



  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = BookingStatus.values.firstWhere(
      (e) => e.name == (booking['status'] ?? 'PENDING'),
      orElse: () => BookingStatus.PENDING,
    );
    final statusColor = _getStatusColor(status);
    final date = DateTime.parse(booking['bookingDate'] ?? DateTime.now().toIso8601String());

    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 220,
        child: Stack(
          children: [
            // Full image background
            Positioned.fill(
              child: booking['tourImageUrl'] != null && booking['tourImageUrl'].toString().isNotEmpty
                  ? Image.network(
                      booking['tourImageUrl'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300]),
                    )
                  : Container(color: Colors.grey[300]),
            ),
            // Overlay with gradient for readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            // Status at top right
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  status.name,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Date at top left
            Positioned(
              top: 16,
              left: 16,
              child: Text(
                '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            // Tour title, location, booking ID at bottom left
            Positioned(
              left: 16,
              bottom: 16,
              right: 120, // leave space for price/button
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    booking['tourTitle'] ?? 'Unknown Tour',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          booking['tourLocation'] ?? 'No Location',
                          style: const TextStyle(fontSize: 14, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Booking: ${booking['id'] ?? 'N/A'}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ),
            // Price and button at bottom right
            Positioned(
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${booking['totalAmount'] ?? '0.00'}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  if (status == BookingStatus.CONFIRMED || status == BookingStatus.COMPLETED)
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        foregroundColor: Colors.indigo,
                      ),
                      onPressed: () => generateInvoicePdf(booking),
                      child: const Text('Download Invoice'),
                    ),
                ],
              ),
            ),
          ],
        ),
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
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
          tabs: const [
            Tab(text: 'PENDING'),
            Tab(text: 'CONFIRMED'),
            Tab(text: 'COMPLETED'),
            Tab(text: 'CANCELED'),
          ],
        ),
      ),
      body: _isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: 3,
                itemBuilder: (context, index) => Card(
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 16,
                              width: 120,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 14,
                              width: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 12,
                              width: 100,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 16,
                              width: 60,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
}


class InvoiceViewerScreen extends StatelessWidget {
  final File pdfFile;

  const InvoiceViewerScreen({super.key, required this.pdfFile});

  void _sharePdf(BuildContext context) async {
    try {
      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        text: 'Here is your invoice PDF.',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share PDF: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice for Your Booking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _sharePdf(context),
          ),
        ],
      ),
      body: SfPdfViewer.file(pdfFile),
    );
  }
}
