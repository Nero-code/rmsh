import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/core/utils/widgets_binding.dart';
import 'package:rmsh/presentation/dialogs/basic_dialog.dart';
import 'package:rmsh/presentation/providers/orders_state.dart';
import 'package:rmsh/presentation/views/order_details_screen.dart';
import 'package:rmsh/presentation/views/loading_page.dart';
import 'package:rmsh/presentation/widgets/order_widget.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrdersState>(context, listen: false);
    return RefreshIndicator(
      onRefresh: provider.refreshOrders,
      child: Consumer<OrdersState>(builder: (context, state, child) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.getOrdersError != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.getOrdersError?.msg ?? "حدث خطأ في التحميل"),
                IconButton(
                  onPressed: () {
                    provider.getOrders();
                  },
                  icon: const Icon(Icons.replay_sharp),
                ),
              ],
            ),
          );
        }
        if (state.orders.isEmpty) {
          return const Center(
            child: Icon(
              Icons.hourglass_empty_rounded,
              color: Colors.grey,
              size: 50,
            ),
          );
        }
        return Stack(
          children: [
            ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40),
              children: [
                for (int i = 0; i < state.orders.length; i++) ...[
                  OrderWidget(
                    entity: state.orders[i],
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) =>
                            OrderDetailsScreen(order: state.orders[i]),
                      ),
                    ),
                    onCencel: () => provider.cancelOrder(i),
                  ),
                ],
              ],
            ),
            Selector<OrdersState, Failure?>(
              selector: (context, state) => state.cancelOrderError,
              builder: (context, failure, child) {
                if (failure != null) {
                  addPostFrameCallback(() => showDialog(
                        context: context,
                        builder: (context) => BasicDialog(
                          title: "فشل الغاء الطلب",
                          content:
                              "لم نتمكن من الغاء الطلب, الرجاء المحاولة مرة اخرى لاحقا",
                          action: () => provider.resetCancelError(),
                        ),
                      ));
                }
                return const SizedBox();
              },
            ),
            Selector<OrdersState, bool>(
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
      }),
    );
  }
}
