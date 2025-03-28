import 'package:equatable/equatable.dart';

class DeliveryOffice extends Equatable {
  const DeliveryOffice(this.id, this.name);
  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
