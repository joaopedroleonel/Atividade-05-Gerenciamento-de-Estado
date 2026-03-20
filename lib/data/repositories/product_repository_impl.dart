import '../../core/errors/failures.dart';
import '../../domain/entities/product_result.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<ProductResult> getProducts() async {
    try {
      final remoteModels = await remoteDataSource.getProducts();

      await _tryCache(remoteModels);

      return ProductResult(products: remoteModels, fromCache: false);
    } on NetworkFailure {
      return _fallbackToCache();
    } on ServerFailure {
      return _fallbackToCache();
    }
  }

  Future<ProductResult> _fallbackToCache() async {
    final cachedModels = await localDataSource.getCachedProducts();
    return ProductResult(products: cachedModels, fromCache: true);
  }

  Future<void> _tryCache(List<ProductModel> models) async {
    try {
      await localDataSource.cacheProducts(models);
    } catch (_) {
    }
  }
}
