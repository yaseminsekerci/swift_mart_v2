// lib/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:swift_mart/data/datasources/product_remote_data_source.dart';
import 'package:swift_mart/data/repositories/product_repository_impl.dart';
import 'package:swift_mart/domain/repositories/product_repository.dart';
import 'package:swift_mart/domain/usecases/get_products.dart';
import 'package:swift_mart/presentation/cubit/product_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(() => ProductCubit(sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetProducts(sl()));

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(),
  );
}