import 'package:flutter/material.dart';
import 'package:rmsh/domain/classes/cart_item.dart';
import 'package:rmsh/domain/classes/delivery_office.dart';
import 'package:rmsh/domain/classes/order.dart';
// import 'package:rmsh/presentation/vm/cart_vm.dart';

class CheckoutDialog extends StatefulWidget {
  const CheckoutDialog({
    super.key,
    required this.total,
    required this.count,
    required this.deliveryOffices,
    required this.onOrder,
    required this.cart,
    this.error,
  });

  final int total, count;
  final List<DeliveryOffice> deliveryOffices;

  final List<CartItem> cart;
  final void Function(OrderEntity) onOrder;
  final String? error;

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  DeliveryOffice? selectedOffice;
  final couponCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        icon: const Icon(
          Icons.post_add_rounded,
          size: 40,
        ),
        scrollable: true,
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        title: const Text("اضافة طلب"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            Text(
              "عدد القطع: ${widget.count}",
              textDirection: TextDirection.rtl,
            ),
            Text(
              "الاجمالي: ${widget.total}",
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<DeliveryOffice>(
              itemHeight: 70,
              hint: const Text("مراكز التوصيل"),
              value: selectedOffice,
              items: [
                for (final i in widget.deliveryOffices)
                  DropdownMenuItem(
                    value: i,
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.57,
                      child: Text(
                        i.name,
                        textDirection: TextDirection.rtl,
                        maxLines: 2,
                      ),
                    ),
                  ),
              ],
              onChanged: (val) => setState(() => selectedOffice = val),
            ),
            const SizedBox(height: 10),
            const Text(
              "الكوبون:",
              textDirection: TextDirection.rtl,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              maxLength: 10,
              maxLines: 1,
              controller: couponCtl,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 240, 240, 240),
                hintText: "xxx xxx",
              ),
            ),
            if (widget.error != null)
              Text(
                widget.error!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
        actions: [
          ActionChip.elevated(
            label: const Text("الغاء"),
            onPressed: () => Navigator.pop(context),
          ),
          ActionChip.elevated(
            backgroundColor: Colors.orange.shade300,
            label: const Text("طلب"),
            onPressed: () {
              if (selectedOffice == null) return;
              final order = OrderEntity(
                id: "",
                items: widget.cart,
                deliveryOffice: selectedOffice!.id.toString(),
                status: OrderStatus.pending,
                total: widget.total.toDouble(),
                coupon: couponCtl.text.isEmpty ? null : couponCtl.text,
                createdAt: DateTime.now(),
              );
              widget.onOrder(order);
            },
          ),
        ],
      ),
    );
  }
}
