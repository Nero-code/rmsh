import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rmsh/presentation/providers/auth_state.dart';
import 'package:rmsh/presentation/providers/cart_state.dart';
import 'package:rmsh/presentation/providers/orders_state.dart';
import 'package:rmsh/presentation/providers/product_details_state.dart';
import 'package:rmsh/presentation/providers/product_list_state.dart';
import 'package:rmsh/presentation/providers/profile_state.dart';
import 'package:rmsh/presentation/providers/settings_state.dart';
import 'package:rmsh/presentation/providers/wishlist_state.dart';
import 'package:rmsh/presentation/views/cart_page.dart';
import 'package:rmsh/presentation/views/products_page.dart';
import 'package:rmsh/presentation/views/orders_page.dart';
import 'package:rmsh/splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'injection_dependency.dart';

Future<void> notificationHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Background Service");
    print(message.toMap());
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // final nservice = NotificationService().init();
  await init();

  FirebaseMessaging.onBackgroundMessage(notificationHandler);
  FirebaseMessaging.onMessage.listen((e) {
    print("Foreground Notification");
    print(e.toMap());
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          if (kDebugMode) {
            print("---------- Settings STATE CREATED ---------");
          }
          return SettingsState(prefs: sl())..getSavedLang();
        }),
        ChangeNotifierProvider(create: (_) {
          if (kDebugMode) {
            print("---------- AUTH STATE CREATED ---------");
          }
          return AuthState(sl(), sl());
        }),
        ChangeNotifierProvider(create: (_) {
          if (kDebugMode) {
            print("---------- PROFILE STATE CREATED ---------");
          }
          return ProfileState(sl());
        }),
        ChangeNotifierProvider(create: (_) {
          if (kDebugMode) {
            print("---------- PRODUCT STATE CREATED ---------");
          }
          return ProductListState(sl())
            ..getAllCategories()
            ..getAllProducts();
        }),
        ChangeNotifierProvider(create: (_) {
          if (kDebugMode) {
            print("---------- WISHLIST STATE CREATED ---------");
          }
          return WishlistState(sl())..getWishList();
        }),
        ChangeNotifierProvider(create: (_) {
          if (kDebugMode) {
            print("---------- PRODUCT DETAILS STATE CREATED ---------");
          }
          return ProductDetailsState(sl());
        }),
        ChangeNotifierProvider(create: (_) {
          if (kDebugMode) {
            print("---------- CART STATE CREATED ---------");
          }
          return CartState(sl())..getDeliveryOffices();
        }),
        ChangeNotifierProvider(create: (_) {
          if (kDebugMode) {
            print("---------- ORDERS STATE CREATED ---------");
          }
          return OrdersState(sl())..getOrders();
        }),
      ],
      child: Consumer<SettingsState>(
        builder: (context, state, child) {
          return MaterialApp(
            title: 'رمش',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: state.curretnLang,
            debugShowCheckedModeBanner: kDebugMode,
            theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0xFF560606)),
              useMaterial3: true,
            ),
            home: child,
          );
        },
        child: const SplashScreen(),
      ),
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;

  void onDestinationChanged(int index) {
    setState(() {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness:
            index == 0 ? Brightness.light : Brightness.dark,
      ));
      _selectedIndex = index;
    });
  }

  // @override
  // void dispose() {
  //   sl.get<NotificationService>().dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      body: [
        const ProductsPage(),
        const CartPage(),
        const OrdersPage(),
      ][_selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Theme.of(context).colorScheme.primary,
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: Icon(
                Icons.home,
                color: Colors.grey.shade200,
              ),
              label: local.home),
          NavigationDestination(
              icon: const Icon(Icons.shopping_cart_outlined),
              selectedIcon: Icon(
                Icons.shopping_cart,
                color: Colors.grey.shade200,
              ),
              label: local.cart),
          NavigationDestination(
              icon: const Icon(Icons.sticky_note_2_outlined),
              selectedIcon: Icon(
                Icons.sticky_note_2_sharp,
                color: Colors.grey.shade200,
              ),
              label: local.orders),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: onDestinationChanged,
      ),
    );
  }
}
