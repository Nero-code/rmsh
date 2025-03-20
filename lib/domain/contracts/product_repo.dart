import 'package:dartz/dartz.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/classes/product_info.dart';
import 'package:rmsh/domain/classes/product_item.dart';

abstract class ProductRepo {
  /// [getAllProducts] can override all other search props using the filter argument:
  ///   * normal search queries
  ///   * speciel filters [`All`, `clothes`, `etc...`]
  Future<Either<Failure, List<ProductInfo>>> getAllProducts(
      [String? category, String? query]);
  Future<Either<Failure, List<ProductInfo>>> loadMore(
      [String? category, String? query]);
  Future<Either<Failure, ProductItem>> getProductDetails(String id);
  Future<Either<Failure, List<ProductInfo>>> getWishList();
  // Future<Either<Failure, List<Product>>> searchByName(String query);
  // Future<Either<Failure, List<Product>>> searchByCategory(String category);
  Future<Either<Failure, List<String>>> getAllCategories();

  Future<Either<Failure, Unit>> addToWishlist(String productId);
  Future<Either<Failure, Unit>> removefromWishlist(String productId);

  Future<Either<Failure, Unit>> like(String productId);
  Future<Either<Failure, Unit>> unLike(String productId);
}
