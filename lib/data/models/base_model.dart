abstract class BaseDTO {
  factory BaseDTO.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();

  Map<String, dynamic> toJson();
}
