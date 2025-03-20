import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rmsh/data/models/product_item_model.dart';
import 'package:rmsh/domain/classes/cart_item.dart';
import 'package:rmsh/domain/classes/product_item.dart';
import 'package:rmsh/presentation/providers/cart_state.dart';
import 'package:rmsh/presentation/providers/product_details_state.dart';
import 'package:rmsh/presentation/widgets/box_botton.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final invert = const ColorFilter.matrix(<double>[
    -1,
    0,
    0,
    0,
    255,
    0,
    -1,
    0,
    0,
    255,
    0,
    0,
    -1,
    0,
    255,
    0,
    0,
    0,
    1,
    0,
  ]);

  int selectedColor = 0;
  ProductDetails? selectedItem;

  // final p = fakeProductsList[2];

  void addPostFrameCallback(void Function() func) =>
      WidgetsBinding.instance.addPostFrameCallback((_) => func());

  @override
  void initState() {
    addPostFrameCallback(() {
      Provider.of<ProductDetailsState>(context, listen: false)
          .getProduct(widget.productId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductDetailsState>(context, listen: false);
    final cartProvider = Provider.of<CartState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: Consumer2<ProductDetailsState, CartState>(
          builder: (context, productState, cartState, child) {
        if (kDebugMode) {
          print(productState.toString());
        }
        if (productState.isLoading || productState.product == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (productState.productFailure != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(productState.productFailure!.msg ??
                    "حدث خطأ الرجاء اعادة المحاولة"),
                IconButton(
                  onPressed: () {
                    provider.getProduct(widget.productId);
                  },
                  icon: const Icon(Icons.replay_sharp),
                ),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).width,
                child: CarouselView(
                  padding: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onTap: null,
                  itemExtent: MediaQuery.sizeOf(context).width,
                  itemSnapping: true,
                  children: [
                    if (productState.product!.imgs.isEmpty)
                      CachedNetworkImage(
                        imageUrl: productState.product!.thumbnail,
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.broken_image_outlined, size: 50),
                        ),
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                    for (var img in productState.product!.imgs)
                      CachedNetworkImage(
                        imageUrl: img,
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.broken_image_outlined, size: 50),
                        ),
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          productState.product!.name,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          productState.product!.price.toString(),
                          style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      productState.product!.description,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    const Divider(),
                    //
                    //  C O L O R S
                    //
                    Wrap(
                      textDirection: TextDirection.rtl,
                      children: [
                        for (var i in productState.itemsByColor.keys) ...[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: BoxBotton(
                              width: 30,
                              height: 30,
                              isCircle: true,
                              background: Color(i),
                              border: i == selectedColor
                                  ? Border.all(width: 2.0)
                                  : null,
                              focusedBorder: null,
                              child: ColorFiltered(
                                colorFilter: invert,
                                child: cartState.containsColor(i)
                                    ? Icon(
                                        Icons.download_done_rounded,
                                        size: 12,
                                        color: Color(i),
                                      )
                                    : null,
                              ),
                              onTap: () {
                                selectedColor = i;
                                selectedItem = null;
                                setState(() {});
                              },
                            ),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    //
                    //    S I Z E S
                    //
                    Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      children: [
                        for (var item
                            in productState.itemsByColor[selectedColor] ??
                                <ProductDetailsModel>[]) ...[
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: BoxBotton(
                              border: Border.all(
                                  width: item == selectedItem ? 2 : 0.5),
                              borderRadius: 5,
                              background: cartState.contains(
                                      productState.product!.id, item)
                                  ? Colors.blueGrey.shade300
                                  : null,
                              onTap: () {
                                selectedItem = item;
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 2.0),
                                child: Text(item.size),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),

                    const SizedBox(height: 30),
                    Row(
                      children: [
                        FilledButton.icon(
                          onPressed: selectedItem != null &&
                                  !cartProvider.contains(
                                      productState.product!.id, selectedItem!)
                              ? () {
                                  cartProvider.addToCart(
                                    CartItem(
                                      id: productState.product!.id,
                                      details: selectedItem!,
                                      name: productState.product!.name,
                                      price: productState.product!.price,
                                      offerPrice:
                                          productState.product!.offerPrice,
                                      thumbnail:
                                          productState.product!.thumbnail,
                                    ),
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.add),
                          label: const Text("اضافة للسلة"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
