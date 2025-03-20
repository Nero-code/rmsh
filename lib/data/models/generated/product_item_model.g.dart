// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../product_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductItemModel _$ProductItemModelFromJson(Map<String, dynamic> json) {
  final Map<String, dynamic> info = json['info'];
  final List<dynamic> images = json['images'];
  final List<dynamic> items = json['items'];

  return ProductItemModel(
    imgs: images.map((e) => e['image_url'] as String).toList(),
    id: info['id'].toString(),
    name: info['name'] as String,
    description: info['description'] as String,
    categoryName: info['category_name'] as String,
    thumbnail: info['thumbnail'] as String,
    itemsM: items
        .map((e) => ProductDetailsModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    price: double.parse(info['price'].toString()),
    offerPrice: double.parse(info['offer'].toString()),
  );
}

Map<String, dynamic> _$ProductItemModelToJson(ProductItemModel instance) =>
    <String, dynamic>{
      'imgs': instance.imgs,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'categoryName': instance.categoryName,
      'thumbnail': instance.thumbnail,
      'price': instance.price,
      'offerPrice': instance.offerPrice,
      'itemsM': instance.itemsM.map((e) => e.toJson()).toList(),
    };
