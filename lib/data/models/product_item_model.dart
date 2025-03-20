// import 'package:json_annotation/json_annotation.dart';
import 'package:rmsh/data/models/base_model.dart';
import 'package:rmsh/domain/classes/product_item.dart';

part 'generated/product_item_model.g.dart';

// @JsonSerializable(explicitToJson: true)
class ProductItemModel extends ProductItem implements BaseDTO {
  final List<ProductDetailsModel> itemsM;

  const ProductItemModel({
    required super.imgs,
    required super.id,
    required super.name,
    required super.description,
    required super.categoryName,
    required super.thumbnail,
    required this.itemsM,
    // required super.hasOffer,
    required super.price,
    required super.offerPrice,
  }) : super(items: itemsM);

  @override
  factory ProductItemModel.fromJson(Map<String, dynamic> json) =>
      _$ProductItemModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProductItemModelToJson(this);
}

class ProductDetailsModel extends ProductDetails {
  const ProductDetailsModel({
    required super.id,
    required super.color,
    required super.size,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailsModel(
        id: json['id'].toString(),
        color: int.parse((json['color'] as String).replaceFirst(r'#', r'0xFF')),
        size: json['size'] as String,
      );

  Map<String, dynamic> toJson() => {'id': id};
}
