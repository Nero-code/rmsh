import 'package:rmsh/core/constants/constants.dart';
import 'package:rmsh/data/models/order_model.dart';
import 'package:rmsh/core/services/client_helper.dart';

abstract class OrdersRemoteSource {
  //  ORDERS
  Future<List<OrderModel>> getAllOrders();
  Future<bool> cancelOrder(String orderId);
}

class OrdersRemoteSourceImpl implements OrdersRemoteSource {
  const OrdersRemoteSourceImpl({required ClientHelper clientHelper})
      : _clientHelper = clientHelper;
  final ClientHelper _clientHelper;

  @override
  Future<List<OrderModel>> getAllOrders() async {
    final orders = await _clientHelper.getListHandler(
        HTTP_ORDERS_GET, (json) => OrderModel.fromJson(json));
    print(orders);
    return orders;
  }

  @override
  Future<bool> cancelOrder(String orderId) async {
    await _clientHelper.deleteHandler("$HTTP_ORDERS_DELETE" "$orderId/", {});
    return true;
  }
}
