import 'package:equatable/equatable.dart';

class ProductInfo extends Equatable {
  final String id, name, description, categoryName, thumbnail;
  final int likes;
  final bool isLiked, isWishlist;
  final double price, offerPrice;

  const ProductInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryName,
    required this.thumbnail,
    required this.likes,
    required this.isLiked,
    required this.isWishlist,
    // required this.hasOffer,
    required this.price,
    required this.offerPrice,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        thumbnail,
        categoryName,
        likes,
        isLiked,
        isWishlist,
        // hasOffer,
        price,
        offerPrice,
      ];
}
