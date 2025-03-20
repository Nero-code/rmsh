import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rmsh/core/constants/assets_names.dart';
import 'package:rmsh/main.dart';
import 'package:rmsh/presentation/dialogs/basic_dialog.dart';
import 'package:rmsh/presentation/providers/auth_state.dart';
import 'package:rmsh/presentation/views/auth_profile_screen.dart';
import 'package:rmsh/presentation/views/loading_page.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailCtl = TextEditingController();
  final codeCtl = TextEditingController();

  String email = '', code = '';

  bool isdialogActive = false, authNotDone = true;

  void checkForProfile() async {
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
              MaterialPageRoute(builder: (_) => const MainContainer()))
          : Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AuthProfileScreen())),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    // if (Provider.of<AuthState>(context).proccessDone) {
    //   // WidgetsBinding.instance
    //   //     .addPostFrameCallback((d) => Navigator.pop(context, true));
    //   Navigator.pop(context, true);
    // }
    return PopScope(
      // canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        print("PopScope  didPop: $didPop , result: $result");

        // if (!didPop) {
        //   SystemNavigator.pop();
        //   return;
        // }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.1),
                    child: const Image(
                      image: AssetImage(AssetsNames.LOGO_RED),
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child:
                        Consumer<AuthState>(builder: (context, state, child) {
                      if (state.registerFailure != null && !isdialogActive) {
                        isdialogActive = true;
                        // errorDialog(context, state.registerFailure?.msg);
                        WidgetsBinding.instance.addPostFrameCallback(
                          (duration) => showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (c) {
                              // return AlertDialog(
                              //   icon: Icon(
                              //     Icons.warning_rounded,
                              //     color: Colors.red.shade200,
                              //     size: 30,
                              //   ),
                              //   title: const Text(
                              //     "حدث خطأ!",
                              //     textDirection: TextDirection.rtl,
                              //   ),
                              //   content: Text(state.registerFailure?.msg ??
                              //       "الرجاء المحاولة مرة اخرى..."),
                              //   actions: [
                              //     ActionChip.elevated(
                              //       onPressed: () {
                              //         Provider.of<AuthState>(context,
                              //                 listen: false)
                              //             .resetFailure();
                              //         state.isdialogActive = false;
                              //         Navigator.pop(context);
                              //       },
                              //       label: const Text("حسنا"),
                              //     ),
                              //   ],
                              // );

                              return BasicDialog(
                                icon: const Icon(
                                  Icons.warning_rounded,
                                  color: Colors.red,
                                  size: 50,
                                ),
                                title: "حدث خطأ!",
                                content: state.registerFailure?.msg,
                                action: () {
                                  isdialogActive = false;
                                  Provider.of<AuthState>(context, listen: false)
                                      .resetFailure();
                                },
                              );
                            },
                          ),
                        );
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black54,
                            ),
                          ),
                          // const Divider(),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: emailCtl,
                            readOnly: state.isCodeSent,
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter,
                            ],
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              label: Text("Email"),
                              hintText: "hello.user@gmail.com",
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (state.isCodeSent)
                            TextFormField(
                              controller: codeCtl,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.key),
                                border: OutlineInputBorder(),
                                label: Text("Code"),
                                hintText: "xxx xxx",
                              ),
                            ),
                          const SizedBox(height: 30),
                          ActionChip.elevated(
                            backgroundColor: Colors.pink,
                            onPressed: () async {
                              if (state.isCodeSent) {
                                code = codeCtl.text;
                                Provider.of<AuthState>(context, listen: false)
                                    .verifyCode(
                                        emailCtl.text.trim(), codeCtl.text);
                              } else {
                                if (emailCtl.text.contains("@")) {
                                  email = emailCtl.text;
                                  Provider.of<AuthState>(context, listen: false)
                                      .verifyEmail(email.trim());
                                }
                              }
                            },
                            label: Center(
                              child: Text(
                                state.isCodeSent ? "تأكيد" : "تسجيل",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // ElevatedButton(
                          //   onPressed: () async {
                          //     if (state.isCodeSent) {
                          //       code = codeCtl.text;
                          //       Provider.of<AuthState>(context, listen: false)
                          //           .verifyCode(
                          //               emailCtl.text.trim(), codeCtl.text);
                          //     } else {
                          //       if (emailCtl.text.contains("@")) {
                          //         email = emailCtl.text;
                          //         Provider.of<AuthState>(context, listen: false)
                          //             .verifyEmail(email.trim());
                          //       }
                          //     }
                          //   },
                          //   child: Text(state.isCodeSent ? "تأكيد" : "تسجيل"),
                          // ),
                        ],
                      );
                    }),
                  ),
                ),
                Selector<AuthState, bool>(
                  selector: (context, p1) => p1.isLoading,
                  builder: (context, isLoading, child) {
                    if (isLoading) {
                      return const LoadingPage();
                    }

                    return const SizedBox();
                  },
                ),
                Selector<AuthState, bool>(
                  selector: (context, p1) => p1.proccessDone,
                  builder: (context, done, child) {
                    if (done && authNotDone) {
                      authNotDone = false;
                      print("auth proccess done, setting callback to navigate");
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => checkForProfile());
                    }

                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
