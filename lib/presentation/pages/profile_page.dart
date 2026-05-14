import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_mart/domain/entities/saved_address.dart';
import 'package:swift_mart/domain/entities/saved_payment_method.dart';
import 'package:swift_mart/domain/entities/user_profile.dart';
import 'package:swift_mart/domain/entities/product.dart';
import 'package:swift_mart/domain/entities/order_summary.dart';
import 'package:swift_mart/presentation/cubit/fovorite_cubit.dart';
import 'package:swift_mart/presentation/cubit/address_cubit.dart';
import 'package:swift_mart/presentation/cubit/payment_methods_cubit.dart';
import 'package:swift_mart/presentation/cubit/orders_cubit.dart';
import 'package:swift_mart/presentation/cubit/user_profile_cubit.dart';
import 'package:swift_mart/presentation/pages/favorites_page.dart';
import 'package:swift_mart/presentation/pages/orders_page.dart';
import 'package:swift_mart/presentation/pages/address_page.dart';
import 'package:swift_mart/presentation/pages/payment_methods_page.dart';
import 'package:swift_mart/presentation/pages/settings_page.dart';
import 'package:swift_mart/presentation/pages/splash_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _profileController;
  late Animation<double> _profileScale;
  late Animation<double> _profileOpacity;

  @override
  void initState() {
    super.initState();

    _profileController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _profileScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _profileController, curve: Curves.elasticOut),
    );

    _profileOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _profileController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _profileController.forward();
  }

  @override
  void dispose() {
    _profileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Profilim',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFF8F9FA), const Color(0xFFE2E8F0)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profil Resmi - Animasyonlu
              AnimatedBuilder(
                animation: _profileController,
                builder: (context, child) {
                  return ScaleTransition(
                    scale: _profileScale,
                    child: FadeTransition(
                      opacity: _profileOpacity,
                      child: Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF00B4D8),
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF00B4D8,
                                    ).withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                                image: const DecorationImage(
                                  image: NetworkImage(
                                    "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Profil fotoğrafı güncellenecek",
                                      ),
                                      backgroundColor: Color(0xFF00B4D8),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00B4D8),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                            // Profil çevresindeki halka animasyonu
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(
                                      0xFF00B4D8,
                                    ).withOpacity(0.2),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              FadeTransition(
                opacity: _profileOpacity,
                child: BlocBuilder<UserProfileCubit, UserProfile>(
                  builder: (context, profile) {
                    return Column(
                      children: [
                        Text(
                          profile.displayName,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E293B),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.email,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              // Menü Listesi - Dikkat Çekici
              BlocBuilder<OrdersCubit, List<OrderSummary>>(
                builder: (context, orders) {
                  final count = orders.length;
                  final subtitle = count == 0
                      ? 'Henüz sipariş yok'
                      : (count == 1 ? '1 sipariş' : '$count sipariş');
                  return _buildAnimatedMenuItem(
                    Icons.shopping_bag_outlined,
                    'Siparişlerim',
                    subtitle,
                    const Color(0xFF00B4D8),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrdersPage(),
                        ),
                      );
                    },
                  );
                },
              ),

              BlocBuilder<FavoriteCubit, List<Product>>(
                builder: (context, favorites) {
                  final n = favorites.length;
                  final sub = n == 0
                      ? 'Henüz favori yok'
                      : (n == 1 ? '1 ürün' : '$n ürün');
                  return _buildAnimatedMenuItem(
                    Icons.favorite_border_rounded,
                    'Favorilerim',
                    sub,
                    const Color(0xFFE91E63),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FavoritesPage(),
                        ),
                      );
                    },
                  );
                },
              ),
              BlocBuilder<AddressCubit, List<SavedAddress>>(
                builder: (context, _) {
                  final sub = context.read<AddressCubit>().profileSubtitle();
                  return _buildAnimatedMenuItem(
                    Icons.location_on_outlined,
                    'Adres Bilgilerim',
                    sub,
                    const Color(0xFF9C27B0),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddressPage()),
                      );
                    },
                  );
                },
              ),
              BlocBuilder<PaymentMethodsCubit, List<SavedPaymentMethod>>(
                builder: (context, _) {
                  final sub =
                      context.read<PaymentMethodsCubit>().profileSubtitle();
                  return _buildAnimatedMenuItem(
                    Icons.payment_outlined,
                    'Ödeme Yöntemlerim',
                    sub,
                    const Color(0xFF4CAF50),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentMethodsPage(),
                        ),
                      );
                    },
                  );
                },
              ),
              _buildAnimatedMenuItem(
                Icons.settings_outlined,
                "Ayarlar",
                "Tüm ayarlar",
                const Color(0xFF607D8B),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
              ),

              const SizedBox(height: 20),
              const Divider(color: Color(0xFFE2E8F0), thickness: 1),
              const SizedBox(height: 20),

              _buildAnimatedMenuItem(
                Icons.logout_rounded,
                "Çıkış Yap",
                "Oturumu kapat",
                Colors.redAccent,
                () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        "Çıkış Yap",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                        "Uygulamadan çıkmak istediğinizden emin misiniz?",
                        style: TextStyle(fontSize: 16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "İptal",
                            style: TextStyle(color: Color(0xFF64748B)),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SplashScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Çıkış Yap",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildAnimatedMenuItem(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.15), width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: color,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
