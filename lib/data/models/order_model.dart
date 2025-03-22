import 'package:rmsh/data/models/base_model.dart';
import 'package:rmsh/data/models/cart_item_model.dart';
import 'package:rmsh/domain/classes/order.dart';

import 'package:json_annotation/json_annotation.dart';
part 'generated/order_model.g.dart';

// @JsonSerializable(explicitToJson: true)
class OrderModel extends OrderEntity implements BaseDTO {
  final List<CartItemModel> cartItems;
  const OrderModel({
    required super.id,
    required this.cartItems,
    required super.deliveryOffice,
    required super.status,
    required super.total,
    required super.createdAt,
    required super.message,
    super.coupon,
  }) : super(items: cartItems);

  @override
  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  factory OrderModel.fromEntity(OrderEntity e) => OrderModel(
        id: e.id,
        cartItems: e.items.map((i) => CartItemModel.fromEntity(i)).toList(),
        coupon: e.coupon,
        deliveryOffice: e.deliveryOffice,
        status: e.status,
        total: e.total,
        createdAt: e.createdAt,
        message: e.message,
      );

  @override
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
