import 'package:rmsh/data/models/base_model.dart';
import 'package:rmsh/domain/classes/delivery_office.dart';

class DeliveryOfficeModel extends DeliveryOffice implements BaseDTO {
  const DeliveryOfficeModel(super.id, super.name);

  @override
  factory DeliveryOfficeModel.fromJson(Map<String, dynamic> json) =>
      DeliveryOfficeModel(json['id'], json['office']);

  @override
  Map<String, dynamic> toJson() => {'id': id, 'office': name};
}
