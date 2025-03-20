import 'package:rmsh/domain/classes/cart_item.dart';

class CartViewModel {
  CartViewModel(this.c) : count = c.count;
  final CartItem c;
  int count;
}
