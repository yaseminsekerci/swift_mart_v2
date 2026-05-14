// data/datasources/product_remote_data_source.dart
import '../../domain/entities/product.dart';

// Arayüz
abstract class ProductRemoteDataSource {
  Future<List<Product>> getProducts();
}

// Uygulama
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      // Telefonlar
      Product(
        id: "1",
        name: "iPhone 15 Pro",
        price: 59999,
        category: "Telefon",
        image: "assets/imageiphone.jpg",
        rating: 4.8,
        reviews: 245,
      ),
      Product(
        id: "2",
        name: "Samsung Galaxy S24 Ultra",
        price: 54999,
        category: "Telefon",
        image: "assets/imageiphone.jpg",
        rating: 4.7,
        reviews: 198,
      ),
      Product(
        id: "3",
        name: "Xiaomi 14 Pro",
        price: 32999,
        category: "Telefon",
        image: "assets/imageiphone.jpg",
        rating: 4.5,
        reviews: 156,
      ),
      Product(
        id: "4",
        name: "OnePlus 12",
        price: 28999,
        category: "Telefon",
        image: "assets/imageiphone.jpg",
        rating: 4.6,
        reviews: 132,
      ),
      
      // Bilgisayarlar
      Product(
        id: "5",
        name: "MacBook Air M2",
        price: 32999,
        category: "Bilgisayar",
        image: "assets/macbookair.jpg",
        rating: 4.9,
        reviews: 312,
      ),
      Product(
        id: "6",
        name: "MacBook Pro M3",
        price: 54999,
        category: "Bilgisayar",
        image: "assets/macbookair.jpg",
        rating: 4.9,
        reviews: 267,
      ),
      Product(
        id: "7",
        name: "Dell XPS 15",
        price: 42999,
        category: "Bilgisayar",
        image: "assets/macbookair.jpg",
        rating: 4.4,
        reviews: 178,
      ),
      Product(
        id: "8",
        name: "ASUS ROG Strix",
        price: 38999,
        category: "Bilgisayar",
        image: "assets/macbookair.jpg",
        rating: 4.6,
        reviews: 203,
      ),
      
      // Tabletler
      Product(
        id: "9",
        name: "iPad Pro 12.9\"",
        price: 24999,
        category: "Tablet",
        image: "assets/ipadpro.jpg",
        rating: 4.8,
        reviews: 289,
      ),
      Product(
        id: "10",
        name: "Samsung Galaxy Tab S9",
        price: 18999,
        category: "Tablet",
        image: "assets/ipadpro.jpg",
        rating: 4.5,
        reviews: 167,
      ),
      Product(
        id: "11",
        name: "Microsoft Surface Pro 9",
        price: 22999,
        category: "Tablet",
        image: "assets/ipadpro.jpg",
        rating: 4.3,
        reviews: 141,
      ),
      Product(
        id: "12",
        name: "Lenovo Tab P12",
        price: 12999,
        category: "Tablet",
        image: "assets/ipadpro.jpg",
        rating: 4.2,
        reviews: 98,
      ),
      
      // Ekstra ürünler
      Product(
        id: "13",
        name: "AirPods Pro 2",
        price: 6999,
        category: "Aksesuar",
        image: "assets/imageiphone.jpg",
        rating: 4.7,
        reviews: 456,
      ),
      Product(
        id: "14",
        name: "Apple Watch Series 9",
        price: 11999,
        category: "Aksesuar",
        image: "assets/imageiphone.jpg",
        rating: 4.8,
        reviews: 378,
      ),
      Product(
        id: "15",
        name: "Sony WH-1000XM5",
        price: 8999,
        category: "Aksesuar",
        image: "assets/imageiphone.jpg",
        rating: 4.6,
        reviews: 267,
      ),
      Product(
        id: "16",
        name: "Logitech MX Master 3S",
        price: 2999,
        category: "Aksesuar",
        image: "assets/imageiphone.jpg",
        rating: 4.9,
        reviews: 523,
      ),
    ];
  }
}