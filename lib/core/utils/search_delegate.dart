import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rmsh/presentation/providers/product_list_state.dart';

class CustomSearchDelegate extends SearchDelegate<String?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // throw UnimplementedError();
    return [
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
        // Exit from the search screen.
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // throw UnimplementedError();
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
      // Exit from the search screen.
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // final List<String> searchResults =
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Provider.of<ProductListState>(context, listen: false).getAllProducts());
    return Consumer<ProductListState>(builder: (context, state, child) {
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.getAllError != null) {
        return Center(
          child: Text(state.getAllError?.msg ?? "حدث خطأ ما"),
        );
      }
      return ListView.builder(
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(state.products[index].p.name),
            onTap: () {
              // Handle the selected search result.
              query = state.products[index].p.name;
              close(context, state.products[index].p.name);
            },
          );
        },
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // throw UnimplementedError();
    return const SizedBox();
  }
}
