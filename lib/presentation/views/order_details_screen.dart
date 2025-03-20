import 'package:flutter/material.dart';
import 'package:rmsh/domain/classes/order.dart';
import 'package:rmsh/presentation/widgets/order_item_widget.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            for (final i in order.items) OrderItemWidget(item: i),
          ],
        ),
      ),
    );
  }
}
