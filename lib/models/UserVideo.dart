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


/** This is an auto generated class representing the UserVideo type in your schema. */
class UserVideo extends amplify_core.Model {
  static const classType = const _UserVideoModelType();
  final String id;
  final String? _userEmail;
  final String? _videoUrl;
  final String? _caption;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserVideoModelIdentifier get modelIdentifier {
      return UserVideoModelIdentifier(
        id: id
      );
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
  
  String get videoUrl {
    try {
      return _videoUrl!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get caption {
    return _caption;
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
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const UserVideo._internal({required this.id, required userEmail, required videoUrl, caption, required createdAt, updatedAt}): _userEmail = userEmail, _videoUrl = videoUrl, _caption = caption, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory UserVideo({String? id, required String userEmail, required String videoUrl, String? caption, required amplify_core.TemporalDateTime createdAt}) {
    return UserVideo._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      userEmail: userEmail,
      videoUrl: videoUrl,
      caption: caption,
      createdAt: createdAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserVideo &&
      id == other.id &&
      _userEmail == other._userEmail &&
      _videoUrl == other._videoUrl &&
      _caption == other._caption &&
      _createdAt == other._createdAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("UserVideo {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userEmail=" + "$_userEmail" + ", ");
    buffer.write("videoUrl=" + "$_videoUrl" + ", ");
    buffer.write("caption=" + "$_caption" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  UserVideo copyWith({String? userEmail, String? videoUrl, String? caption, amplify_core.TemporalDateTime? createdAt}) {
    return UserVideo._internal(
      id: id,
      userEmail: userEmail ?? this.userEmail,
      videoUrl: videoUrl ?? this.videoUrl,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt);
  }
  
  UserVideo copyWithModelFieldValues({
    ModelFieldValue<String>? userEmail,
    ModelFieldValue<String>? videoUrl,
    ModelFieldValue<String?>? caption,
    ModelFieldValue<amplify_core.TemporalDateTime>? createdAt
  }) {
    return UserVideo._internal(
      id: id,
      userEmail: userEmail == null ? this.userEmail : userEmail.value,
      videoUrl: videoUrl == null ? this.videoUrl : videoUrl.value,
      caption: caption == null ? this.caption : caption.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value
    );
  }
  
  UserVideo.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _userEmail = json['userEmail'],
      _videoUrl = json['videoUrl'],
      _caption = json['caption'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'userEmail': _userEmail, 'videoUrl': _videoUrl, 'caption': _caption, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'userEmail': _userEmail,
    'videoUrl': _videoUrl,
    'caption': _caption,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<UserVideoModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserVideoModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USEREMAIL = amplify_core.QueryField(fieldName: "userEmail");
  static final VIDEOURL = amplify_core.QueryField(fieldName: "videoUrl");
  static final CAPTION = amplify_core.QueryField(fieldName: "caption");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserVideo";
    modelSchemaDefinition.pluralName = "UserVideos";
    
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
      amplify_core.ModelIndex(fields: const ["userEmail"], name: "byUserEmail")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserVideo.USEREMAIL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserVideo.VIDEOURL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserVideo.CAPTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserVideo.CREATEDAT,
      isRequired: true,
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

class _UserVideoModelType extends amplify_core.ModelType<UserVideo> {
  const _UserVideoModelType();
  
  @override
  UserVideo fromJson(Map<String, dynamic> jsonData) {
    return UserVideo.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'UserVideo';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [UserVideo] in your schema.
 */
class UserVideoModelIdentifier implements amplify_core.ModelIdentifier<UserVideo> {
  final String id;

  /** Create an instance of UserVideoModelIdentifier using [id] the primary key. */
  const UserVideoModelIdentifier({
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
  String toString() => 'UserVideoModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserVideoModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}