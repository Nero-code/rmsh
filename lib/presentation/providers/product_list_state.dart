import 'package:flutter/material.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/commands/product_usecases.dart';
import 'package:rmsh/presentation/vm/product_vm.dart';

class ProductListState with ChangeNotifier {
  ProductListState(this._usecases);
  final ProductUsecases _usecases;

  bool _isSearchMode = false;
  bool get isSearchMode => _isSearchMode;
  set searchMode(bool val) {
    _isSearchMode = val;
    notifyListeners();
  }

  List<ProductViewModel> products = [];

  bool isLoading = false, hasReachedTheEnd = false, initialized = false;
  Failure? getAllError;
  Future<void> getAllProducts([String? category, String? searchQuery]) async {
    print("getAllProducts $category : $searchQuery");
    initialized = true;
    isLoading = true;
    getAllError = null;
    refreshFailure = null;
    hasReachedTheEnd = loadingMore = hasRequested = false;
    notifyListeners();

    final either = await _usecases.getAllProducts(category, searchQuery);
    either.fold(
      (failure) {
        if (failure is EmptyResponseFailure) {
          hasReachedTheEnd = true;
          hasRequested = true;
          products = [];
        }
        getAllError = failure;
      },
      (success) {
        print("success Products: $success");
        print(success.map((p) => ProductViewModel(p)).toList());

        products = success.map((p) => ProductViewModel(p)).toList();

        print("Product State: $products");

        return;
      },
    );

    isLoading = false;
    notifyListeners();
  }

  Failure? refreshFailure;
  Future<void> refresh([String? category, String? searchQuery]) async {
    print("getAllProducts $category : $searchQuery");
    getAllError = null;
    refreshFailure = null;
    hasReachedTheEnd = loadingMore = hasRequested = false;
    notifyListeners();

    final either = await _usecases.getAllProducts(category, searchQuery);
    either.fold(
      (failure) {
        refreshFailure = failure;
        notifyListeners();
      },
      (success) {
        print("success Products: $success");
        print(success.map((p) => ProductViewModel(p)).toList());

        products = success.map((p) => ProductViewModel(p)).toList();

        print("Product State: $products");

        return;
      },
    );
    notifyListeners();
  }

  bool hasRequested = false, loadingMore = false;
  Failure? loadMoreError;
  Future<void> loadMore([String? category, String? searchQuery]) async {
    if (hasReachedTheEnd) return;

    loadingMore = true;
    hasRequested = true;
    notifyListeners();

    final either = await _usecases.loadMore(category, searchQuery);
    either.fold(
      (failure) {
        print("loadMore failure: ${failure.runtimeType}");
        if (failure is EmptyResponseFailure) {
          hasReachedTheEnd = true;
        }
        loadMoreError = failure;
      },
      (success) => products.addAll(success.map((p) => ProductViewModel(p))),
    );

    loadingMore = false;
    hasRequested = false;
    notifyListeners();
  }

  List<String> categories = [];
  Failure? categoriesFailure;
  Future<void> getAllCategories() async {
    isLoading = true;
    notifyListeners();
    categoriesFailure = null;
    print("getAllCategories in state");
    final either = await _usecases.getAllCategories();
    either.fold(
      (l) => categoriesFailure = l,
      (r) => categories = r,
    );

    isLoading = false;
    notifyListeners();
  }

  Failure? likeAndWishError;
  void likeOrUnlike(int index, bool like) async {
    // isLoading = true;

    products[index].isLiked = like;
    // like ? ++products[index].likes : --products[index].likes;
    notifyListeners();
    final either = await _usecases.like(products[index].p.id, like);
    either.fold(
      (failure) {
        // like ? --products[index].likes : ++products[index].likes;
        likeAndWishError = failure;
      },
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
        await _usecases.addOrRemoveWishlist(products[index].p.id, add);
    either.fold(
      (failure) => likeAndWishError = failure,
      (success) => products[index].isWishlist = add,
    );

    // isLoading = false;
    notifyListeners();
  }

  @override
  String toString() {
    return """
    \n--- ProductListState \n
    isLoading --------- = $isLoading
    getAllError ------- = $getAllError
    hasReachedTheEnd -- = $hasReachedTheEnd
    loadingMore ------- = $loadingMore
    hasRequested ------ = $hasRequested
    """;
  }
}
