import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/classes/profile.dart';
import 'package:rmsh/main.dart';
import 'package:rmsh/presentation/dialogs/basic_dialog.dart';
import 'package:rmsh/presentation/providers/profile_state.dart';
import 'package:rmsh/presentation/views/loading_page.dart';

class AuthProfileScreen extends StatefulWidget {
  const AuthProfileScreen({super.key});

  @override
  State<AuthProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<AuthProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isDialogNotActive = true;

  final nameCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  DateTime? birthDate;
  bool? isMale;

  @override
  void dispose() {
    nameCtl.dispose();
    phoneCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("الحساب")),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "الاسم",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    TextFormField(
                      controller: nameCtl,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "الاسم الثلاثي",
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: const TextStyle(color: Colors.grey),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "الرجاء تعبئة الحقل";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "رقم الهاتف",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    TextFormField(
                      controller: phoneCtl,
                      textDirection: TextDirection.rtl,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        // for below version 2 use this
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        // for version 2 and greater youcan also use this
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "0987654321",
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: const TextStyle(color: Colors.grey),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                      maxLength: 10,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "الرجاء تعبئة الحقل";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilterChip(
                          selected: isMale ?? false,
                          label: const Text(
                            "ذكر",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onSelected: (v) {
                            setState(() {
                              isMale = true;
                            });
                          },
                          side: BorderSide.none,
                          backgroundColor: Colors.grey.shade200,
                          selectedColor:
                              const Color.fromARGB(255, 139, 205, 255),
                          elevation: 3,
                        ),
                        FilterChip(
                          selected: isMale != null ? !(isMale!) : false,
                          label: const Text(
                            "انثى",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onSelected: (v) {
                            setState(() {
                              isMale = false;
                            });
                          },
                          side: BorderSide.none,
                          backgroundColor:
                              const Color.fromARGB(255, 241, 241, 241),
                          selectedColor:
                              const Color.fromARGB(255, 255, 161, 213),
                          elevation: 3,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "تاريخ الميلاد",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    ActionChip(
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: const Color.fromARGB(255, 241, 244, 245),
                      onPressed: () async {
                        final res = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now());
                        if (res != null) {
                          birthDate = res;
                          setState(() {});
                        }
                      },
                      label: Text(
                        birthDate != null
                            ? "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}"
                            : 'اختر تاريخ',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ActionChip.elevated(
                        backgroundColor: Colors.blue,
                        label: SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            child: const Center(
                              child: Text(
                                "حفظ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        onPressed: () {
                          if (nameCtl.text.isEmpty ||
                              phoneCtl.text.isEmpty ||
                              isMale == null ||
                              birthDate == null) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "الرجاء تعبة جميع الحقول!",
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            );
                            return;
                          }
                          Provider.of<ProfileState>(context, listen: false)
                              .createProfile(Profile(
                                  name: nameCtl.text.trim(),
                                  phoneNum: phoneCtl.text,
                                  birthDate: birthDate!,
                                  isMale: isMale!));
                        }),
                  ],
                ),
              ),
            ),
          ),
          Selector<ProfileState, Failure?>(
            selector: (context, state) => state.profileError,
            builder: (context, profileError, child) {
              if (profileError != null && isDialogNotActive) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (d) => showDialog(
                    context: context,
                    builder: (context) => BasicDialog(
                      icon: const Icon(Icons.warning_rounded,
                          size: 50, color: Colors.red),
                      title: "خطأ",
                      content: profileError.msg,
                      action: () {
                        Provider.of<ProfileState>(context).resetError();
                        isDialogNotActive = false;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          Selector<ProfileState, bool>(
            selector: (context, state) => state.isLoading,
            builder: (context, isLoading, child) {
              if (isLoading) {
                return const LoadingPage();
              }
              return const SizedBox();
            },
          ),
          Selector<ProfileState, bool>(
            selector: (context, state) => state.currentProfile != null,
            builder: (context, isProccessDone, child) {
              if (isProccessDone) {
                WidgetsBinding.instance
                    .addPostFrameCallback((d) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainContainer()),
                        ));
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
