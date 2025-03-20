import 'package:flutter/material.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/commands/product_usecases.dart';
import 'package:rmsh/presentation/vm/product_vm.dart';

class WishlistState with ChangeNotifier {
  WishlistState(this._productUsecases);

  final ProductUsecases _productUsecases;

  List<ProductViewModel> products = [];

  bool isLoading = false;

  void getWishList() async {
    isLoading = true;
    notifyListeners();

    final either = await _productUsecases.getWishList();
    either.fold(
      (l) => likeAndWishError = l,
      (r) => products = r.map((e) => ProductViewModel(e)).toList(),
    );

    isLoading = false;
    notifyListeners();
  }

  Failure? likeAndWishError;
  void likeOrUnlike(int index, bool like) async {
    // isLoading = true;
    products[index].isLiked = like;
    notifyListeners();

    final either = await _productUsecases.like(products[index].p.id, like);
    either.fold(
      (failure) => likeAndWishError = failure,
      (success) => products[index].isLiked = like,
    );

    // isLoading = false;
    notifyListeners();
  }

  Future<void> addOrRemoveWishlist(int index, bool add) async {
    // isLoading = true;
    products[index].isWishlist = add;
    notifyListeners();

    final either =
        await _productUsecases.addOrRemoveWishlist(products[index].p.id, add);
    either.fold(
      (failure) => likeAndWishError = failure,
      (success) => products[index].isWishlist = add,
    );

    // isLoading = false;
    notifyListeners();
  }
}
