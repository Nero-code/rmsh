// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'].toString(),
      cartItems: (json['order_items'] as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      deliveryOffice: json['delivery_office'] as String,
      coupon: json['coupon'] as String?,
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
      total: double.parse(json['total'].toString()),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      // 'id': instance.id,
      'delivery_office': instance.deliveryOffice,
      'coupon': instance.coupon,
      // 'status': _$OrderStatusEnumMap[instance.status]!,
      // 'total': instance.total,
      // 'created_at': instance.createdAt.toIso8601String(),
      'order_items': instance.cartItems
          .map((e) => {"product": e.details.id, "quantity": e.count})
          .toList(),
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'P',
  OrderStatus.processing: 'PR',
  OrderStatus.shipped: 'S',
  OrderStatus.delivered: 'D',
  OrderStatus.canceled: 'C',
};
