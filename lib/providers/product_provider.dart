import 'package:flutter/foundation.dart';
import '../models/infusion_type.dart';
import '../models/product.dart';
import '../services/database_service.dart';

enum ProductSortBy {
  ranking,
  name,
  recentlyAdded,
}

class ProductProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;

  List<Product> _allProducts = [];
  bool _isLoading = false;
  InfusionCategory? _selectedCategoryFilter; // null = all
  String _searchQuery = '';
  ProductSortBy _sortBy = ProductSortBy.ranking;

  List<Product> get allProducts => _allProducts;
  bool get isLoading => _isLoading;
  InfusionCategory? get selectedCategoryFilter => _selectedCategoryFilter;
  String get searchQuery => _searchQuery;
  ProductSortBy get sortBy => _sortBy;

  List<Product> get filteredProducts {
    var list = List<Product>.from(_allProducts);

    if (_selectedCategoryFilter != null) {
      list = list.where((p) => p.category == _selectedCategoryFilter).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      list = list.where((p) {
        final matchesName = p.name.toLowerCase().contains(query);
        final matchesBrand = p.brand.toLowerCase().contains(query);
        final matchesOrigin = p.origin.toLowerCase().contains(query);
        final matchesNotes = p.tastingNotes.any((n) => n.toLowerCase().contains(query));
        return matchesName || matchesBrand || matchesOrigin || matchesNotes;
      }).toList();
    }

    switch (_sortBy) {
      case ProductSortBy.ranking:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProductSortBy.name:
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case ProductSortBy.recentlyAdded:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return list;
  }

  List<Product> get topMateRanking =>
      _allProducts.where((p) => p.category == InfusionCategory.mate).toList()
        ..sort((a, b) => b.rating.compareTo(a.rating));

  List<Product> get topCafeRanking =>
      _allProducts.where((p) => p.category == InfusionCategory.cafe).toList()
        ..sort((a, b) => b.rating.compareTo(a.rating));

  List<Product> get topTeRanking =>
      _allProducts.where((p) => p.category == InfusionCategory.te).toList()
        ..sort((a, b) => b.rating.compareTo(a.rating));

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allProducts = await _db.getProducts();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading products: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategoryFilter(InfusionCategory? category) {
    _selectedCategoryFilter = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortBy(ProductSortBy sort) {
    _sortBy = sort;
    notifyListeners();
  }

  Future<bool> addProduct(Product product) async {
    try {
      await _db.insertProduct(product);
      await loadProducts();
      return true;
    } catch (e) {
      if (kDebugMode) print('Error adding product: $e');
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      await _db.updateProduct(product);
      await loadProducts();
      return true;
    } catch (e) {
      if (kDebugMode) print('Error updating product: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      await _db.deleteProduct(id);
      await loadProducts();
      return true;
    } catch (e) {
      if (kDebugMode) print('Error deleting product: $e');
      return false;
    }
  }

  Product? getProductById(String? id) {
    if (id == null) return null;
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
