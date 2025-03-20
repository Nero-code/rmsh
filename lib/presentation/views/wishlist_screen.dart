import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rmsh/presentation/providers/wishlist_state.dart';
import 'package:rmsh/presentation/widgets/product_widget.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  void addPostFrameCallback(void Function() callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) => callback());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WishlistState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<WishlistState>(builder: (context, state, child) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.likeAndWishError != null) {
          return Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(state.likeAndWishError?.msg ?? "حدث خطأ"),
              IconButton(
                onPressed: () {
                  provider.getWishList();
                },
                icon: const Icon(Icons.replay_sharp),
              ),
            ],
          ));
        }
        return RefreshIndicator(
          onRefresh: () async =>
              addPostFrameCallback(() => provider.getWishList()),
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10),
            itemCount: state.products.length,
            itemBuilder: (context, i) {
              return ProductWidget(
                likesNum: 100,
                product: state.products[i],
                likeUnlike: (isActive) => addPostFrameCallback(
                    () => provider.likeOrUnlike(i, !isActive)),
                wishlist: (isActive) => addPostFrameCallback(
                    () => provider.addOrRemoveWishlist(i, !isActive)),
                onPressed: () {},
                isWishlist: true,
                isLiked: i % 3 == 0,
              );
            },
          ),
        );
      }),
    );
  }
}
