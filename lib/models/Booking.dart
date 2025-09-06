/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the Booking type in your schema. */
class Booking extends amplify_core.Model {
  static const classType = const _BookingModelType();
  final String id;
  final String? _userId;
  final String? _userEmail;
  final String? _userName;
  final String? _email;
  final String? _phoneNumber;
  final String? _tourId;
  final String? _tourTitle;
  final String? _tourLocation;
  final String? _tourImageUrl;
  final String? _planName;
  final String? _planPrice;
  final double? _subtotal;
  final double? _discount;
  final double? _serviceFee;
  final double? _totalAmount;
  final String? _paymentMethod;
  final String? _paymentIntentId;
  final String? _paymentStatus;
  final String? _invoiceUrl;
  final BookingStatus? _status;
  final amplify_core.TemporalDateTime? _bookingDate;
  final List<ChatMessage>? _chats;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  BookingModelIdentifier get modelIdentifier {
      return BookingModelIdentifier(
        id: id
      );
  }
  
  String get userId {
    try {
      return _userId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get userEmail {
    try {
      return _userEmail!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get userName {
    try {
      return _userName!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get email {
    try {
      return _email!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get phoneNumber {
    try {
      return _phoneNumber!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get tourId {
    try {
      return _tourId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get tourTitle {
    try {
      return _tourTitle!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get tourLocation {
    try {
      return _tourLocation!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get tourImageUrl {
    try {
      return _tourImageUrl!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get planName {
    try {
      return _planName!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get planPrice {
    try {
      return _planPrice!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get subtotal {
    try {
      return _subtotal!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get discount {
    try {
      return _discount!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get serviceFee {
    try {
      return _serviceFee!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get totalAmount {
    try {
      return _totalAmount!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get paymentMethod {
    try {
      return _paymentMethod!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get paymentIntentId {
    return _paymentIntentId;
  }
  
  String get paymentStatus {
    try {
      return _paymentStatus!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get invoiceUrl {
    return _invoiceUrl;
  }
  
  BookingStatus get status {
    try {
      return _status!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime get bookingDate {
    try {
      return _bookingDate!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<ChatMessage>? get chats {
    return _chats;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Booking._internal({required this.id, required userId, required userEmail, required userName, required email, required phoneNumber, required tourId, required tourTitle, required tourLocation, required tourImageUrl, required planName, required planPrice, required subtotal, required discount, required serviceFee, required totalAmount, required paymentMethod, paymentIntentId, required paymentStatus, invoiceUrl, required status, required bookingDate, chats, createdAt, updatedAt}): _userId = userId, _userEmail = userEmail, _userName = userName, _email = email, _phoneNumber = phoneNumber, _tourId = tourId, _tourTitle = tourTitle, _tourLocation = tourLocation, _tourImageUrl = tourImageUrl, _planName = planName, _planPrice = planPrice, _subtotal = subtotal, _discount = discount, _serviceFee = serviceFee, _totalAmount = totalAmount, _paymentMethod = paymentMethod, _paymentIntentId = paymentIntentId, _paymentStatus = paymentStatus, _invoiceUrl = invoiceUrl, _status = status, _bookingDate = bookingDate, _chats = chats, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Booking({String? id, required String userId, required String userEmail, required String userName, required String email, required String phoneNumber, required String tourId, required String tourTitle, required String tourLocation, required String tourImageUrl, required String planName, required String planPrice, required double subtotal, required double discount, required double serviceFee, required double totalAmount, required String paymentMethod, String? paymentIntentId, required String paymentStatus, String? invoiceUrl, required BookingStatus status, required amplify_core.TemporalDateTime bookingDate, List<ChatMessage>? chats}) {
    return Booking._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      userId: userId,
      userEmail: userEmail,
      userName: userName,
      email: email,
      phoneNumber: phoneNumber,
      tourId: tourId,
      tourTitle: tourTitle,
      tourLocation: tourLocation,
      tourImageUrl: tourImageUrl,
      planName: planName,
      planPrice: planPrice,
      subtotal: subtotal,
      discount: discount,
      serviceFee: serviceFee,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      paymentIntentId: paymentIntentId,
      paymentStatus: paymentStatus,
      invoiceUrl: invoiceUrl,
      status: status,
      bookingDate: bookingDate,
      chats: chats != null ? List<ChatMessage>.unmodifiable(chats) : chats);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Booking &&
      id == other.id &&
      _userId == other._userId &&
      _userEmail == other._userEmail &&
      _userName == other._userName &&
      _email == other._email &&
      _phoneNumber == other._phoneNumber &&
      _tourId == other._tourId &&
      _tourTitle == other._tourTitle &&
      _tourLocation == other._tourLocation &&
      _tourImageUrl == other._tourImageUrl &&
      _planName == other._planName &&
      _planPrice == other._planPrice &&
      _subtotal == other._subtotal &&
      _discount == other._discount &&
      _serviceFee == other._serviceFee &&
      _totalAmount == other._totalAmount &&
      _paymentMethod == other._paymentMethod &&
      _paymentIntentId == other._paymentIntentId &&
      _paymentStatus == other._paymentStatus &&
      _invoiceUrl == other._invoiceUrl &&
      _status == other._status &&
      _bookingDate == other._bookingDate &&
      DeepCollectionEquality().equals(_chats, other._chats);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Booking {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("userEmail=" + "$_userEmail" + ", ");
    buffer.write("userName=" + "$_userName" + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("phoneNumber=" + "$_phoneNumber" + ", ");
    buffer.write("tourId=" + "$_tourId" + ", ");
    buffer.write("tourTitle=" + "$_tourTitle" + ", ");
    buffer.write("tourLocation=" + "$_tourLocation" + ", ");
    buffer.write("tourImageUrl=" + "$_tourImageUrl" + ", ");
    buffer.write("planName=" + "$_planName" + ", ");
    buffer.write("planPrice=" + "$_planPrice" + ", ");
    buffer.write("subtotal=" + (_subtotal != null ? _subtotal!.toString() : "null") + ", ");
    buffer.write("discount=" + (_discount != null ? _discount!.toString() : "null") + ", ");
    buffer.write("serviceFee=" + (_serviceFee != null ? _serviceFee!.toString() : "null") + ", ");
    buffer.write("totalAmount=" + (_totalAmount != null ? _totalAmount!.toString() : "null") + ", ");
    buffer.write("paymentMethod=" + "$_paymentMethod" + ", ");
    buffer.write("paymentIntentId=" + "$_paymentIntentId" + ", ");
    buffer.write("paymentStatus=" + "$_paymentStatus" + ", ");
    buffer.write("invoiceUrl=" + "$_invoiceUrl" + ", ");
    buffer.write("status=" + (_status != null ? amplify_core.enumToString(_status)! : "null") + ", ");
    buffer.write("bookingDate=" + (_bookingDate != null ? _bookingDate!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Booking copyWith({String? userId, String? userEmail, String? userName, String? email, String? phoneNumber, String? tourId, String? tourTitle, String? tourLocation, String? tourImageUrl, String? planName, String? planPrice, double? subtotal, double? discount, double? serviceFee, double? totalAmount, String? paymentMethod, String? paymentIntentId, String? paymentStatus, String? invoiceUrl, BookingStatus? status, amplify_core.TemporalDateTime? bookingDate, List<ChatMessage>? chats}) {
    return Booking._internal(
      id: id,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      tourId: tourId ?? this.tourId,
      tourTitle: tourTitle ?? this.tourTitle,
      tourLocation: tourLocation ?? this.tourLocation,
      tourImageUrl: tourImageUrl ?? this.tourImageUrl,
      planName: planName ?? this.planName,
      planPrice: planPrice ?? this.planPrice,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      serviceFee: serviceFee ?? this.serviceFee,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      invoiceUrl: invoiceUrl ?? this.invoiceUrl,
      status: status ?? this.status,
      bookingDate: bookingDate ?? this.bookingDate,
      chats: chats ?? this.chats);
  }
  
  Booking copyWithModelFieldValues({
    ModelFieldValue<String>? userId,
    ModelFieldValue<String>? userEmail,
    ModelFieldValue<String>? userName,
    ModelFieldValue<String>? email,
    ModelFieldValue<String>? phoneNumber,
    ModelFieldValue<String>? tourId,
    ModelFieldValue<String>? tourTitle,
    ModelFieldValue<String>? tourLocation,
    ModelFieldValue<String>? tourImageUrl,
    ModelFieldValue<String>? planName,
    ModelFieldValue<String>? planPrice,
    ModelFieldValue<double>? subtotal,
    ModelFieldValue<double>? discount,
    ModelFieldValue<double>? serviceFee,
    ModelFieldValue<double>? totalAmount,
    ModelFieldValue<String>? paymentMethod,
    ModelFieldValue<String?>? paymentIntentId,
    ModelFieldValue<String>? paymentStatus,
    ModelFieldValue<String?>? invoiceUrl,
    ModelFieldValue<BookingStatus>? status,
    ModelFieldValue<amplify_core.TemporalDateTime>? bookingDate,
    ModelFieldValue<List<ChatMessage>?>? chats
  }) {
    return Booking._internal(
      id: id,
      userId: userId == null ? this.userId : userId.value,
      userEmail: userEmail == null ? this.userEmail : userEmail.value,
      userName: userName == null ? this.userName : userName.value,
      email: email == null ? this.email : email.value,
      phoneNumber: phoneNumber == null ? this.phoneNumber : phoneNumber.value,
      tourId: tourId == null ? this.tourId : tourId.value,
      tourTitle: tourTitle == null ? this.tourTitle : tourTitle.value,
      tourLocation: tourLocation == null ? this.tourLocation : tourLocation.value,
      tourImageUrl: tourImageUrl == null ? this.tourImageUrl : tourImageUrl.value,
      planName: planName == null ? this.planName : planName.value,
      planPrice: planPrice == null ? this.planPrice : planPrice.value,
      subtotal: subtotal == null ? this.subtotal : subtotal.value,
      discount: discount == null ? this.discount : discount.value,
      serviceFee: serviceFee == null ? this.serviceFee : serviceFee.value,
      totalAmount: totalAmount == null ? this.totalAmount : totalAmount.value,
      paymentMethod: paymentMethod == null ? this.paymentMethod : paymentMethod.value,
      paymentIntentId: paymentIntentId == null ? this.paymentIntentId : paymentIntentId.value,
      paymentStatus: paymentStatus == null ? this.paymentStatus : paymentStatus.value,
      invoiceUrl: invoiceUrl == null ? this.invoiceUrl : invoiceUrl.value,
      status: status == null ? this.status : status.value,
      bookingDate: bookingDate == null ? this.bookingDate : bookingDate.value,
      chats: chats == null ? this.chats : chats.value
    );
  }
  
  Booking.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _userId = json['userId'],
      _userEmail = json['userEmail'],
      _userName = json['userName'],
      _email = json['email'],
      _phoneNumber = json['phoneNumber'],
      _tourId = json['tourId'],
      _tourTitle = json['tourTitle'],
      _tourLocation = json['tourLocation'],
      _tourImageUrl = json['tourImageUrl'],
      _planName = json['planName'],
      _planPrice = json['planPrice'],
      _subtotal = (json['subtotal'] as num?)?.toDouble(),
      _discount = (json['discount'] as num?)?.toDouble(),
      _serviceFee = (json['serviceFee'] as num?)?.toDouble(),
      _totalAmount = (json['totalAmount'] as num?)?.toDouble(),
      _paymentMethod = json['paymentMethod'],
      _paymentIntentId = json['paymentIntentId'],
      _paymentStatus = json['paymentStatus'],
      _invoiceUrl = json['invoiceUrl'],
      _status = amplify_core.enumFromString<BookingStatus>(json['status'], BookingStatus.values),
      _bookingDate = json['bookingDate'] != null ? amplify_core.TemporalDateTime.fromString(json['bookingDate']) : null,
      _chats = json['chats']  is Map
        ? (json['chats']['items'] is List
          ? (json['chats']['items'] as List)
              .where((e) => e != null)
              .map((e) => ChatMessage.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['chats'] is List
          ? (json['chats'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => ChatMessage.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'userId': _userId, 'userEmail': _userEmail, 'userName': _userName, 'email': _email, 'phoneNumber': _phoneNumber, 'tourId': _tourId, 'tourTitle': _tourTitle, 'tourLocation': _tourLocation, 'tourImageUrl': _tourImageUrl, 'planName': _planName, 'planPrice': _planPrice, 'subtotal': _subtotal, 'discount': _discount, 'serviceFee': _serviceFee, 'totalAmount': _totalAmount, 'paymentMethod': _paymentMethod, 'paymentIntentId': _paymentIntentId, 'paymentStatus': _paymentStatus, 'invoiceUrl': _invoiceUrl, 'status': amplify_core.enumToString(_status), 'bookingDate': _bookingDate?.format(), 'chats': _chats?.map((ChatMessage? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'userId': _userId,
    'userEmail': _userEmail,
    'userName': _userName,
    'email': _email,
    'phoneNumber': _phoneNumber,
    'tourId': _tourId,
    'tourTitle': _tourTitle,
    'tourLocation': _tourLocation,
    'tourImageUrl': _tourImageUrl,
    'planName': _planName,
    'planPrice': _planPrice,
    'subtotal': _subtotal,
    'discount': _discount,
    'serviceFee': _serviceFee,
    'totalAmount': _totalAmount,
    'paymentMethod': _paymentMethod,
    'paymentIntentId': _paymentIntentId,
    'paymentStatus': _paymentStatus,
    'invoiceUrl': _invoiceUrl,
    'status': _status,
    'bookingDate': _bookingDate,
    'chats': _chats,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<BookingModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<BookingModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final USEREMAIL = amplify_core.QueryField(fieldName: "userEmail");
  static final USERNAME = amplify_core.QueryField(fieldName: "userName");
  static final EMAIL = amplify_core.QueryField(fieldName: "email");
  static final PHONENUMBER = amplify_core.QueryField(fieldName: "phoneNumber");
  static final TOURID = amplify_core.QueryField(fieldName: "tourId");
  static final TOURTITLE = amplify_core.QueryField(fieldName: "tourTitle");
  static final TOURLOCATION = amplify_core.QueryField(fieldName: "tourLocation");
  static final TOURIMAGEURL = amplify_core.QueryField(fieldName: "tourImageUrl");
  static final PLANNAME = amplify_core.QueryField(fieldName: "planName");
  static final PLANPRICE = amplify_core.QueryField(fieldName: "planPrice");
  static final SUBTOTAL = amplify_core.QueryField(fieldName: "subtotal");
  static final DISCOUNT = amplify_core.QueryField(fieldName: "discount");
  static final SERVICEFEE = amplify_core.QueryField(fieldName: "serviceFee");
  static final TOTALAMOUNT = amplify_core.QueryField(fieldName: "totalAmount");
  static final PAYMENTMETHOD = amplify_core.QueryField(fieldName: "paymentMethod");
  static final PAYMENTINTENTID = amplify_core.QueryField(fieldName: "paymentIntentId");
  static final PAYMENTSTATUS = amplify_core.QueryField(fieldName: "paymentStatus");
  static final INVOICEURL = amplify_core.QueryField(fieldName: "invoiceUrl");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final BOOKINGDATE = amplify_core.QueryField(fieldName: "bookingDate");
  static final CHATS = amplify_core.QueryField(
    fieldName: "chats",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ChatMessage'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Booking";
    modelSchemaDefinition.pluralName = "Bookings";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        operations: const [
          amplify_core.ModelOperation.READ,
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["userId"], name: "byUser"),
      amplify_core.ModelIndex(fields: const ["userEmail"], name: "byUserEmail"),
      amplify_core.ModelIndex(fields: const ["tourId"], name: "byTour")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.USERID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.USEREMAIL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.USERNAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.EMAIL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.PHONENUMBER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.TOURID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.TOURTITLE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.TOURLOCATION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.TOURIMAGEURL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.PLANNAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.PLANPRICE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.SUBTOTAL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.DISCOUNT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.SERVICEFEE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.TOTALAMOUNT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.PAYMENTMETHOD,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.PAYMENTINTENTID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.PAYMENTSTATUS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.INVOICEURL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.STATUS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Booking.BOOKINGDATE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Booking.CHATS,
      isRequired: false,
      ofModelName: 'ChatMessage',
      associatedKey: ChatMessage.BOOKINGID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _BookingModelType extends amplify_core.ModelType<Booking> {
  const _BookingModelType();
  
  @override
  Booking fromJson(Map<String, dynamic> jsonData) {
    return Booking.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Booking';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Booking] in your schema.
 */
class BookingModelIdentifier implements amplify_core.ModelIdentifier<Booking> {
  final String id;

  /** Create an instance of BookingModelIdentifier using [id] the primary key. */
  const BookingModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'BookingModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is BookingModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}