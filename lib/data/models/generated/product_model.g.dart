// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductInfoModel _$ProductModelFromJson(Map<String, dynamic> json) {
  if (kDebugMode) {
    // print("id ${json['id'].runtimeType}");
    // print("name ${json['name'].runtimeType}");
    // print("description ${json['description'].runtimeType}");
    // print("categoryName ${json['category_name'].runtimeType}");
    // print("thumbnail ${json['thumbnail'].runtimeType}");
    // print("likes ${json['likes_count'].runtimeType}");
    // print("isLiked ${json['liked'].runtimeType}");
    // print("isWishlist ${json['wishlisted'].runtimeType}");
    // print("price ${json['price'].runtimeType}");
    // print("offerPrice ${json['offer'].runtimeType}");
  }

  return ProductInfoModel(
    id: json['id'].toString(),
    name: json['name'] as String,
    description: json['description'] as String,
    categoryName: json['category_name'] as String,
    thumbnail: json['thumbnail'] as String,
    likes: (json['likes_count'] as num).toInt(),
    isLiked: json['liked'] as bool,
    isWishlist: json['wishlisted'] as bool,
    // hasOffer: json['hasOffer'] as bool,
    price: double.parse(json['price'] as String),
    offerPrice: double.parse(json['offer'] as String),
  );
}

Map<String, dynamic> _$ProductModelToJson(ProductInfoModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'category_name': instance.categoryName,
      'thumbnail': instance.thumbnail,
      'likes': instance.likes,
      'liked': instance.isLiked,
      'wishlisted': instance.isWishlist,
      // 'hasOffer': instance.hasOffer,
      'price': instance.price,
      'offer': instance.offerPrice,
    };
