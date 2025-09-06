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


/** This is an auto generated class representing the ChatMessage type in your schema. */
class ChatMessage extends amplify_core.Model {
  static const classType = const _ChatMessageModelType();
  final String id;
  final String? _senderEmail;
  final String? _senderName;
  final String? _receiverEmail;
  final String? _message;
  final bool? _isFromUser;
  final amplify_core.TemporalDateTime? _createdAt;
  final String? _bookingId;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ChatMessageModelIdentifier get modelIdentifier {
      return ChatMessageModelIdentifier(
        id: id
      );
  }
  
  String get senderEmail {
    try {
      return _senderEmail!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get senderName {
    return _senderName;
  }
  
  String get receiverEmail {
    try {
      return _receiverEmail!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get message {
    try {
      return _message!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get isFromUser {
    try {
      return _isFromUser!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime get createdAt {
    try {
      return _createdAt!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get bookingId {
    return _bookingId;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ChatMessage._internal({required this.id, required senderEmail, senderName, required receiverEmail, required message, required isFromUser, required createdAt, bookingId, updatedAt}): _senderEmail = senderEmail, _senderName = senderName, _receiverEmail = receiverEmail, _message = message, _isFromUser = isFromUser, _createdAt = createdAt, _bookingId = bookingId, _updatedAt = updatedAt;
  
  factory ChatMessage({String? id, required String senderEmail, String? senderName, required String receiverEmail, required String message, required bool isFromUser, required amplify_core.TemporalDateTime createdAt, String? bookingId}) {
    return ChatMessage._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      senderEmail: senderEmail,
      senderName: senderName,
      receiverEmail: receiverEmail,
      message: message,
      isFromUser: isFromUser,
      createdAt: createdAt,
      bookingId: bookingId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMessage &&
      id == other.id &&
      _senderEmail == other._senderEmail &&
      _senderName == other._senderName &&
      _receiverEmail == other._receiverEmail &&
      _message == other._message &&
      _isFromUser == other._isFromUser &&
      _createdAt == other._createdAt &&
      _bookingId == other._bookingId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ChatMessage {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("senderEmail=" + "$_senderEmail" + ", ");
    buffer.write("senderName=" + "$_senderName" + ", ");
    buffer.write("receiverEmail=" + "$_receiverEmail" + ", ");
    buffer.write("message=" + "$_message" + ", ");
    buffer.write("isFromUser=" + (_isFromUser != null ? _isFromUser!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("bookingId=" + "$_bookingId" + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ChatMessage copyWith({String? senderEmail, String? senderName, String? receiverEmail, String? message, bool? isFromUser, amplify_core.TemporalDateTime? createdAt, String? bookingId}) {
    return ChatMessage._internal(
      id: id,
      senderEmail: senderEmail ?? this.senderEmail,
      senderName: senderName ?? this.senderName,
      receiverEmail: receiverEmail ?? this.receiverEmail,
      message: message ?? this.message,
      isFromUser: isFromUser ?? this.isFromUser,
      createdAt: createdAt ?? this.createdAt,
      bookingId: bookingId ?? this.bookingId);
  }
  
  ChatMessage copyWithModelFieldValues({
    ModelFieldValue<String>? senderEmail,
    ModelFieldValue<String?>? senderName,
    ModelFieldValue<String>? receiverEmail,
    ModelFieldValue<String>? message,
    ModelFieldValue<bool>? isFromUser,
    ModelFieldValue<amplify_core.TemporalDateTime>? createdAt,
    ModelFieldValue<String?>? bookingId
  }) {
    return ChatMessage._internal(
      id: id,
      senderEmail: senderEmail == null ? this.senderEmail : senderEmail.value,
      senderName: senderName == null ? this.senderName : senderName.value,
      receiverEmail: receiverEmail == null ? this.receiverEmail : receiverEmail.value,
      message: message == null ? this.message : message.value,
      isFromUser: isFromUser == null ? this.isFromUser : isFromUser.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      bookingId: bookingId == null ? this.bookingId : bookingId.value
    );
  }
  
  ChatMessage.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _senderEmail = json['senderEmail'],
      _senderName = json['senderName'],
      _receiverEmail = json['receiverEmail'],
      _message = json['message'],
      _isFromUser = json['isFromUser'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _bookingId = json['bookingId'],
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'senderEmail': _senderEmail, 'senderName': _senderName, 'receiverEmail': _receiverEmail, 'message': _message, 'isFromUser': _isFromUser, 'createdAt': _createdAt?.format(), 'bookingId': _bookingId, 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'senderEmail': _senderEmail,
    'senderName': _senderName,
    'receiverEmail': _receiverEmail,
    'message': _message,
    'isFromUser': _isFromUser,
    'createdAt': _createdAt,
    'bookingId': _bookingId,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ChatMessageModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ChatMessageModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SENDEREMAIL = amplify_core.QueryField(fieldName: "senderEmail");
  static final SENDERNAME = amplify_core.QueryField(fieldName: "senderName");
  static final RECEIVEREMAIL = amplify_core.QueryField(fieldName: "receiverEmail");
  static final MESSAGE = amplify_core.QueryField(fieldName: "message");
  static final ISFROMUSER = amplify_core.QueryField(fieldName: "isFromUser");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final BOOKINGID = amplify_core.QueryField(fieldName: "bookingId");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ChatMessage";
    modelSchemaDefinition.pluralName = "ChatMessages";
    
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
      amplify_core.ModelIndex(fields: const ["senderEmail"], name: "bySenderEmail"),
      amplify_core.ModelIndex(fields: const ["receiverEmail"], name: "byReceiverEmail"),
      amplify_core.ModelIndex(fields: const ["bookingId"], name: "byBooking")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatMessage.SENDEREMAIL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatMessage.SENDERNAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatMessage.RECEIVEREMAIL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatMessage.MESSAGE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatMessage.ISFROMUSER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatMessage.CREATEDAT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatMessage.BOOKINGID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _ChatMessageModelType extends amplify_core.ModelType<ChatMessage> {
  const _ChatMessageModelType();
  
  @override
  ChatMessage fromJson(Map<String, dynamic> jsonData) {
    return ChatMessage.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ChatMessage';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ChatMessage] in your schema.
 */
class ChatMessageModelIdentifier implements amplify_core.ModelIdentifier<ChatMessage> {
  final String id;

  /** Create an instance of ChatMessageModelIdentifier using [id] the primary key. */
  const ChatMessageModelIdentifier({
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
  String toString() => 'ChatMessageModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ChatMessageModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}