import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/errors/failures.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const _cacheKey = 'CACHED_PRODUCTS';

  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final jsonString = sharedPreferences.getString(_cacheKey);

    if (jsonString == null) {
      throw const CacheFailure('Nenhum dado em cache.');
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheFailure('Erro ao ler cache: $e');
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final jsonString =
          jsonEncode(products.map((p) => p.toJson()).toList());
      await sharedPreferences.setString(_cacheKey, jsonString);
    } catch (e) {
      throw CacheFailure('Erro ao salvar cache: $e');
    }
  }
}
