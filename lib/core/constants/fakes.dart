import 'package:flutter/material.dart';
import 'package:rmsh/domain/classes/cart_item.dart';
import 'package:rmsh/domain/classes/product_info.dart';
import 'package:rmsh/domain/classes/product_item.dart';

const fakeProductsList = <ProductInfo>[
  ProductInfo(
    id: '1',
    name: "سيارة فوكس فاغن",
    description:
        "سيارة خاصة بابين اربع ركاب مع محرك ب ثلاث رؤوس مع خزان احتراق 1.2 ليتر",
    thumbnail: "img/car.jpg",
    categoryName: '',
    likes: 5,
    isLiked: true,
    isWishlist: true,
    // hasOffer: false,
    price: 300000,
    offerPrice: 0,
  ),
  ProductInfo(
    id: '2',
    name: "نظارات شمسية",
    description:
        "نظارات شمسية بلاستيك رجالية تحجب الاشعة فوق البنفسجية وتحمي العين",
    categoryName: '',
    thumbnail: "img/glasses.jpg",
    likes: 5,
    isLiked: false,
    isWishlist: false,
    // hasOffer: false,
    price: 300000,
    offerPrice: 0,
  ),
  ProductInfo(
    id: '3',
    name: "حذاء ايطالي",
    description: "حذاء رياضي بارضية مطاطية مريح للقدمين",
    thumbnail: "img/Product1.jpg",
    categoryName: '',
    likes: 5,
    isLiked: false,
    isWishlist: false,
    // hasOffer: false,
    price: 300000,
    offerPrice: 0,
  ),
  ProductInfo(
    id: '4',
    name: "سماعات بيتس",
    description: "سماعات حجم كبير عازلة للصوت مع دعم للتقنيات الصوتية الحديثة",
    categoryName: '',
    thumbnail: "img/headnew.jpg",
    likes: 5,
    isLiked: false,
    isWishlist: false,
    // hasOffer: false,
    price: 300000,
    offerPrice: 0,
  ),
];

final fakeCartItemsList = <CartItem>[
  CartItem(
      id: "id",
      name: "حذاء ايطالي",
      details: ProductDetails(
        id: "3",
        color: Colors.white.value,
        size: 'L',
      ),
      price: 15000,
      offerPrice: 0,
      // hasOffer: false,
      thumbnail: 'img/Product1.jpg'),
  CartItem(
      id: "id",
      name: "حذاء ايطالي",
      details: ProductDetails(
        id: "3",
        color: Colors.white.value,
        size: 'L',
      ),
      count: 2,
      price: 15000,
      offerPrice: 0,
      // hasOffer: false,
      thumbnail: 'img/Product1.jpg'),
  CartItem(
      id: "id",
      name: "سيارة فوكس فاغن",
      details: ProductDetails(
        id: "3",
        color: Colors.white.value,
        size: 'L',
      ),
      price: 300000,
      offerPrice: 0,
      // hasOffer: false,
      thumbnail: 'img/car.jpg'),
  CartItem(
      id: "id",
      name: "سيارة فوكس فاغن",
      details: ProductDetails(
        id: "3",
        color: Colors.white.value,
        size: 'L',
      ),
      price: 300000,
      offerPrice: 0,
      // hasOffer: false,
      thumbnail: 'img/car.jpg'),
  CartItem(
      id: "id",
      name: "سيارة فوكس فاغن",
      details: ProductDetails(
        id: "3",
        color: Colors.white.value,
        size: 'L',
      ),
      price: 300000,
      offerPrice: 0,
      // hasOffer: false,
      thumbnail: 'img/car.jpg')
];

// final fakeOrders = <OrderEntity>[
//   OrderEntity(
//     id: 'id',
//     items: [
//       for (var i in [0, 1, 2]) fakeCartItemsList[i]
//     ],
//     coupon: "TV100",
//     deliveryOffice: "مكتب القدموس / السويداء ساحة تشرين",
//     status: OrderStatus.pending,
//     total: 100000,
//     createdAt: DateTime(1999),
//   ),
//   OrderEntity(
//     id: 'id',
//     items: [
//       for (var i in [0, 1, 2]) fakeCartItemsList[i]
//     ],
//     deliveryOffice: "القدموس / شارع البلاطة",
//     status: OrderStatus.processing,
//     total: 200000,
//     createdAt: DateTime(1999),
//   ),
//   OrderEntity(
//     id: 'id',
//     items: [
//       for (var i in [0, 1, 2]) fakeCartItemsList[i]
//     ],
//     deliveryOffice: "القدموس / الفرع الاساسي",
//     status: OrderStatus.shipped,
//     total: 300000,
//     createdAt: DateTime(1999),
//   ),
// ];

final colors = [
  Colors.blue.shade400,
  Colors.blue,
  Colors.blue.shade600,
  Colors.yellow.shade400,
  Colors.yellow,
  Colors.yellow.shade600,
  Colors.green.shade400,
  Colors.green,
  Colors.green.shade600,
  Colors.red.shade400,
  Colors.red,
  Colors.red.shade600,
  Colors.purple.shade400,
  Colors.purple,
  Colors.purple.shade600,
];

const sizes = [
  "1",
  "2",
  "S",
  "M",
  "L",
  "XL",
  "XXL",
  "XXXXXXLLLLLL",
  "XXXXXXLLLLLL",
  "XXXXXXLLLLLL",
  "XXXXXXLLLLLL",
  "XXXXXXLLLLLL",
  "XXXXXXLLLLLL",
];
