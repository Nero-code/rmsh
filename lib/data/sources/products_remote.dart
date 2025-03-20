import 'package:flutter/foundation.dart';
import 'package:rmsh/core/constants/constants.dart';
import 'package:rmsh/data/models/categories_model.dart';
import 'package:rmsh/data/models/product_item_model.dart';
import 'package:rmsh/data/models/product_model.dart';
import 'package:rmsh/domain/classes/product_item.dart';
import 'package:rmsh/core/services/client_helper.dart';

class ProductsRemoteSource {
  const ProductsRemoteSource(this._clientHelper);

  final ClientHelper _clientHelper;

  Future<List<ProductInfoModel>> getAllProducts(
    String category,
    String search,
  ) async {
    final query = {'category': category, 'keyword': search};
    if (kDebugMode) {
      print("getAllProducts: remote: $query");
    }
    return await _clientHelper.getListHandler(
      HTTP_PRODUCTS,
      (json) => ProductInfoModel.fromJson(json),
      query,
    );
  }

  Future<List<ProductInfoModel>> loadMore(
    int page, [
    String category = '',
    String search = '',
  ]) async {
    final query = {'page': "$page", 'category': category, 'keyword': search};
    return await _clientHelper.getListHandler(
      HTTP_PRODUCTS,
      (json) => ProductInfoModel.fromJson(json),
      query,
    );
  }

  Future<ProductItem> getProductDetails(String id) async {
    return await _clientHelper.getHandler<ProductItemModel>(
        "$HTTP_PRODUCTS/$id/", (json) => ProductItemModel.fromJson(json));
  }

  Future<List<CategoriesModel>> getAllCategories() async {
    print("getAllCategories in remote source");
    return await _clientHelper.getListHandler<CategoriesModel>(
      HTTP_CATEGORIES,
      (json) => CategoriesModel.fromJson(json),
    );
  }

  Future<List<ProductInfoModel>> getWishList() async {
    final res = await _clientHelper.getListHandler(
        HTTP_WISHLIST, (json) => ProductInfoModel.fromJson(json));

    print("wishlist: $res");
    return res;
  }

  Future<void> addToWishlist(String productId) async {
    await _clientHelper
        .postHandler(HTTP_PRODUCTS + productId + HTTP_ADD_WISHLIST, {});
  }

  Future<void> removefromWishlist(String productId) async {
    await _clientHelper
        .deleteHandler(HTTP_PRODUCTS + productId + HTTP_REMOVE_WISHLIST, {});
  }

  Future<void> like(String productId) async {
    await _clientHelper.postHandler(HTTP_PRODUCTS + productId + HTTP_LIKE, {});
  }

  Future<void> unLike(String productId) async {
    await _clientHelper
        .deleteHandler(HTTP_PRODUCTS + productId + HTTP_UNLIKE, {});
  }
}
