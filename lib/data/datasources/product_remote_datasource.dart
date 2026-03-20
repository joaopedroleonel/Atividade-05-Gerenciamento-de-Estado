import '../../core/network/http_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  static const String _baseUrl = 'https://fakestoreapi.com';

  final HttpClient httpClient;

  ProductRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<List<ProductModel>> getProducts() async {
    final data = await httpClient.get('$_baseUrl/products');

    if (data is List) {
      return data
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return [];
  }
}
