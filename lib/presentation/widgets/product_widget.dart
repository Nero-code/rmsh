import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:rmsh/domain/classes/product_info.dart';
import 'package:rmsh/presentation/vm/product_vm.dart';
import 'package:rmsh/presentation/widgets/box_botton.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    super.key,
    required this.likesNum,
    required this.product,
    required this.likeUnlike,
    required this.wishlist,
    this.onPressed,
    this.isLiked = false,
    this.isWishlist = false,
  });
  final ProductViewModel product;
  final VoidCallback? onPressed;
  final bool isLiked, isWishlist;
  final int likesNum;

  final void Function(bool isActive) likeUnlike, wishlist;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      margin: const EdgeInsets.only(bottom: 10),
      // padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        // color: const Color.fromARGB(255, 236, 238, 241),
        // color: Theme.of(context).colorScheme.surfaceContainer,
        color: const Color.fromARGB(108, 241, 241, 241),
        borderRadius: BorderRadius.circular(15),
        // border: product.p.offerPrice > 0
        //     ? Border.all(color: Colors.amber, width: 3.0)
        //     : null,
      ),
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: product.p.thumbnail,
                      imageBuilder: (context, imageProvider) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image(image: imageProvider),
                        ),
                      ),
                      placeholder: (context, url) => const AspectRatio(
                        aspectRatio: 1,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => const AspectRatio(
                        aspectRatio: 1,
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Color.fromARGB(255, 190, 105, 100),
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.p.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          Text(
                            product.p.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  //  WISHLIST BTN
                                  BoxBotton(
                                    width: 30,
                                    height: 30,
                                    isCircle: false,
                                    borderRadius: 10,
                                    onTap: () => wishlist(product.isWishlist),
                                    child: product.isWishlist
                                        ? const Icon(
                                            Icons.bookmark,
                                            size: 25,
                                            color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.bookmark_border,
                                            size: 25,
                                            color: Colors.grey,
                                          ),
                                  ),
                                  //  LIKE BTN
                                  BoxBotton(
                                    width: 30,
                                    height: 30,
                                    isCircle: false,
                                    borderRadius: 10,
                                    onTap: () => likeUnlike(product.isLiked),
                                    child: product.isLiked
                                        ? const Icon(
                                            Icons.favorite,
                                            size: 25,
                                            color: Colors.red,
                                          )
                                        : const Icon(
                                            Icons.favorite_outline,
                                            size: 25,
                                            color: Colors.grey,
                                          ),
                                  ),
                                  Text(
                                    "${product.p.likes + (product.isLiked ? 1 : 0)}",
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.black54),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (product.p.offerPrice > 0)
                                    Text(
                                      "SYP ${product.p.price}",
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 10,
                                        color: Colors.red,
                                        // color: Colors.blueGrey,
                                      ),
                                    ),
                                  Text(
                                    "SYP ${product.p.price - product.p.offerPrice}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: product.p.offerPrice > 0
                                          ? Colors.green
                                          : Colors.blueGrey,
                                      // color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
