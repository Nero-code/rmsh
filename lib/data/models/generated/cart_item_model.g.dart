// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      details: ProductDetailsModel.fromJson(
          {"color": json['color'], "size": json['size']}),
      count: int.parse(json['quantity'].toString()),
      price: double.parse(json['price'].toString()),
      offerPrice: double.parse(json['offer'].toString()),
      thumbnail: json['thumbnail'] as String,
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'details': instance.details,
      'count': instance.count,
      'price': instance.price,
      'offerPrice': instance.offerPrice,
      'thumbnail': instance.thumbnail,
    };
