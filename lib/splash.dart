import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rmsh/core/constants/assets_names.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/main.dart';
import 'package:rmsh/presentation/dialogs/basic_dialog.dart';
import 'package:rmsh/presentation/providers/auth_state.dart';
import 'package:rmsh/presentation/views/auth_screen.dart';
import 'package:rmsh/presentation/views/auth_profile_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> initialize(BuildContext context) async {
    print('initialize Started');

    final isLogged =
        await Provider.of<AuthState>(context, listen: false).isLogged();
    if (context.mounted &&
        Provider.of<AuthState>(context, listen: false).loginCheckFailure
            is OfflineFaliure) {
      WidgetsBinding.instance.addPostFrameCallback((d) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (c) => BasicDialog(
            icon: Icon(
              Icons.wifi_off,
              size: 50,
              color: Colors.blueGrey.shade300,
            ),
            title: "لا يوجد اتصال بالانترنت",
            content: "الرجاء التأكد من جودة الاتصال واعادة المحاولة لاحقا",
            action: () => SystemNavigator.pop(animated: true),
          ),
        );
      });
      return;
    }

    if (!isLogged) {
      print('Not Logged');
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => const AuthScreen()),
        );
        return;
        // print("after Auth $res");
      }
    }
    if (context.mounted) {
      final either =
          await Provider.of<AuthState>(context, listen: false).hasProfile();
      either.fold(
        (l) => WidgetsBinding.instance.addPostFrameCallback(
          (_) => showDialog(
            context: context,
            builder: (context) => BasicDialog(
              title: "خطأ بالاتصال",
              content: l.msg,
              action: SystemNavigator.pop,
            ),
          ),
        ),
        (hasProfile) => hasProfile
            ? Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MainContainer()),
              )
            : Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const AuthProfileScreen()),
              ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((d) => initialize(context));

    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage(AssetsNames.LOGO_RED),
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
