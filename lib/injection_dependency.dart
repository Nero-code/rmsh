import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
// import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rmsh/data/repositories/auth_repo_imple.dart';
import 'package:rmsh/data/repositories/cart_repo_imple.dart';
import 'package:rmsh/data/repositories/orders_repo_imple.dart';
import 'package:rmsh/data/repositories/product_repo_imple.dart';
import 'package:rmsh/data/repositories/profile_repo_imple.dart';
import 'package:rmsh/data/sources/auth_remote.dart';
import 'package:rmsh/data/sources/cart_remote.dart';
import 'package:rmsh/data/sources/orders_remote.dart';
import 'package:rmsh/data/sources/products_remote.dart';
import 'package:rmsh/data/sources/profile_remote.dart';
import 'package:rmsh/domain/commands/auth_usecases.dart';
import 'package:rmsh/domain/commands/cart_usecases.dart';
import 'package:rmsh/domain/commands/orders_usecases.dart';
import 'package:rmsh/domain/commands/product_usecases.dart';
import 'package:rmsh/domain/commands/profile_usecases.dart';
import 'package:rmsh/domain/contracts/auth_repo.dart';
import 'package:rmsh/domain/contracts/cart_repo.dart';
import 'package:rmsh/domain/contracts/orders_repo.dart';
import 'package:rmsh/domain/contracts/product_repo.dart';
import 'package:rmsh/domain/contracts/profile_repo.dart';
import 'package:rmsh/core/services/client_helper.dart';
import 'package:rmsh/core/services/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.I;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  final icc = InternetConnectionChecker.I;
  final client = Dio();
  // client.interceptors.add(InterceptorsWrapper(
  //   onError: (res, handler) {
  //     // handler.reject(EmptyResponseException());
  //     // if (res.response == null) {
  //     //   throw Exception(res.error);
  //     // }
  //     // switch (res.response!.statusCode) {
  //     //   case HttpStatus.notFound:
  //     //   handler.resolve(Response(requestOptions: RequestOptions(),statusCode: ));
  //     //     return;
  //     //     throw EmptyResponseException();
  //     //   case HttpStatus.badRequest:
  //     //     throw DuplicateActionException();
  //     //   case HttpStatus.badGateway:
  //     //     throw ServerDownException();
  //     //   default:
  //     //     throw Exception('Unknown Error');
  //     // }
  //   },
  // ));

  sl.registerLazySingleton<Dio>(() => client);
  sl.registerLazySingleton<InternetConnectionChecker>(() => icc);
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  sl.registerLazySingleton(
    () => TokenService(storage: sl(), client: sl()),
  );
  sl.registerLazySingleton(
    () => ClientHelper(client: sl(), tokenService: sl()),
  );

  // final ns = NotificationService();
  // await ns.init();
  // sl.registerLazySingleton<NotificationService>(() => ns);

  //  S O U R C E S
  sl.registerLazySingleton<AuthRemoteSource>(
      () => AuthRemoteSourceImpl(sl(), sl()));
  sl.registerLazySingleton<ProfileRemoteSource>(
      () => ProfileRemoteSourceImpl(clientHelper: sl()));
  sl.registerLazySingleton<CartRemoteSource>(
      () => CartRemoteSourceImpl(clientHelper: sl()));
  sl.registerLazySingleton<OrdersRemoteSource>(
      () => OrdersRemoteSourceImpl(clientHelper: sl()));
  sl.registerLazySingleton<ProductsRemoteSource>(
      () => ProductsRemoteSource(sl()));

  //  R E P O S I T O R I E S
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImple(
        remoteSource: sl(),
        internet: sl(),
      ));
  sl.registerLazySingleton<ProfileRepo>(() => ProfileRepoImple(
        sl(),
        sl(),
      ));
  sl.registerLazySingleton<ProductRepo>(() => ProductRepoImple(
        sl(),
        sl(),
      ));
  sl.registerLazySingleton<CartRepo>(() => CartRepoImple(
        sl(),
        sl(),
      ));
  sl.registerLazySingleton<OrdersRepo>(() => OrdersRepoImple(sl()));

  //  U S E C A S E S
  sl.registerLazySingleton<AuthUsecases>(() => AuthUsecases(sl()));
  sl.registerLazySingleton<ProfileUsecases>(() => ProfileUsecases(sl()));
  sl.registerLazySingleton<ProductUsecases>(() => ProductUsecases(sl()));
  sl.registerLazySingleton<CartUsecases>(() => CartUsecases(sl()));
  sl.registerLazySingleton<OrdersUsecases>(() => OrdersUsecases(sl()));
}
