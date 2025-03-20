// import 'package:json_annotation/json_annotation.dart';
import 'package:rmsh/data/models/base_model.dart';
import 'package:rmsh/data/models/product_item_model.dart';
import 'package:rmsh/domain/classes/cart_item.dart';

part 'generated/cart_item_model.g.dart';

// @JsonSerializable()
class CartItemModel extends CartItem implements BaseDTO {
  const CartItemModel({
    required super.id,
    required super.name,
    required super.details,
    required super.count,
    required super.price,
    required super.offerPrice,
    required super.thumbnail,
  });

  @override
  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  factory CartItemModel.fromEntity(CartItem c) => CartItemModel(
      id: c.id,
      name: c.name,
      details: c.details,
      count: c.count,
      price: c.price,
      offerPrice: c.offerPrice,
      thumbnail: c.thumbnail);

  @override
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);
}
