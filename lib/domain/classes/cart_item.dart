import 'package:rmsh/domain/classes/product_item.dart';

class CartItem {
  final String id, name /**, color, size*/;
  final ProductDetails details;
  final int count;
  final double price, offerPrice;

  final String thumbnail;

  const CartItem({
    required this.id,
    required this.name,
    required this.details,
    required this.price,
    required this.offerPrice,
    required this.thumbnail,
    this.count = 1,
  });
}
