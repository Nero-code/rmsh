// import 'package:json_annotation/json_annotation.dart';
import 'package:rmsh/data/models/base_model.dart';
import 'package:rmsh/domain/classes/profile.dart';

part 'generated/profile_dto.g.dart';

// @JsonSerializable()
class ProfileDto extends Profile implements BaseDTO {
  const ProfileDto({
    required super.name,
    required super.phoneNum,
    required super.birthDate,
    required super.isMale,
  });
  @override
  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  factory ProfileDto.fromEntity(Profile p) => ProfileDto(
        name: p.name,
        phoneNum: p.phoneNum,
        birthDate: p.birthDate,
        isMale: p.isMale,
      );
  @override
  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);
}
