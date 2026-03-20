import 'package:flutter/foundation.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final ProductRepository repository;

  ProductProvider({required this.repository});

  ProductStatus _status = ProductStatus.initial;
  List<Product> _products = [];
  String _errorMessage = '';

  bool _fromCache = false;

  ProductStatus get status => _status;
  List<Product> get products => _products;
  String get errorMessage => _errorMessage;
  bool get fromCache => _fromCache;
  int get favoriteCount => _products.where((p) => p.favorite).length;

  void toggleFavorite(int productId) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index].favorite = !_products[index].favorite;
      notifyListeners();
    }
  }

  Future<void> fetchProducts() async {
    _status = ProductStatus.loading;
    _fromCache = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await repository.getProducts();
      _products = result.products;
      _fromCache = result.fromCache;
      _status = ProductStatus.loaded;
    } on CacheFailure catch (e) {
      _errorMessage = 'Sem conexão e nenhum dado em cache.\n${e.message}';
      _status = ProductStatus.error;
    } on NetworkFailure catch (e) {
      _errorMessage = 'Falha de rede: ${e.message}';
      _status = ProductStatus.error;
    } on ServerFailure catch (e) {
      _errorMessage = 'Erro no servidor: ${e.message}';
      _status = ProductStatus.error;
    } catch (e) {
      _errorMessage = 'Erro inesperado: $e';
      _status = ProductStatus.error;
    }

    notifyListeners();
  }
}
