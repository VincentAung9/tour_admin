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


/** This is an auto generated class representing the Schedule type in your schema. */
class Schedule extends amplify_core.Model {
  static const classType = const _ScheduleModelType();
  final String id;
  final String? _tourId;
  final amplify_core.TemporalDateTime? _startDate;
  final amplify_core.TemporalDateTime? _endDate;
  final int? _maxPassengers;
  final int? _availableSlots;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ScheduleModelIdentifier get modelIdentifier {
      return ScheduleModelIdentifier(
        id: id
      );
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
  
  amplify_core.TemporalDateTime get startDate {
    try {
      return _startDate!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime get endDate {
    try {
      return _endDate!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get maxPassengers {
    try {
      return _maxPassengers!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get availableSlots {
    try {
      return _availableSlots!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Schedule._internal({required this.id, required tourId, required startDate, required endDate, required maxPassengers, required availableSlots, createdAt, updatedAt}): _tourId = tourId, _startDate = startDate, _endDate = endDate, _maxPassengers = maxPassengers, _availableSlots = availableSlots, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Schedule({String? id, required String tourId, required amplify_core.TemporalDateTime startDate, required amplify_core.TemporalDateTime endDate, required int maxPassengers, required int availableSlots}) {
    return Schedule._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      tourId: tourId,
      startDate: startDate,
      endDate: endDate,
      maxPassengers: maxPassengers,
      availableSlots: availableSlots);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Schedule &&
      id == other.id &&
      _tourId == other._tourId &&
      _startDate == other._startDate &&
      _endDate == other._endDate &&
      _maxPassengers == other._maxPassengers &&
      _availableSlots == other._availableSlots;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Schedule {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("tourId=" + "$_tourId" + ", ");
    buffer.write("startDate=" + (_startDate != null ? _startDate!.format() : "null") + ", ");
    buffer.write("endDate=" + (_endDate != null ? _endDate!.format() : "null") + ", ");
    buffer.write("maxPassengers=" + (_maxPassengers != null ? _maxPassengers!.toString() : "null") + ", ");
    buffer.write("availableSlots=" + (_availableSlots != null ? _availableSlots!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Schedule copyWith({String? tourId, amplify_core.TemporalDateTime? startDate, amplify_core.TemporalDateTime? endDate, int? maxPassengers, int? availableSlots}) {
    return Schedule._internal(
      id: id,
      tourId: tourId ?? this.tourId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      maxPassengers: maxPassengers ?? this.maxPassengers,
      availableSlots: availableSlots ?? this.availableSlots);
  }
  
  Schedule copyWithModelFieldValues({
    ModelFieldValue<String>? tourId,
    ModelFieldValue<amplify_core.TemporalDateTime>? startDate,
    ModelFieldValue<amplify_core.TemporalDateTime>? endDate,
    ModelFieldValue<int>? maxPassengers,
    ModelFieldValue<int>? availableSlots
  }) {
    return Schedule._internal(
      id: id,
      tourId: tourId == null ? this.tourId : tourId.value,
      startDate: startDate == null ? this.startDate : startDate.value,
      endDate: endDate == null ? this.endDate : endDate.value,
      maxPassengers: maxPassengers == null ? this.maxPassengers : maxPassengers.value,
      availableSlots: availableSlots == null ? this.availableSlots : availableSlots.value
    );
  }
  
  Schedule.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _tourId = json['tourId'],
      _startDate = json['startDate'] != null ? amplify_core.TemporalDateTime.fromString(json['startDate']) : null,
      _endDate = json['endDate'] != null ? amplify_core.TemporalDateTime.fromString(json['endDate']) : null,
      _maxPassengers = (json['maxPassengers'] as num?)?.toInt(),
      _availableSlots = (json['availableSlots'] as num?)?.toInt(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'tourId': _tourId, 'startDate': _startDate?.format(), 'endDate': _endDate?.format(), 'maxPassengers': _maxPassengers, 'availableSlots': _availableSlots, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'tourId': _tourId,
    'startDate': _startDate,
    'endDate': _endDate,
    'maxPassengers': _maxPassengers,
    'availableSlots': _availableSlots,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ScheduleModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ScheduleModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TOURID = amplify_core.QueryField(fieldName: "tourId");
  static final STARTDATE = amplify_core.QueryField(fieldName: "startDate");
  static final ENDDATE = amplify_core.QueryField(fieldName: "endDate");
  static final MAXPASSENGERS = amplify_core.QueryField(fieldName: "maxPassengers");
  static final AVAILABLESLOTS = amplify_core.QueryField(fieldName: "availableSlots");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Schedule";
    modelSchemaDefinition.pluralName = "Schedules";
    
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
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["tourId"], name: "byTour")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Schedule.TOURID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Schedule.STARTDATE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Schedule.ENDDATE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Schedule.MAXPASSENGERS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Schedule.AVAILABLESLOTS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
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

class _ScheduleModelType extends amplify_core.ModelType<Schedule> {
  const _ScheduleModelType();
  
  @override
  Schedule fromJson(Map<String, dynamic> jsonData) {
    return Schedule.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Schedule';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Schedule] in your schema.
 */
class ScheduleModelIdentifier implements amplify_core.ModelIdentifier<Schedule> {
  final String id;

  /** Create an instance of ScheduleModelIdentifier using [id] the primary key. */
  const ScheduleModelIdentifier({
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
  String toString() => 'ScheduleModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ScheduleModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}