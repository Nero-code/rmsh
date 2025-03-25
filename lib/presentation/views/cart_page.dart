import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/core/utils/widgets_binding.dart';
import 'package:rmsh/domain/classes/cart_item.dart';
import 'package:rmsh/presentation/dialogs/checkout_dialog.dart';
import 'package:rmsh/presentation/providers/cart_state.dart';
import 'package:rmsh/presentation/widgets/cart_widget.dart';
import 'package:rmsh/presentation/views/loading_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartState>(context, listen: false);

    return Consumer<CartState>(builder: (context, state, child) {
      if (state.items.isEmpty) {
        return const Center(
          child: Icon(
            Icons.add_shopping_cart_outlined,
            color: Colors.grey,
            size: 50,
          ),
        );
      }
      return Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 40),
            children: [
              for (int i = 0; i < state.items.length; i++) ...[
                CartWidget(
                  item: state.items[i],
                  removeItem: () => state.removeFromCart(i),
                  reduce: (val) => state.changeItemCount(i, val),
                  add: (val) => state.changeItemCount(i, val),
                ),
                if (i != 4) Divider(color: Colors.grey.shade300),
              ]
            ],
          ),
          Positioned(
            bottom: 10.0,
            width: MediaQuery.sizeOf(context).width,
            child: Center(
              child: FilledButton(
                onPressed: () async {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (c) => CheckoutDialog(
                        total: provider.total,
                        count: provider.items.map((e) => e.count).reduce(
                              (value, element) => value + element,
                            ),
                        cart: provider.items
                            .map((vm) => CartItem(
                                  id: vm.c.id,
                                  name: vm.c.name,
                                  details: vm.c.details,
                                  price: vm.c.price,
                                  offerPrice: vm.c.offerPrice,
                                  thumbnail: vm.c.thumbnail,
                                  count: vm.count,
                                ))
                            .toList(),
                        deliveryOffices: provider.offices,
                        onOrder: (order) {
                          provider.checkout(order);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }
                },
                child: Selector<CartState, int>(
                    selector: (context, state) => state.total,
                    builder: (context, total, child) {
                      return Text(
                        "اضافة: $total",
                        textDirection: TextDirection.rtl,
                      );
                    }),
              ),
            ),
          ),
          Selector<CartState, Failure?>(
              selector: (context, state) => state.checkoutError,
              builder: (context, failure, child) {
                if (failure is CouponNotValidFailure) {
                  addPostFrameCallback(() {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "الكوبون خاطئ",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        // duration: Durations.extralong4,
                      ),
                    );
                    showDialog(
                      context: context,
                      builder: (c) => CheckoutDialog(
                        total: provider.total,
                        count: provider.items.map((e) => e.count).reduce(
                              (value, element) => value + element,
                            ),
                        cart: provider.items
                            .map((vm) => CartItem(
                                  id: vm.c.id,
                                  name: vm.c.name,
                                  details: vm.c.details,
                                  price: vm.c.price,
                                  offerPrice: vm.c.offerPrice,
                                  thumbnail: vm.c.thumbnail,
                                  count: vm.count,
                                ))
                            .toList(),
                        deliveryOffices: provider.offices,
                        onOrder: (order) {
                          provider.checkout(order);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  });
                } else if (failure != null) {
                  addPostFrameCallback(() {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "حدث خطأ: ${failure.msg}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        // duration: Durations.extralong4,
                      ),
                    );
                  });
                }
                return const SizedBox();
              }),
          Selector<CartState, bool>(
            selector: (context, state) => state.isLoading,
            builder: (context, isLoading, child) {
              if (isLoading) {
                return const LoadingPage();
              }
              return const SizedBox();
            },
          ),
        ],
      );
    });
  }
}
