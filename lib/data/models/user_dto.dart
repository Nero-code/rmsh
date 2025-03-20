import 'package:rmsh/data/models/base_model.dart';
import 'package:rmsh/domain/classes/user.dart';

class UserDto extends User implements BaseDTO {
  const UserDto(super.email, this.refreshToken, this.issuedAt);
  final String refreshToken;
  final DateTime issuedAt;

  @override
  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
      json['email'],
      json['refresh'],
      json['issuedAt'] != null
          ? DateTime.parse(json['issuedAt'])
          : DateTime.now());
  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'refresh': refreshToken,
        'issuedAt': issuedAt.toIso8601String()
      };
}
