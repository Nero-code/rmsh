import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rmsh/domain/classes/cart_item.dart';
import 'package:rmsh/presentation/widgets/box_botton.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      height: 120,
      decoration: BoxDecoration(
        // color: Color.fromARGB(255, 247, 247, 247),
        border: Border.all(width: 0.5, color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.rtl,
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(10),
          //   child: Image(
          //     image: AssetImage(item.thumbnail),
          //     width: 70,
          //     height: 70,
          //   ),
          // ),
          CachedNetworkImage(
            width: 100,
            height: 100,
            imageUrl: item.thumbnail,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.rtl,
                  children: [
                    Row(
                      children: [
                        BoxBotton(
                          width: 15,
                          height: 15,
                          background: Color(item.details.color),
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
                            child: Text(item.details.size),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${item.count}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (item.offerPrice > 0)
                      Text(
                        "SYP ${item.price}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 10,
                          color: Colors.red,
                          // color: Colors.blueGrey,
                        ),
                      ),
                    Text(
                      "SYP ${item.price - item.offerPrice}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: item.offerPrice > 0
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
