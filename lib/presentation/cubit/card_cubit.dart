import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';

class CartCubit extends Cubit<List<Product>> {
  CartCubit() : super([]); // Başlangıçta sepet boş

  // Ürünü sepete ekleme fonksiyonu
  void addToCart(Product product) {
    // Mevcut listeyi kopyala ve yeni ürünü ekle
    final updatedList = List<Product>.from(state)..add(product);
    emit(updatedList); // Yeni durumu (state) yay
  }

  // Sepetten ürün çıkarma
  void removeFromCart(Product product) {
    final updatedList = List<Product>.from(state)..remove(product);
    emit(updatedList);
  }

  // Sepeti tamamen temizleme
  void clearCart() {
    emit([]);
  }
}