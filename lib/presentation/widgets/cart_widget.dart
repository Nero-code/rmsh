import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rmsh/presentation/vm/cart_vm.dart';
import 'package:rmsh/presentation/widgets/box_botton.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({
    super.key,
    this.hasError,
    required this.item,
    required this.removeItem,
    required this.reduce,
    required this.add,
  });

  final String? hasError;
  final CartViewModel item;
  final void Function(int val)? reduce, add;
  final void Function() removeItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
          // color: Color.fromARGB(255, 247, 247, 247),
          // border: Border.all(width: 0.5, color: Colors.black12),
          ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              child: InkWell(
                child: const SizedBox(
                    height: 100,
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    )),
                onTapUp: (details) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("حذف؟"),
                      content: Text("هل انت متأكد من حذف \"${item.c.name}\""),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("لا"),
                        ),
                        ElevatedButton(
                          onPressed: removeItem,
                          child: const Text("نعم"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                imageUrl: item.c.thumbnail,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.c.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        BoxBotton(
                          width: 15,
                          height: 15,
                          background: Color(item.c.details.color),
                          isCircle: true,
                        ),
                        const SizedBox(width: 5.0),
                        BoxBotton(
                          // width: 35,
                          // height: 20,
                          border: Border.all(width: .5),
                          borderRadius: 3.0,
                          // width: 35,
                          // height: 20,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(item.c.details.size),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (add != null)
                          IconButton(
                            onPressed: item.count > 1
                                ? () => add!(--item.count)
                                : null,
                            icon: const Icon(Icons.remove, size: 20),
                          ),
                        Text(
                          "${item.count}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (reduce != null)
                          IconButton(
                            onPressed: () => reduce!(++item.count),
                            icon: const Icon(Icons.add, size: 20),
                          ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (item.c.offerPrice > 0)
                      Text(
                        "SYP ${item.c.price}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 10,
                          color: Colors.red,
                          // color: Colors.blueGrey,
                        ),
                      ),
                    Text(
                      "SYP ${item.c.price - item.c.offerPrice}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: item.c.offerPrice > 0
                            ? Colors.green
                            : Colors.blueGrey,
                        // color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
