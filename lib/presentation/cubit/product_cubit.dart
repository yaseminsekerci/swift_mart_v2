import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_mart/domain/entities/product.dart';
import 'package:swift_mart/domain/usecases/get_products.dart';

class ProductCubit extends Cubit<List<Product>> {
  final GetProducts getProducts;
  List<Product> _allProducts = []; // Veritabanından gelen tüm orijinal ürünleri burada yedekliyoruz

  ProductCubit(this.getProducts) : super([]);

  // İlk açılışta ürünleri yükle
  Future<void> loadProducts() async {
    try {
      final products = await getProducts(); 
      _allProducts = products; // Gelen ürünleri yedek listeye kaydet
      emit(products); // Ekrana tüm ürünleri bas
    } catch (e) {
      emit([]); // Hata durumunda boş liste dön
    }
  }

  // Kategorilere tıklandığında anlık filtreleme yapan fonksiyon
  void filterByCategory(String category) {
    if (category == "Hepsi") {
      emit(_allProducts); // "Hepsi" seçildiyse yedeklediğimiz orijinal listeyi ekrana bas
    } else {
      // Seçilen kategoriye ait ürünleri süz ve ekrana bas
      final filtered = _allProducts.where((p) => p.category == category).toList();
      emit(filtered);
    }
  }
}