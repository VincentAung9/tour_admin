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


/** This is an auto generated class representing the PromoCode type in your schema. */
class PromoCode extends amplify_core.Model {
  static const classType = const _PromoCodeModelType();
  final String id;
  final String? _code;
  final String? _discountType;
  final int? _discountValue;
  final bool? _isActive;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _expiresAt;
  final int? _maxUsagePerUser;
  final int? _maxGlobalUsage;
  final int? _usageCount;
  final List<String>? _usedBy;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  PromoCodeModelIdentifier get modelIdentifier {
      return PromoCodeModelIdentifier(
        id: id
      );
  }
  
  String get code {
    try {
      return _code!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get discountType {
    try {
      return _discountType!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get discountValue {
    try {
      return _discountValue!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get isActive {
    try {
      return _isActive!;
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
  
  amplify_core.TemporalDateTime get expiresAt {
    try {
      return _expiresAt!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int? get maxUsagePerUser {
    return _maxUsagePerUser;
  }
  
  int? get maxGlobalUsage {
    return _maxGlobalUsage;
  }
  
  int? get usageCount {
    return _usageCount;
  }
  
  List<String>? get usedBy {
    return _usedBy;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const PromoCode._internal({required this.id, required code, required discountType, required discountValue, required isActive, required createdAt, required expiresAt, maxUsagePerUser, maxGlobalUsage, usageCount, usedBy, updatedAt}): _code = code, _discountType = discountType, _discountValue = discountValue, _isActive = isActive, _createdAt = createdAt, _expiresAt = expiresAt, _maxUsagePerUser = maxUsagePerUser, _maxGlobalUsage = maxGlobalUsage, _usageCount = usageCount, _usedBy = usedBy, _updatedAt = updatedAt;
  
  factory PromoCode({String? id, required String code, required String discountType, required int discountValue, required bool isActive, required amplify_core.TemporalDateTime createdAt, required amplify_core.TemporalDateTime expiresAt, int? maxUsagePerUser, int? maxGlobalUsage, int? usageCount, List<String>? usedBy}) {
    return PromoCode._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      code: code,
      discountType: discountType,
      discountValue: discountValue,
      isActive: isActive,
      createdAt: createdAt,
      expiresAt: expiresAt,
      maxUsagePerUser: maxUsagePerUser,
      maxGlobalUsage: maxGlobalUsage,
      usageCount: usageCount,
      usedBy: usedBy != null ? List<String>.unmodifiable(usedBy) : usedBy);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PromoCode &&
      id == other.id &&
      _code == other._code &&
      _discountType == other._discountType &&
      _discountValue == other._discountValue &&
      _isActive == other._isActive &&
      _createdAt == other._createdAt &&
      _expiresAt == other._expiresAt &&
      _maxUsagePerUser == other._maxUsagePerUser &&
      _maxGlobalUsage == other._maxGlobalUsage &&
      _usageCount == other._usageCount &&
      DeepCollectionEquality().equals(_usedBy, other._usedBy);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("PromoCode {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("code=" + "$_code" + ", ");
    buffer.write("discountType=" + "$_discountType" + ", ");
    buffer.write("discountValue=" + (_discountValue != null ? _discountValue!.toString() : "null") + ", ");
    buffer.write("isActive=" + (_isActive != null ? _isActive!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("expiresAt=" + (_expiresAt != null ? _expiresAt!.format() : "null") + ", ");
    buffer.write("maxUsagePerUser=" + (_maxUsagePerUser != null ? _maxUsagePerUser!.toString() : "null") + ", ");
    buffer.write("maxGlobalUsage=" + (_maxGlobalUsage != null ? _maxGlobalUsage!.toString() : "null") + ", ");
    buffer.write("usageCount=" + (_usageCount != null ? _usageCount!.toString() : "null") + ", ");
    buffer.write("usedBy=" + (_usedBy != null ? _usedBy!.toString() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  PromoCode copyWith({String? code, String? discountType, int? discountValue, bool? isActive, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? expiresAt, int? maxUsagePerUser, int? maxGlobalUsage, int? usageCount, List<String>? usedBy}) {
    return PromoCode._internal(
      id: id,
      code: code ?? this.code,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      maxUsagePerUser: maxUsagePerUser ?? this.maxUsagePerUser,
      maxGlobalUsage: maxGlobalUsage ?? this.maxGlobalUsage,
      usageCount: usageCount ?? this.usageCount,
      usedBy: usedBy ?? this.usedBy);
  }
  
  PromoCode copyWithModelFieldValues({
    ModelFieldValue<String>? code,
    ModelFieldValue<String>? discountType,
    ModelFieldValue<int>? discountValue,
    ModelFieldValue<bool>? isActive,
    ModelFieldValue<amplify_core.TemporalDateTime>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime>? expiresAt,
    ModelFieldValue<int?>? maxUsagePerUser,
    ModelFieldValue<int?>? maxGlobalUsage,
    ModelFieldValue<int?>? usageCount,
    ModelFieldValue<List<String>?>? usedBy
  }) {
    return PromoCode._internal(
      id: id,
      code: code == null ? this.code : code.value,
      discountType: discountType == null ? this.discountType : discountType.value,
      discountValue: discountValue == null ? this.discountValue : discountValue.value,
      isActive: isActive == null ? this.isActive : isActive.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      expiresAt: expiresAt == null ? this.expiresAt : expiresAt.value,
      maxUsagePerUser: maxUsagePerUser == null ? this.maxUsagePerUser : maxUsagePerUser.value,
      maxGlobalUsage: maxGlobalUsage == null ? this.maxGlobalUsage : maxGlobalUsage.value,
      usageCount: usageCount == null ? this.usageCount : usageCount.value,
      usedBy: usedBy == null ? this.usedBy : usedBy.value
    );
  }
  
  PromoCode.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _code = json['code'],
      _discountType = json['discountType'],
      _discountValue = (json['discountValue'] as num?)?.toInt(),
      _isActive = json['isActive'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _expiresAt = json['expiresAt'] != null ? amplify_core.TemporalDateTime.fromString(json['expiresAt']) : null,
      _maxUsagePerUser = (json['maxUsagePerUser'] as num?)?.toInt(),
      _maxGlobalUsage = (json['maxGlobalUsage'] as num?)?.toInt(),
      _usageCount = (json['usageCount'] as num?)?.toInt(),
      _usedBy = json['usedBy']?.cast<String>(),
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'code': _code, 'discountType': _discountType, 'discountValue': _discountValue, 'isActive': _isActive, 'createdAt': _createdAt?.format(), 'expiresAt': _expiresAt?.format(), 'maxUsagePerUser': _maxUsagePerUser, 'maxGlobalUsage': _maxGlobalUsage, 'usageCount': _usageCount, 'usedBy': _usedBy, 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'code': _code,
    'discountType': _discountType,
    'discountValue': _discountValue,
    'isActive': _isActive,
    'createdAt': _createdAt,
    'expiresAt': _expiresAt,
    'maxUsagePerUser': _maxUsagePerUser,
    'maxGlobalUsage': _maxGlobalUsage,
    'usageCount': _usageCount,
    'usedBy': _usedBy,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<PromoCodeModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<PromoCodeModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final CODE = amplify_core.QueryField(fieldName: "code");
  static final DISCOUNTTYPE = amplify_core.QueryField(fieldName: "discountType");
  static final DISCOUNTVALUE = amplify_core.QueryField(fieldName: "discountValue");
  static final ISACTIVE = amplify_core.QueryField(fieldName: "isActive");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final EXPIRESAT = amplify_core.QueryField(fieldName: "expiresAt");
  static final MAXUSAGEPERUSER = amplify_core.QueryField(fieldName: "maxUsagePerUser");
  static final MAXGLOBALUSAGE = amplify_core.QueryField(fieldName: "maxGlobalUsage");
  static final USAGECOUNT = amplify_core.QueryField(fieldName: "usageCount");
  static final USEDBY = amplify_core.QueryField(fieldName: "usedBy");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "PromoCode";
    modelSchemaDefinition.pluralName = "PromoCodes";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        provider: amplify_core.AuthRuleProvider.IAM,
        operations: const [
          amplify_core.ModelOperation.READ
        ]),
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PRIVATE,
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.READ,
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PromoCode.CODE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PromoCode.DISCOUNTTYPE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PromoCode.DISCOUNTVALUE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PromoCode.ISACTIVE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PromoCode.CREATEDAT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PromoCode.EXPIRESAT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PromoCode.MAXUSAGEPERUSER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PromoCode.MAXGLOBALUSAGE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PromoCode.USAGECOUNT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PromoCode.USEDBY,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _PromoCodeModelType extends amplify_core.ModelType<PromoCode> {
  const _PromoCodeModelType();
  
  @override
  PromoCode fromJson(Map<String, dynamic> jsonData) {
    return PromoCode.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'PromoCode';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [PromoCode] in your schema.
 */
class PromoCodeModelIdentifier implements amplify_core.ModelIdentifier<PromoCode> {
  final String id;

  /** Create an instance of PromoCodeModelIdentifier using [id] the primary key. */
  const PromoCodeModelIdentifier({
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
  String toString() => 'PromoCodeModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is PromoCodeModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}