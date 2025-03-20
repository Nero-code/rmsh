import 'package:equatable/equatable.dart';

class ProductItem {
  const ProductItem({
    required this.imgs,
    required this.id,
    required this.name,
    required this.description,
    required this.categoryName,
    required this.thumbnail,
    required this.items,
    required this.price,
    required this.offerPrice,
  });
  final List<String> imgs;
  final String id, name, description, categoryName, thumbnail;
  final List<ProductDetails> items;
  final double price, offerPrice;
}

class ProductDetails extends Equatable {
  final String id;
  final int color;
  final String size;

  const ProductDetails({
    required this.id,
    required this.color,
    required this.size,
  });

  @override
  List<Object?> get props => [id, color, size];
}
