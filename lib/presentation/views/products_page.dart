import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rmsh/core/constants/assets_names.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/presentation/providers/auth_state.dart';
import 'package:rmsh/presentation/providers/product_list_state.dart';
import 'package:rmsh/presentation/views/product_details_screen.dart';
import 'package:rmsh/presentation/views/profile_screen.dart';
import 'package:rmsh/presentation/views/wishlist_screen.dart';
import 'package:rmsh/presentation/views/loading_page.dart';
import 'package:rmsh/presentation/widgets/product_widget.dart';
import 'package:rmsh/presentation/widgets/search_bar.dart';
import 'package:rmsh/splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String? selectedCategory, searchQuery;
  // bool isSearchMode = false;
  final searchController = TextEditingController();

  void addPostFrameCallback(void Function() callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) => callback());
  }

  @override
  void initState() {
    // searchController.addListener(() {
    //   Provider.of<ProductListState>(context, listen: false).searchMode =
    //       searchController.text.isNotEmpty;
    //   // setState(() {});
    // });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.sizeOf(context);
    final local = AppLocalizations.of(context)!;

    final provider = Provider.of<ProductListState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          // child: Text(
          //   'رمش',
          //   style: TextStyle(color: Color.fromARGB(255, 255, 237, 73)),
          // ),
          child: Image(
            image: AssetImage(AssetsNames.LOGO_YELLOW_TRIM),
            // width: 70,
          ),
        ),

        backgroundColor: Theme.of(context).colorScheme.primary,
        shadowColor: Colors.black,
        elevation: 10,
        // leading: const SizedBox(),
        // bottom: PreferredSize(
        //   preferredSize: Size(screenSize.width, 70),
        //   child: SizedBox(
        //     width: screenSize.width * 0.9,
        //     height: screenSize.height * 0.1,
        //     child: Center(
        //       child: SizedBox(
        //         height: 40,
        //         child: TextField(
        //           onTapOutside: (event) =>
        //               FocusScope.of(context).requestFocus(FocusNode()),
        //           controller: searchController,
        //           decoration: InputDecoration(
        //             fillColor: Colors.white54,
        //             filled: true,
        //             prefixIcon: const Icon(Icons.search),
        //             contentPadding:
        //                 const EdgeInsets.symmetric(horizontal: 15.0),
        //             border: OutlineInputBorder(
        //               borderRadius: BorderRadius.circular(1000),
        //               borderSide: BorderSide.none,
        //             ),
        //             suffixIcon: Selector<ProductListState, bool>(
        //                 selector: (context, state) => state.isSearchMode,
        //                 builder: (context, isSearchMode, child) {
        //                   return isSearchMode
        //                       ? IconButton(
        //                           onPressed: () {
        //                             searchQuery = null;
        //                             searchController.clear();
        //                             addPostFrameCallback(() =>
        //                                 provider.getAllProducts(
        //                                     selectedCategory, searchQuery));
        //                           },
        //                           icon: const Icon(Icons.close))
        //                       : const SizedBox();
        //                 }),
        //             hintText: "البحث",
        //           ),
        //           onSubmitted: (value) {
        //             searchQuery = value;
        //             print("$searchQuery : $value");
        //             addPostFrameCallback(
        //                 () => provider.getAllProducts(selectedCategory, value));
        //           },
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        actions: [
          // SizedBox(
          //   width: screenSize.width * 0.7,
          //   height: screenSize.height * 0.1,
          //   child: Center(
          //     child: SizedBox(
          //       height: 30,
          //       child: TextField(
          //         onTapOutside: (event) =>
          //             FocusScope.of(context).requestFocus(FocusNode()),
          //         controller: searchController,
          //         decoration: InputDecoration(
          //           fillColor: Colors.white54,
          //           filled: true,
          //           prefixIcon: const Icon(Icons.search),
          //           contentPadding:
          //               const EdgeInsets.symmetric(horizontal: 15.0),
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(1000),
          //             borderSide: BorderSide.none,
          //           ),
          //           suffixIcon: Selector<ProductListState, bool>(
          //               selector: (context, state) => state.isSearchMode,
          //               builder: (context, isSearchMode, child) {
          //                 return isSearchMode
          //                     ? IconButton(
          //                         splashRadius: 20,
          //                         iconSize: 20,
          //                         padding: EdgeInsets.zero,
          //                         onPressed: () {
          //                           searchQuery = null;
          //                           searchController.clear();
          //                           addPostFrameCallback(() =>
          //                               provider.getAllProducts(
          //                                   selectedCategory, searchQuery));
          //                         },
          //                         icon: const Icon(Icons.close, size: 20))
          //                     : const SizedBox();
          //               }),
          //           hintText: "البحث",
          //         ),
          //         onSubmitted: (value) {
          //           searchQuery = value;
          //           print("$searchQuery : $value");
          //           addPostFrameCallback(
          //               () => provider.getAllProducts(selectedCategory, value));
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          SearchBarWidget(
            onClose: () => searchQuery = null,
            onSubmit: (query) {
              searchQuery = query;
              print("$searchQuery : $query");
              addPostFrameCallback(
                  () => provider.getAllProducts(selectedCategory, query));
            },
          ),
          PopupMenuButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              offset: const Offset(0, 45),
              color: Colors.white,
              itemBuilder: (c) {
                return [
                  PopupMenuItem<int>(
                    child: Row(
                      children: [
                        // Icon(Icons.person),
                        const SizedBox(width: 5),
                        Text(local.profile),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => const ProfileScreen()),
                    ),
                  ),
                  PopupMenuItem<int>(
                    child: Row(
                      children: [
                        // Icon(Icons.bookmarks),
                        const SizedBox(width: 5),
                        Text(local.favs),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => const WishlistScreen()),
                    ),
                  ),
                  // PopupMenuItem<int>(
                  //   child: Row(
                  //     children: [
                  //       // Icon(Icons.bookmarks),
                  //       const SizedBox(width: 5),
                  //       Text(local.language),
                  //     ],
                  //   ),
                  //   onTap: () => showDialog(
                  //     context: context,
                  //     builder: (context) => LanguageDialog(
                  //       currentLang:
                  //           Provider.of<SettingsState>(context, listen: false)
                  //               .curretnLang
                  //               .languageCode,
                  //       onPositive: (lang) =>
                  //           context.read<SettingsState>().setLang(lang),
                  //     ),
                  //   ),
                  // ),
                  PopupMenuItem<int>(
                    child: Row(
                      children: [
                        // Icon(Icons.logout),
                        const SizedBox(width: 5),
                        Text(
                          local.logout,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            local.logout,
                            textDirection: TextDirection.rtl,
                          ),
                          content: Text(
                            local.logoutMessage,
                            textDirection: TextDirection.rtl,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(local.cancel),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                final success = await Provider.of<AuthState>(
                                        context,
                                        listen: false)
                                    .logout();
                                if (context.mounted && success) {
                                  // Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => const SplashScreen()),
                                  );
                                  return;
                                }
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('موافق'),
                            )
                          ],
                        ),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (c) => const AuthScreen(),
                      //   ),
                      // );
                    },
                  ),
                ];
              }),
        ],
      ),
      body: Stack(
        children: [
          Consumer<ProductListState>(builder: (context, state, child) {
            if (kDebugMode) {
              print(state.toString());
            }

            return RefreshIndicator(
              onRefresh: () async =>
                  await provider.refresh(selectedCategory, searchQuery),
              child: ListView.builder(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10),
                itemCount: state.products.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Selector<ProductListState, List<String>>(
                        selector: (context, state) => state.categories,
                        builder: (context, categories, child) {
                          return SizedBox(
                            height: 70,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              children: [
                                for (var c in categories) ...[
                                  FilterChip(
                                    label: Text(c),
                                    onSelected: (selected) {
                                      if (selected && selectedCategory != c) {
                                        selectedCategory = c;
                                        addPostFrameCallback(() =>
                                            provider.getAllProducts(
                                                selectedCategory, searchQuery));
                                      } else if (!selected) {
                                        selectedCategory = null;
                                        addPostFrameCallback(() =>
                                            provider.getAllProducts(
                                                selectedCategory, searchQuery));
                                      }
                                    },
                                    selected: c == selectedCategory,
                                    side: BorderSide.none,
                                    backgroundColor: Colors.grey.shade200,
                                    selectedColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainer,
                                    elevation: 3,
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ],
                            ),
                          );
                        });
                  }
                  if (state.products.isEmpty) {
                    return const SizedBox();
                  }
                  if (index <= state.products.length) {
                    return ProductWidget(
                      likesNum: state.products[index - 1].p.likes +
                          (state.products[index - 1].isLiked ? 1 : 0),
                      product: state.products[index - 1],
                      likeUnlike: (isActive) => addPostFrameCallback(
                          () => provider.likeOrUnlike(index - 1, !isActive)),
                      wishlist: (isActive) => addPostFrameCallback(() =>
                          provider.addOrRemoveWishlist(index - 1, !isActive)),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => ProductDetailsScreen(
                              productId: state.products[index - 1].p.id),
                        ),
                      ),
                    );
                  } else if (state.hasReachedTheEnd) {
                    return const SizedBox();
                  } else {
                    if (!state.hasRequested) {
                      addPostFrameCallback(() =>
                          provider.loadMore(selectedCategory, searchQuery));
                    }
                    if (index == state.products.length + 1) {
                      return const SizedBox(
                          height: 50,
                          child: Center(child: CircularProgressIndicator()));
                    }

                    return const SizedBox();
                  }
                },
              ),
            );
          }),
          Selector<ProductListState, bool>(
            selector: (context, state) => state.isLoading,
            builder: (context, isLoading, child) {
              if (isLoading) {
                return const LoadingPage();
              }
              return const SizedBox();
            },
          ),
          Selector<ProductListState, Failure?>(
            selector: (context, state) => state.refreshFailure,
            builder: (context, failure, child) {
              if (failure != null) {
                addPostFrameCallback(() {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(failure.msg ?? "حدث خطأ")));
                });
              }
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }
}
