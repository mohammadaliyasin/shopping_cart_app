import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havahavai_app/model/product_model.dart';

final productProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final response = await Dio().get('https://dummyjson.com/products');
  final List data = response.data['products'];
  return data.map((e) => Product.fromJson(e)).toList();
});
