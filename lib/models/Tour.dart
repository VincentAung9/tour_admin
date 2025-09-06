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


/** This is an auto generated class representing the Tour type in your schema. */
class Tour extends amplify_core.Model {
  static const classType = const _TourModelType();
  final String id;
  final String? _title;
  final String? _location;
  final String? _description;
  final String? _imageUrl;
  final List<String>? _galleryImages;
  final String? _passengers;
  final String? _season;
  final double? _rating;
  final String? _category;
  final List<String>? _tags;
  final List<Plan>? _plans;
  final List<Day>? _days;
  final List<Info>? _additionalInfo;
  final TourGuide? _guide;
  final List<Schedule>? _schedules;
  final List<Review>? _reviews;
  final String? _createdBy;
  final amplify_core.TemporalDateTime? _createdAt;
  final String? _badge;
  final MeetingPoint? _meetingPoint;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  TourModelIdentifier get modelIdentifier {
      return TourModelIdentifier(
        id: id
      );
  }
  
  String get title {
    try {
      return _title!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get location {
    try {
      return _location!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get description {
    try {
      return _description!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get imageUrl {
    try {
      return _imageUrl!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String>? get galleryImages {
    return _galleryImages;
  }
  
  String get passengers {
    try {
      return _passengers!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get season {
    try {
      return _season!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get rating {
    try {
      return _rating!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get category {
    try {
      return _category!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String> get tags {
    try {
      return _tags!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<Plan> get plans {
    try {
      return _plans!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<Day> get days {
    try {
      return _days!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<Info>? get additionalInfo {
    return _additionalInfo;
  }
  
  TourGuide? get guide {
    return _guide;
  }
  
  List<Schedule>? get schedules {
    return _schedules;
  }
  
  List<Review>? get reviews {
    return _reviews;
  }
  
  String get createdBy {
    try {
      return _createdBy!;
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
  
  String get badge {
    try {
      return _badge!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  MeetingPoint? get meetingPoint {
    return _meetingPoint;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Tour._internal({required this.id, required title, required location, required description, required imageUrl, galleryImages, required passengers, required season, required rating, required category, required tags, required plans, required days, additionalInfo, guide, schedules, reviews, required createdBy, required createdAt, required badge, meetingPoint, updatedAt}): _title = title, _location = location, _description = description, _imageUrl = imageUrl, _galleryImages = galleryImages, _passengers = passengers, _season = season, _rating = rating, _category = category, _tags = tags, _plans = plans, _days = days, _additionalInfo = additionalInfo, _guide = guide, _schedules = schedules, _reviews = reviews, _createdBy = createdBy, _createdAt = createdAt, _badge = badge, _meetingPoint = meetingPoint, _updatedAt = updatedAt;
  
  factory Tour({String? id, required String title, required String location, required String description, required String imageUrl, List<String>? galleryImages, required String passengers, required String season, required double rating, required String category, required List<String> tags, required List<Plan> plans, required List<Day> days, List<Info>? additionalInfo, TourGuide? guide, List<Schedule>? schedules, List<Review>? reviews, required String createdBy, required amplify_core.TemporalDateTime createdAt, required String badge, MeetingPoint? meetingPoint}) {
    return Tour._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      title: title,
      location: location,
      description: description,
      imageUrl: imageUrl,
      galleryImages: galleryImages != null ? List<String>.unmodifiable(galleryImages) : galleryImages,
      passengers: passengers,
      season: season,
      rating: rating,
      category: category,
      tags: tags != null ? List<String>.unmodifiable(tags) : tags,
      plans: plans != null ? List<Plan>.unmodifiable(plans) : plans,
      days: days != null ? List<Day>.unmodifiable(days) : days,
      additionalInfo: additionalInfo != null ? List<Info>.unmodifiable(additionalInfo) : additionalInfo,
      guide: guide,
      schedules: schedules != null ? List<Schedule>.unmodifiable(schedules) : schedules,
      reviews: reviews != null ? List<Review>.unmodifiable(reviews) : reviews,
      createdBy: createdBy,
      createdAt: createdAt,
      badge: badge,
      meetingPoint: meetingPoint);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Tour &&
      id == other.id &&
      _title == other._title &&
      _location == other._location &&
      _description == other._description &&
      _imageUrl == other._imageUrl &&
      DeepCollectionEquality().equals(_galleryImages, other._galleryImages) &&
      _passengers == other._passengers &&
      _season == other._season &&
      _rating == other._rating &&
      _category == other._category &&
      DeepCollectionEquality().equals(_tags, other._tags) &&
      DeepCollectionEquality().equals(_plans, other._plans) &&
      DeepCollectionEquality().equals(_days, other._days) &&
      DeepCollectionEquality().equals(_additionalInfo, other._additionalInfo) &&
      _guide == other._guide &&
      DeepCollectionEquality().equals(_schedules, other._schedules) &&
      DeepCollectionEquality().equals(_reviews, other._reviews) &&
      _createdBy == other._createdBy &&
      _createdAt == other._createdAt &&
      _badge == other._badge &&
      _meetingPoint == other._meetingPoint;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Tour {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("location=" + "$_location" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("imageUrl=" + "$_imageUrl" + ", ");
    buffer.write("galleryImages=" + (_galleryImages != null ? _galleryImages!.toString() : "null") + ", ");
    buffer.write("passengers=" + "$_passengers" + ", ");
    buffer.write("season=" + "$_season" + ", ");
    buffer.write("rating=" + (_rating != null ? _rating!.toString() : "null") + ", ");
    buffer.write("category=" + "$_category" + ", ");
    buffer.write("tags=" + (_tags != null ? _tags!.toString() : "null") + ", ");
    buffer.write("plans=" + (_plans != null ? _plans!.toString() : "null") + ", ");
    buffer.write("days=" + (_days != null ? _days!.toString() : "null") + ", ");
    buffer.write("additionalInfo=" + (_additionalInfo != null ? _additionalInfo!.toString() : "null") + ", ");
    buffer.write("guide=" + (_guide != null ? _guide!.toString() : "null") + ", ");
    buffer.write("createdBy=" + "$_createdBy" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("badge=" + "$_badge" + ", ");
    buffer.write("meetingPoint=" + (_meetingPoint != null ? _meetingPoint!.toString() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Tour copyWith({String? title, String? location, String? description, String? imageUrl, List<String>? galleryImages, String? passengers, String? season, double? rating, String? category, List<String>? tags, List<Plan>? plans, List<Day>? days, List<Info>? additionalInfo, TourGuide? guide, List<Schedule>? schedules, List<Review>? reviews, String? createdBy, amplify_core.TemporalDateTime? createdAt, String? badge, MeetingPoint? meetingPoint}) {
    return Tour._internal(
      id: id,
      title: title ?? this.title,
      location: location ?? this.location,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      galleryImages: galleryImages ?? this.galleryImages,
      passengers: passengers ?? this.passengers,
      season: season ?? this.season,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      plans: plans ?? this.plans,
      days: days ?? this.days,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      guide: guide ?? this.guide,
      schedules: schedules ?? this.schedules,
      reviews: reviews ?? this.reviews,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      badge: badge ?? this.badge,
      meetingPoint: meetingPoint ?? this.meetingPoint);
  }
  
  Tour copyWithModelFieldValues({
    ModelFieldValue<String>? title,
    ModelFieldValue<String>? location,
    ModelFieldValue<String>? description,
    ModelFieldValue<String>? imageUrl,
    ModelFieldValue<List<String>>? galleryImages,
    ModelFieldValue<String>? passengers,
    ModelFieldValue<String>? season,
    ModelFieldValue<double>? rating,
    ModelFieldValue<String>? category,
    ModelFieldValue<List<String>>? tags,
    ModelFieldValue<List<Plan>>? plans,
    ModelFieldValue<List<Day>>? days,
    ModelFieldValue<List<Info>>? additionalInfo,
    ModelFieldValue<TourGuide?>? guide,
    ModelFieldValue<List<Schedule>?>? schedules,
    ModelFieldValue<List<Review>?>? reviews,
    ModelFieldValue<String>? createdBy,
    ModelFieldValue<amplify_core.TemporalDateTime>? createdAt,
    ModelFieldValue<String>? badge,
    ModelFieldValue<MeetingPoint?>? meetingPoint
  }) {
    return Tour._internal(
      id: id,
      title: title == null ? this.title : title.value,
      location: location == null ? this.location : location.value,
      description: description == null ? this.description : description.value,
      imageUrl: imageUrl == null ? this.imageUrl : imageUrl.value,
      galleryImages: galleryImages == null ? this.galleryImages : galleryImages.value,
      passengers: passengers == null ? this.passengers : passengers.value,
      season: season == null ? this.season : season.value,
      rating: rating == null ? this.rating : rating.value,
      category: category == null ? this.category : category.value,
      tags: tags == null ? this.tags : tags.value,
      plans: plans == null ? this.plans : plans.value,
      days: days == null ? this.days : days.value,
      additionalInfo: additionalInfo == null ? this.additionalInfo : additionalInfo.value,
      guide: guide == null ? this.guide : guide.value,
      schedules: schedules == null ? this.schedules : schedules.value,
      reviews: reviews == null ? this.reviews : reviews.value,
      createdBy: createdBy == null ? this.createdBy : createdBy.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      badge: badge == null ? this.badge : badge.value,
      meetingPoint: meetingPoint == null ? this.meetingPoint : meetingPoint.value
    );
  }
  
  Tour.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _title = json['title'],
      _location = json['location'],
      _description = json['description'],
      _imageUrl = json['imageUrl'],
      _galleryImages = json['galleryImages']?.cast<String>(),
      _passengers = json['passengers'],
      _season = json['season'],
      _rating = (json['rating'] as num?)?.toDouble(),
      _category = json['category'],
      _tags = json['tags']?.cast<String>(),
      _plans = json['plans'] is List
        ? (json['plans'] as List)
          .where((e) => e != null)
          .map((e) => Plan.fromJson(new Map<String, dynamic>.from(e['serializedData'] ?? e)))
          .toList()
        : null,
      _days = json['days'] is List
        ? (json['days'] as List)
          .where((e) => e != null)
          .map((e) => Day.fromJson(new Map<String, dynamic>.from(e['serializedData'] ?? e)))
          .toList()
        : null,
      _additionalInfo = json['additionalInfo'] is List
        ? (json['additionalInfo'] as List)
          .where((e) => e != null)
          .map((e) => Info.fromJson(new Map<String, dynamic>.from(e['serializedData'] ?? e)))
          .toList()
        : null,
      _guide = json['guide'] != null
          ? json['guide']['serializedData'] != null
              ? TourGuide.fromJson(new Map<String, dynamic>.from(json['guide']['serializedData']))
              : TourGuide.fromJson(new Map<String, dynamic>.from(json['guide']))
        : null,
      _schedules = json['schedules']  is Map
        ? (json['schedules']['items'] is List
          ? (json['schedules']['items'] as List)
              .where((e) => e != null)
              .map((e) => Schedule.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['schedules'] is List
          ? (json['schedules'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Schedule.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _reviews = json['reviews']  is Map
        ? (json['reviews']['items'] is List
          ? (json['reviews']['items'] as List)
              .where((e) => e != null)
              .map((e) => Review.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['reviews'] is List
          ? (json['reviews'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Review.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdBy = json['createdBy'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _badge = json['badge'],
      _meetingPoint = json['meetingPoint'] != null
          ? json['meetingPoint']['serializedData'] != null
              ? MeetingPoint.fromJson(new Map<String, dynamic>.from(json['meetingPoint']['serializedData']))
              : MeetingPoint.fromJson(new Map<String, dynamic>.from(json['meetingPoint']))
        : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'title': _title, 'location': _location, 'description': _description, 'imageUrl': _imageUrl, 'galleryImages': _galleryImages, 'passengers': _passengers, 'season': _season, 'rating': _rating, 'category': _category, 'tags': _tags, 'plans': _plans?.map((Plan? e) => e?.toJson()).toList(), 'days': _days?.map((Day? e) => e?.toJson()).toList(), 'additionalInfo': _additionalInfo?.map((Info? e) => e?.toJson()).toList(), 'guide': _guide?.toJson(), 'schedules': _schedules?.map((Schedule? e) => e?.toJson()).toList(), 'reviews': _reviews?.map((Review? e) => e?.toJson()).toList(), 'createdBy': _createdBy, 'createdAt': _createdAt?.format(), 'badge': _badge, 'meetingPoint': _meetingPoint?.toJson(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'title': _title,
    'location': _location,
    'description': _description,
    'imageUrl': _imageUrl,
    'galleryImages': _galleryImages,
    'passengers': _passengers,
    'season': _season,
    'rating': _rating,
    'category': _category,
    'tags': _tags,
    'plans': _plans,
    'days': _days,
    'additionalInfo': _additionalInfo,
    'guide': _guide,
    'schedules': _schedules,
    'reviews': _reviews,
    'createdBy': _createdBy,
    'createdAt': _createdAt,
    'badge': _badge,
    'meetingPoint': _meetingPoint,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<TourModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<TourModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final LOCATION = amplify_core.QueryField(fieldName: "location");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final IMAGEURL = amplify_core.QueryField(fieldName: "imageUrl");
  static final GALLERYIMAGES = amplify_core.QueryField(fieldName: "galleryImages");
  static final PASSENGERS = amplify_core.QueryField(fieldName: "passengers");
  static final SEASON = amplify_core.QueryField(fieldName: "season");
  static final RATING = amplify_core.QueryField(fieldName: "rating");
  static final CATEGORY = amplify_core.QueryField(fieldName: "category");
  static final TAGS = amplify_core.QueryField(fieldName: "tags");
  static final PLANS = amplify_core.QueryField(fieldName: "plans");
  static final DAYS = amplify_core.QueryField(fieldName: "days");
  static final ADDITIONALINFO = amplify_core.QueryField(fieldName: "additionalInfo");
  static final GUIDE = amplify_core.QueryField(fieldName: "guide");
  static final SCHEDULES = amplify_core.QueryField(
    fieldName: "schedules",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Schedule'));
  static final REVIEWS = amplify_core.QueryField(
    fieldName: "reviews",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Review'));
  static final CREATEDBY = amplify_core.QueryField(fieldName: "createdBy");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final BADGE = amplify_core.QueryField(fieldName: "badge");
  static final MEETINGPOINT = amplify_core.QueryField(fieldName: "meetingPoint");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Tour";
    modelSchemaDefinition.pluralName = "Tours";
    
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
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tour.TITLE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tour.LOCATION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tour.DESCRIPTION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tour.IMAGEURL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tour.GALLERYIMAGES,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tour.PASSENGERS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tour.SEASON,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tour.RATING,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tour.CATEGORY,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tour.TAGS,
      isRequired: true,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
      fieldName: 'plans',
      isRequired: true,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.embeddedCollection, ofCustomTypeName: 'Plan')
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
      fieldName: 'days',
      isRequired: true,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.embeddedCollection, ofCustomTypeName: 'Day')
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
      fieldName: 'additionalInfo',
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.embeddedCollection, ofCustomTypeName: 'Info')
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
      fieldName: 'guide',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.embedded, ofCustomTypeName: 'TourGuide')
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Tour.SCHEDULES,
      isRequired: false,
      ofModelName: 'Schedule',
      associatedKey: Schedule.TOURID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Tour.REVIEWS,
      isRequired: false,
      ofModelName: 'Review',
      associatedKey: Review.TOURID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tour.CREATEDBY,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tour.CREATEDAT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Tour.BADGE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
      fieldName: 'meetingPoint',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.embedded, ofCustomTypeName: 'MeetingPoint')
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _TourModelType extends amplify_core.ModelType<Tour> {
  const _TourModelType();
  
  @override
  Tour fromJson(Map<String, dynamic> jsonData) {
    return Tour.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Tour';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Tour] in your schema.
 */
class TourModelIdentifier implements amplify_core.ModelIdentifier<Tour> {
  final String id;

  /** Create an instance of TourModelIdentifier using [id] the primary key. */
  const TourModelIdentifier({
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
  String toString() => 'TourModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is TourModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}