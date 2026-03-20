import '../../domain/entities/product.dart';

class ProductResult {
  final List<Product> products;

  final bool fromCache;

  const ProductResult({
    required this.products,
    this.fromCache = false,
  });
}
