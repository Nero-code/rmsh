import 'package:flutter/material.dart';
import 'package:rmsh/domain/classes/order.dart';
import 'package:rmsh/presentation/widgets/box_botton.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget(
      {super.key,
      required this.onPressed,
      required this.onCencel,
      required this.entity});

  final void Function()? onPressed, onCencel;
  final OrderEntity entity;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Theme.of(context).colorScheme.surfaceContainer,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mapStatusToWidget(entity.status),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_pin,
                          size: 20,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 10.0),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.75,
                          child: Text(
                            entity.deliveryOffice,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.shopping_cart,
                          size: 20,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          "${entity.items.length} قطع/ة",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    if (entity.coupon != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.local_offer,
                            size: 20,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            "${entity.coupon}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    Divider(color: Colors.grey.shade300),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // mapStatusToWidget(entity.status),
                        Text(
                          "${entity.total} ليرة",
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (entity.status == OrderStatus.pending)
          Positioned(
            top: 5.0,
            left: 5.0,
            child: BoxBotton(
              width: 20,
              height: 20,
              isCircle: true,
              background: Colors.red.shade300,
              onTap: onCencel,
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 15,
              ),
            ),
          )
      ],
    );
  }
}

Widget mapStatusToWidget(OrderStatus status) {
  final String text;
  final Color background;
  switch (status) {
    case OrderStatus.pending:
      text = 'معلق';
      background = Colors.grey;
      break;
    case OrderStatus.processing:
      text = 'قيد المعالجة';
      background = Colors.yellow.shade700;
      break;
    case OrderStatus.shipped:
      text = 'تم الشحن';
      background = Colors.blue;
      break;
    case OrderStatus.delivered:
      text = 'تم الاستلام';
      background = Colors.green;
      break;
    case OrderStatus.canceled:
      text = 'تم الالغاء';
      background = Colors.red;
      break;
    default:
      text = 'معلق';
      background = Colors.grey;
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: background,
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
