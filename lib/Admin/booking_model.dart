// class BookingModel {
//   final String id;
//   final String userId;
//   final String userName;
//   final String email;
//   final String phoneNumber;
//   final String tourId;
//   final String tourTitle;
//   final String tourLocation;
//   final String tourImageUrl;
//   final String planName;
//   final double planPrice;
//   final double discount;
//   final double serviceFee;
//   final double totalAmount;
//   final String paymentMethod;
//   final String? promoCodeName;
//   final String? paymentIntentId;
//   final String status;
//   final String bookingDate;
//
//   BookingModel({
//     required this.id,
//     required this.userId,
//     required this.userName,
//     required this.email,
//     required this.phoneNumber,
//     required this.tourId,
//     required this.tourTitle,
//     required this.tourLocation,
//     required this.tourImageUrl,
//     required this.planName,
//     required this.planPrice,
//     required this.discount,
//     required this.serviceFee,
//     required this.totalAmount,
//     required this.paymentMethod,
//     this.promoCodeName,
//     this.paymentIntentId,
//     required this.status,
//     required this.bookingDate,
//   });
//
//   factory BookingModel.fromJson(Map<String, dynamic> json) {
//     return BookingModel(
//       id: json['id'] ?? '',
//       userId: json['userId'] ?? '',
//       userName: json['userName'] ?? '',
//       email: json['email'] ?? '',
//       phoneNumber: json['phoneNumber'] ?? '',
//       tourId: json['tourId'] ?? '',
//       tourTitle: json['tourTitle'] ?? '',
//       tourLocation: json['tourLocation'] ?? '',
//       tourImageUrl: json['tourImageUrl'] ?? '',
//       planName: json['planName'] ?? '',
//       planPrice: double.tryParse(json['planPrice']?.toString() ?? '0') ?? 0.0,
//       discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0.0,
//       serviceFee: double.tryParse(json['serviceFee']?.toString() ?? '0') ?? 0.0,
//       totalAmount: double.tryParse(json['totalAmount']?.toString() ?? '0') ?? 0.0,
//       paymentMethod: json['paymentMethod'] ?? '',
//       promoCodeName: json['promoCodeName'], // nullable
//       paymentIntentId: json['paymentIntentId'], // nullable
//       status: json['status'] ?? 'PENDING',
//       bookingDate: json['bookingDate'] ?? '',
//     );
//   }
//
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'userId': userId,
//       'userName': userName,
//       'email': email,
//       'phoneNumber': phoneNumber,
//       'tourId': tourId,
//       'tourTitle': tourTitle,
//       'tourLocation': tourLocation,
//       'tourImageUrl': tourImageUrl,
//       'planName': planName,
//       'planPrice': planPrice,
//       'discount': discount,
//       'serviceFee': serviceFee,
//       'totalAmount': totalAmount,
//       'paymentMethod': paymentMethod,
//       'promoCodeName': promoCodeName,
//       'paymentIntentId': paymentIntentId,
//       'status': status,
//       'bookingDate': bookingDate,
//     };
//   }
// }
