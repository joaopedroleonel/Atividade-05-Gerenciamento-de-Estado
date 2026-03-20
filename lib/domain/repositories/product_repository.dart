import '../entities/product_result.dart';

abstract class ProductRepository {
  Future<ProductResult> getProducts();
}
