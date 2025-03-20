import 'dart:convert';

import 'package:rmsh/core/constants/constants.dart';
import 'package:rmsh/core/errors/exceptions.dart';
import 'package:rmsh/data/models/delivery_office_model.dart';
import 'package:rmsh/data/models/order_model.dart';
import 'package:rmsh/data/models/profile_dto.dart';
import 'package:rmsh/data/models/user_dto.dart';
import 'package:rmsh/core/services/client_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Deprecated("This contract is obsolute and is to be deleted")
abstract class RemoteSource {
  //  CART
  // Future<bool> validateProducts(List<CartItem> list);
  Future<bool> chackout(OrderModel order); // Migration DONE

  //  ORDERS
  Future<List<OrderModel>> getAllOrders(); // MIGRATION DONE
  Future<bool> cancelOrder(String orderId); // MIGRATION DONE
  Future<List<DeliveryOfficeModel>> getDeliveryOffices();

  //  AUTH
  Future<bool> logout(); // Migration DONE
  Future<bool> isLogged();
  Future<bool> register(String email); // Migration DONE
  Future<UserDto> verifyCode(String email, String code); // Migration DONE
  Future<UserDto> getUser(); // Migration DONE
  Future<bool> saveUser(UserDto user); // Migration DONE

  //  PROFILE
  // Future<bool> hasProfile(); // MIGRATION DONE
  Future<ProfileDto> getProfile(); // MIGRATION DONE
  Future<void> submitProfile(ProfileDto p, bool isCreate); // MIGRATION DONE
}

@Deprecated("This contract is obsolute and is to be deleted")
class RemoteSourceImpl implements RemoteSource {
  const RemoteSourceImpl(this._storage, this._clientHelper);
  final SharedPreferences _storage;
  final ClientHelper _clientHelper;

  @override
  Future<List<OrderModel>> getAllOrders() async {
    final orders = await _clientHelper.getListHandler(
        HTTP_ORDERS_GET, (json) => OrderModel.fromJson(json));

    return orders;
  }

  @override
  Future<bool> cancelOrder(String orderId) async {
    await _clientHelper
        .deleteHandler(HTTP_ORDERS_DELETE, {'order_id': orderId});
    return true;
  }

  @override
  Future<List<DeliveryOfficeModel>> getDeliveryOffices() async {
    return await _clientHelper.getListHandler(
        HTTP_DELIVERY_OFFICES, (json) => DeliveryOfficeModel.fromJson(json));
  }

  @override
  Future<bool> chackout(OrderModel order) async {
    await _clientHelper.postHandler(HTTP_ORDERS_CREATE, order.toJson());
    return true;
  }

  @override
  Future<bool> logout() async {
    return await _storage.clear();
  }

  @override
  Future<bool> isLogged() async {
    print("remoteSource isLogged");
    return await _clientHelper.tokenService.ensureRefreshTokenIsValid();
  }

  @override
  Future<UserDto> getUser() async {
    if (_storage.containsKey('refresh')) {
      final email = _storage.getString('email') as String;
      final refresh = _storage.getString('refresh') as String;
      final issuedAt = DateTime.parse(_storage.getString('issuedAt') as String);
      return UserDto(
        email,
        refresh,
        issuedAt,
      );
    }
    throw EmptyResponseException();
  }

  @override
  Future<bool> saveUser(UserDto user) async {
    await _storage.setString('email', user.email);
    await _storage.setString('refresh', user.refreshToken);
    await _storage.setString('issuedAt', user.issuedAt.toIso8601String());
    return true;
  }

  /// Return value Means `NeedProfile?`
  @override
  Future<bool> register(String email) async {
    final res = await _clientHelper.client.post(
      "$API" "$HTTP_REGISTER",
      data: {'email': email},
    );

    print("register code: ${res.statusCode}");
    print("register body: ${res.data}");
    if (res.statusCode == 201) {
      return true;
    } else if (res.statusCode == 200) {
      return false;
    }
    throw EmailRegistrationException();
  }

  /// {
  ///
  /// > "message": "User registered",
  ///
  /// > "refresh": "t.o.k.e.n",
  ///
  /// > "access": "t.o.k.e.n"
  ///
  /// }
  @override
  Future<UserDto> verifyCode(String email, String code) async {
    final res = await _clientHelper.client.post(
      "$API" "$HTTP_VERIFY_CODE",
      data: {'email': email, 'otp_code': code},
    );

    print("verifyCode code: ${res.statusCode}");
    print("verifyCode body: ${res.data}");
    if (res.statusCode == 201 || res.statusCode == 200) {
      final decodedRes = jsonDecode(res.data);
      final userDto = UserDto.fromJson(
        Map<String, dynamic>.from(decodedRes)..addAll({'email': email}),
      );
      await _clientHelper.tokenService
          .setLoginSession(decodedRes['refresh'], decodedRes['access']);
      return userDto;
    } else if (res.statusCode == 400) {
      throw CodeErrorException();
    }
    throw Exception();
  }

  @override
  Future<ProfileDto> getProfile() async {
    return await _clientHelper.getHandler(
      HTTP_PROFILE,
      (json) => ProfileDto.fromJson(json),
    );
  }

  @override
  Future<void> submitProfile(ProfileDto p, bool isCreate) async {
    print("PROFILE IS CREATE => $isCreate");
    if (isCreate) {
      await _clientHelper.postHandler(HTTP_PROFILE, p.toJson());
    } else {
      await _clientHelper.putHandler(HTTP_PROFILE, p.toJson());
    }
  }

  // @override
  // Future<bool> hasProfile() async {}
}
