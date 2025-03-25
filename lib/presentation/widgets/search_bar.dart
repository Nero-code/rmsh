import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rmsh/presentation/providers/product_list_state.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget(
      {super.key, required this.onClose, required this.onSubmit});
  final void Function() onClose;
  final void Function(String query) onSubmit;
  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final searchController = TextEditingController();

  @override
  void initState() {
    searchController.addListener(
      () => Provider.of<ProductListState>(context, listen: false).searchMode =
          searchController.text.isNotEmpty,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return SizedBox(
      width: screenSize.width * 0.7,
      height: screenSize.height * 0.1,
      child: Center(
        child: SizedBox(
          height: 30,
          child: TextField(
            onTapOutside: (event) =>
                FocusScope.of(context).requestFocus(FocusNode()),
            controller: searchController,
            decoration: InputDecoration(
              fillColor: Colors.white54,
              filled: true,
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1000),
                borderSide: BorderSide.none,
              ),
              suffixIcon: Selector<ProductListState, bool>(
                  selector: (context, state) => state.isSearchMode,
                  builder: (context, isSearchMode, child) {
                    return isSearchMode
                        ? IconButton(
                            splashRadius: 20,
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              searchController.clear();
                              widget.onClose();
                            },
                            icon: const Icon(Icons.close, size: 20))
                        : const SizedBox();
                  }),
              hintText: "البحث",
            ),
            onSubmitted: widget.onSubmit,
          ),
        ),
      ),
    );
  }
}
