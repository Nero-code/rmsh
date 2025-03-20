import 'package:rmsh/data/models/base_model.dart';

class CategoriesModel implements BaseDTO {
  const CategoriesModel(this.name);
  final String name;

  @override
  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(json['name']);

  @override
  Map<String, dynamic> toJson() => {'name': name};
}
