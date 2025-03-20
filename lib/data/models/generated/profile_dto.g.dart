// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) {
  return ProfileDto(
    name: json['name'] as String,
    phoneNum: json['phone'] as String,
    // birthDate: DateFormat("YYYY-MM-DD").parse(json['birthdate'] as String),
    birthDate: DateTime.parse(json['birthdate'] as String),
    isMale: (json['gender'] as String) == "Male",
  );
}

Map<String, dynamic> _$ProfileDtoToJson(ProfileDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phoneNum,
      // 'birthdate': DateFormat("YYYY-MM-DD").format(instance.birthDate),
      'birthdate': instance.birthDate.toIso8601String(),
      'gender': instance.isMale ? "Male" : "Female",
    };
