import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';

class FavoriteCubit extends Cubit<List<Product>> {
  FavoriteCubit() : super([]);

  void toggleFavorite(Product product) {
    final updatedList = List<Product>.from(state);
    final i = updatedList.indexWhere((p) => p.id == product.id);
    if (i >= 0) {
      updatedList.removeAt(i);
    } else {
      updatedList.add(product);
    }
    emit(updatedList);
  }

  bool isFavorite(Product product) {
    return state.any((p) => p.id == product.id);
  }

  void removeFromFavorites(Product product) {
    emit(state.where((p) => p.id != product.id).toList());
  }
}
