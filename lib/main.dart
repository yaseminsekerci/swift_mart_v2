import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_mart/injection_container.dart' as ic;
import 'package:swift_mart/presentation/cubit/product_cubit.dart';
import 'package:swift_mart/presentation/cubit/orders_cubit.dart';
import 'package:swift_mart/presentation/cubit/auth_cubit.dart';
import 'package:swift_mart/presentation/cubit/user_profile_cubit.dart';
import 'package:swift_mart/presentation/cubit/fovorite_cubit.dart';
import 'package:swift_mart/presentation/cubit/card_cubit.dart';
import 'package:swift_mart/presentation/cubit/address_cubit.dart';
import 'package:swift_mart/presentation/cubit/payment_methods_cubit.dart';
import 'package:swift_mart/presentation/cubit/comments_cubit.dart';
import 'package:swift_mart/presentation/cubit/theme_cubit.dart';
import 'package:swift_mart/presentation/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ic.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ic.sl<ProductCubit>()),
        BlocProvider(create: (_) => OrdersCubit()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => UserProfileCubit()),
        BlocProvider(create: (_) => FavoriteCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => AddressCubit()),
        BlocProvider(create: (_) => PaymentMethodsCubit()),
        BlocProvider(create: (_) => CommentsCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, themeData) {
          return MaterialApp(
            title: 'Swift Mart',
            theme: themeData,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}