import 'package:equatable/equatable.dart';
import 'package:rmsh/domain/classes/cart_item.dart';

//  Order Object toAPI
// {
//  "delivery_office":1,
//  "coupon":null,
//  "order_items":[
//     {
//         "product":1,
//         "quantity":1
//     }
//  ]
// }

class OrderEntity extends Equatable {
  final String id, deliveryOffice;
  final List<CartItem> items;
  final String? coupon, message;
  final OrderStatus status;
  final double total;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.deliveryOffice,
    required this.status,
    required this.total,
    required this.createdAt,
    this.coupon,
    this.message,
  });

  @override
  List<Object?> get props => [
        id,
        items,
        deliveryOffice,
        status,
        total,
      ];
}

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  canceled,
}
