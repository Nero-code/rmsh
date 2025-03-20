import 'package:flutter/material.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/classes/product_item.dart';
import 'package:rmsh/domain/commands/product_usecases.dart';

class ProductDetailsState with ChangeNotifier {
  ProductDetailsState(this._productUsecases);
  final ProductUsecases _productUsecases;
  bool isLoading = false;

  ProductItem? product;
  Failure? productFailure;
  Map<int, List<ProductDetails>> itemsByColor = {};

  void getProduct(String id) async {
    print("getProduct initialilzed");
    isLoading = true;
    productFailure = null;
    itemsByColor = {};

    notifyListeners();

    final either = await _productUsecases.getProductDetails(id);
    either.fold(
      (l) => productFailure = l,
      (r) {
        product = r;
        seperateByColor(r);
      },
    );

    isLoading = false;
    notifyListeners();
  }

  List<String> getitemSizes(int color) {
    return itemsByColor[color]!.map((e) => e.size).toList();
  }

  void seperateByColor(ProductItem p) {
    final colors = p.items.map((e) => e.color).toSet();
    for (var c in colors) {
      final items = p.items.where((e) => e.color == c).toList();
      itemsByColor.addAll({c: items});
    }
  }

  @override
  String toString() {
    return """
    \n< ProductDetailsState >
    hasProduct: ${product != null}
    itemsByColor: $itemsByColor
    
    """;
  }
}
