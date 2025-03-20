import 'package:rmsh/core/constants/constants.dart';
import 'package:rmsh/data/models/delivery_office_model.dart';
import 'package:rmsh/data/models/order_model.dart';
import 'package:rmsh/core/services/client_helper.dart';

abstract class CartRemoteSource {
  //  CART
  // Future<bool> validateProducts(List<CartItem> list);
  Future<bool> chackout(OrderModel order);
  Future<List<DeliveryOfficeModel>> getDeliveryOffices();
}

class CartRemoteSourceImpl implements CartRemoteSource {
  const CartRemoteSourceImpl({required ClientHelper clientHelper})
      : _clientHelper = clientHelper;
  final ClientHelper _clientHelper;

  @override
  Future<bool> chackout(OrderModel order) async {
    print(order.toJson());
    await _clientHelper.postHandler(HTTP_ORDERS_CREATE, order.toJson());
    return true;
  }

  @override
  Future<List<DeliveryOfficeModel>> getDeliveryOffices() async {
    return await _clientHelper.getListHandler(
        HTTP_DELIVERY_OFFICES, (json) => DeliveryOfficeModel.fromJson(json));
  }
}
