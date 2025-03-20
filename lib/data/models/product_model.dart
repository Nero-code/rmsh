import 'package:flutter/foundation.dart';
import 'package:rmsh/data/models/base_model.dart';
import 'package:rmsh/domain/classes/product_info.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:rmsh/domain/classes/product_item.dart';

part 'generated/product_model.g.dart';

// @JsonSerializable(explicitToJson: true)
class ProductInfoModel extends ProductInfo implements BaseDTO {
  const ProductInfoModel({
    required super.id,
    required super.name,
    required super.description,
    required super.thumbnail,
    required super.likes,
    required super.isLiked,
    required super.isWishlist,
    // required super.hasOffer,
    required super.price,
    required super.offerPrice,
    required super.categoryName,
  });

  @override
  factory ProductInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

// class ProductDetailsModel extends ProductDetails {
//   const ProductDetailsModel({
//     required super.id,
//     required super.color,
//     required super.size,
//   });

//   factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
//       ProductDetailsModel(
//         id: json['id'],
//         color: json['color'],
//         size: json['size'],
//       );

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'color': color,
//         'sizes': size,
//       };
// }
