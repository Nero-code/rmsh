import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/classes/profile.dart';
import 'package:rmsh/presentation/dialogs/basic_dialog.dart';
import 'package:rmsh/presentation/providers/profile_state.dart';
import 'package:rmsh/presentation/views/loading_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isDialogNotActive = true; // for errors
  bool hasRefreshedScreen = false;

  final nameCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  DateTime? birthDate;
  bool? isMale;
  Profile? p;

  // @override
  // void initState() {
  //   p = Provider.of<ProfileState>(context, listen: false).currentProfile;
  //   nameCtl.text = p?.name ?? "";
  //   phoneCtl.text = p?.phoneNum ?? "";
  //   isMale = p?.isMale;
  //   birthDate = p?.birthDate;

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(local.profile)),
        actions: const [SizedBox(width: 50)],
      ),
      body: Stack(
        children: [
          Selector<ProfileState, Profile?>(
            selector: (_, state) =>
                state.isLoading ? null : state.currentProfile,
            builder: (context, profile, child) {
              if (profile == null) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) async {
                    await Provider.of<ProfileState>(context, listen: false)
                        .hasProfile();
                  },
                );
              } else if (!hasRefreshedScreen) {
                // Auto fill date
                nameCtl.text = profile.name;
                phoneCtl.text = profile.phoneNum;
                isMale = profile.isMale;
                birthDate = profile.birthDate;

                // reload screen so the data can appeare
                hasRefreshedScreen = true;
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => setState(() {}));
              }

              return child as Widget;
            },
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        local.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      TextFormField(
                        controller: nameCtl,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: local.nameHint,
                          hintTextDirection: TextDirection.rtl,
                          hintStyle: const TextStyle(color: Colors.grey),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return local.emptyFieldErrorMsg;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        local.phone,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
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
                            return local.emptyFieldErrorMsg;
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
                            label: Text(
                              local.male,
                              style: const TextStyle(
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
                            label: Text(
                              local.female,
                              style: const TextStyle(
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
                      Text(
                        local.birth,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      ActionChip(
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor:
                            const Color.fromARGB(255, 241, 244, 245),
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
                              : local.chooseDate,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ActionChip.elevated(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        label: SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            child: Center(
                              child: Text(
                                local.save,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        onPressed: () {
                          Provider.of<ProfileState>(context, listen: false)
                              .updateProfile(
                            Profile(
                                name: nameCtl.text.trim(),
                                phoneNum: phoneCtl.text,
                                birthDate: birthDate!,
                                isMale: isMale!),
                          );
                        },
                      ),
                    ],
                  ),
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
        ],
      ),
    );
  }
}
