import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rmsh/core/constants/constants.dart';
import 'package:rmsh/core/errors/exceptions.dart';
import 'package:rmsh/data/models/base_model.dart';
import 'package:rmsh/core/services/token_service.dart';

class ClientHelper {
  const ClientHelper({required Dio client, required TokenService tokenService})
      : _tokenService = tokenService,
        _client = client;

  final Dio _client;
  final TokenService _tokenService;
  final dataNodeInResponse = 'data';

  ///  For more custom behaivuar
  Dio get client => _client;
  TokenService get tokenService => _tokenService;

  Future<T> getHandler<T extends BaseDTO>(
      String urlPart, T Function(Map<String, dynamic> json) fromJson,
      [Map<String, String>? queryParams]) async {
    final Response<Map> res;
    try {
      res = await _client.get("$API" "$urlPart",
          queryParameters: queryParams,
          options: Options(headers: await getHeader()));
    } catch (e) {
      print("caught Exception in getHandler ${e.toString()}");
      if (e is DioException) _catchException(e);
      throw Exception(e);
    }
    if (kDebugMode) {
      print("getHandler code: ${res.statusCode}");
      print("getHandler body: ${res.data}");
    }

    return fromJson((res.data as Map)[dataNodeInResponse]);
  }

  Future<List<T>> getListHandler<T extends BaseDTO>(
      String urlPart, T Function(Map<String, dynamic>) fromJson,
      [Map<String, String>? queryParams]) async {
    print("getListHandler: ${API + urlPart}");
    final Response<Map> res;
    try {
      res = await _client.get("$API" "$urlPart",
          queryParameters: queryParams,
          options: Options(headers: await getHeader()));
    } catch (e) {
      print(e.toString());
      if (e is DioException) _catchException(e);
      throw Exception();
    }
    if (kDebugMode) {
      print("getListHandler code: ${res.statusCode}");
      // print("getListHandler body: ${res.data![dataNodeInResponse][0]}");
    }
    if ((res.data![dataNodeInResponse] as List).isEmpty) {
      throw EmptyResponseException();
    }

    final data = res.data![dataNodeInResponse] as List;
    return data.map((e) => fromJson(e)).toList();
  }

  Future<T?> postHandler<T extends BaseDTO>(
    String urlPart,
    Map<String, dynamic> body, {
    T Function(Map<String, dynamic> json)? fromJson,
    void Function(Map<String, dynamic> body)? orElse,
  }) async {
    print(API + urlPart);
    final res = await _client.post(
      "$API" "$urlPart",
      options: Options(headers: await getHeader()),
      data: body,
    );
    print(res.realUri);
    print("postHandler code: ${res.statusCode}");
    print("postHandler body: ${res.data}");

    if (res.statusCode == HttpStatus.created) {
      if (fromJson != null) {
        // return fromJson(jsonDecode(
        //     (res.data))[dataNodeInResponse]);

        return fromJson(res.data[dataNodeInResponse]);
      }
      if (orElse != null) {
        orElse(res.data);
      }
    }

    return null;
  }

  Future<void> putHandler(
    String urlPart,
    Map<String, dynamic> body,
  ) async {
    final res = await _client.put(
      "$API" "$urlPart",
      options: Options(headers: await getHeader()),
      data: body,
    );

    print("putHandler code: ${res.statusCode}");
    print("putHandler body: ${res.data}");
  }

  Future<void> deleteHandler(
    String urlPart,
    Map<String, dynamic> body,
  ) async {
    final res = await _client.delete("$API" "$urlPart",
        options: Options(headers: await getHeader()), data: body);

    print("deleteHandler code: ${res.statusCode}");
    print("deleteHandler body: ${res.data}");

    // switch (res.statusCode) {
    //   case HttpStatus.noContent:
    //     return;
    //   case HttpStatus.ok:
    //     return;
    //   case HttpStatus.created:
    //     return;
    //   case HttpStatus.badRequest:
    //     throw DuplicateActionException();
    //   case HttpStatus.notFound:
    //     throw DuplicateActionException();
    //   case HttpStatus.badGateway:
    //     throw ServerDownException();
    //   default:
    //     throw Exception(res.data);
    // }
  }

  // String mapStatusCodeToAction(http.Response res) {
  //   switch (res.statusCode) {
  //     case HttpStatus.ok:
  //       return res.data;
  //     case HttpStatus.created:
  //       return res.data;
  //     case HttpStatus.badRequest:
  //       throw DuplicateActionException();
  //     case HttpStatus.notFound:
  //       throw DuplicateActionException();
  //     case HttpStatus.badGateway:
  //       throw ServerDownException();
  //     default:
  //       throw Exception(res.data);
  //   }
  // }

  Future<Map<String, String>> getHeader() async {
    final session = await _tokenService.session;
    if (session == null) {
      throw SessionGenerationException();
    }
    return {
      // 'Content-Type': 'application/json; charset=UTF-8',
      // "charset": "utf-8",
      // "Accept-Charset": "utf-8",
      // 'Accept': 'application/json; charset=UTF-8',
      'Authorization': "Bearer ${session.accessToken}",
    };
  }
}

void _catchException(DioException res) {
  print("_catchException: ${res.message} : ${res.response?.data}");
  switch (res.response!.statusCode) {
    case HttpStatus.notFound:
      throw EmptyResponseException();
    case HttpStatus.badRequest:
      throw DuplicateActionException();
    case HttpStatus.badGateway:
      throw ServerDownException();
    default:
      throw Exception('Unknown Error');
  }
}
