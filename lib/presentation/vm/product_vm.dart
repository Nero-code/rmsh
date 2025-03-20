import 'package:rmsh/domain/classes/product_info.dart';

class ProductViewModel {
  ProductViewModel(this.p)
      : isLiked = p.isLiked,
        isWishlist = p.isWishlist
  // ,likes = p.likes
  ;

  final ProductInfo p;
  bool isLiked, isWishlist;
  // int likes;
}
