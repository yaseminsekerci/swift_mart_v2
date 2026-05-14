import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_mart/presentation/cubit/product_cubit.dart';
import 'package:swift_mart/presentation/cubit/card_cubit.dart';
import 'package:swift_mart/presentation/cubit/fovorite_cubit.dart';
import 'package:swift_mart/domain/entities/product.dart';
import 'package:swift_mart/domain/entities/user_profile.dart';
import 'package:swift_mart/presentation/cubit/user_profile_cubit.dart';
import 'package:swift_mart/presentation/pages/card_page.dart';
import 'package:swift_mart/presentation/pages/product_detail.dart';
import 'package:swift_mart/presentation/pages/comments_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activeCategory = "Hepsi";
  String searchQuery = "";
  String sortBy = "name"; // name, price_low, price_high
  bool _isLoadingCategory = false;
  final TextEditingController _searchController = TextEditingController();

  late final VoidCallback _searchListener = () {
    if (mounted) setState(() {});
  };

  final List<Map<String, Object>> categories = [
    {"title": "Hepsi", "icon": Icons.grid_view_rounded},
    {"title": "Telefon", "icon": Icons.smartphone_rounded},
    {"title": "Bilgisayar", "icon": Icons.laptop_rounded},
    {"title": "Tablet", "icon": Icons.tablet_mac_rounded},
    {"title": "Aksesuar", "icon": Icons.watch_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchListener);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchListener);
    _searchController.dispose();
    super.dispose();
  }

  void _openProfilePage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (sheetContext) {
        return BlocBuilder<UserProfileCubit, UserProfile>(
          builder: (ctx, profile) {
            return Container(
              padding: const EdgeInsets.all(30),
              height: 350,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF00B4D8),
                        width: 3,
                      ),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    profile.displayName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    profile.email,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 25),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Color(0xFF00B4D8)),
                    title: const Text(
                      'Hesap Ayarları',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      'Kapat',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    onTap: () => Navigator.pop(sheetContext),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openCartPage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (modalContext, scrollController) {
            return BlocBuilder<CartCubit, List<Product>>(
              builder: (context, cartProducts) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                      const SizedBox(height: 20),
                      const Text("Sepetim 🛒", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      const SizedBox(height: 15),
                      if (cartProducts.isEmpty)
                        const Expanded(child: Center(child: Text("Sepetiniz henüz boş.", style: TextStyle(color: Colors.grey, fontSize: 16))))
                      else ...[
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: cartProducts.length,
                            itemBuilder: (context, index) {
                              final p = cartProducts[index];
                              return Card(
                                color: const Color(0xFFF8FAFC),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                                child: ListTile(
                                  leading: Image.asset(p.image, width: 50, fit: BoxFit.contain, 
                                    errorBuilder: (_,__,___) => const Icon(Icons.shopping_bag)),
                                  title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text("${p.price.toStringAsFixed(0)} TL"),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                    onPressed: () => modalContext.read<CartCubit>().removeFromCart(p),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(color: const Color(0xFF00B4D8).withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Toplam Ödeme", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(
                                "${cartProducts.fold<double>(0, (sum, item) => sum + item.price).toStringAsFixed(0)} TL",
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF00B4D8)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                      ]
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _openSortFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (modalContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sıralama ve filtre',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Ürün listesini nasıl sıralamak istersiniz?',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                _sortTile(modalContext, 'name', 'İsme göre (A-Z)'),
                _sortTile(modalContext, 'price_low', 'Fiyat: düşükten yükseğe'),
                _sortTile(modalContext, 'price_high', 'Fiyat: yüksekten düşüğe'),
                _sortTile(modalContext, 'newest', 'En yeniler'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sortTile(BuildContext modalContext, String value, String label) {
    final selected = sortBy == value;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 8,
      leading: Icon(
        selected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
        color: selected ? const Color(0xFF00B4D8) : const Color(0xFFCBD5E1),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          color: const Color(0xFF1E293B),
          fontSize: 14,
        ),
      ),
      onTap: () {
        setState(() => sortBy = value);
        Navigator.pop(modalContext);
      },
    );
  }

  Widget _buildCategoryChip(String title, IconData icon) {
    const accent = Color(0xFF00B4D8);
    final selected = activeCategory == title;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () {
          if (!_isLoadingCategory) {
            setState(() {
              _isLoadingCategory = true;
              activeCategory = title;
            });
            
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.read<ProductCubit>().filterByCategory(title);
                setState(() => _isLoadingCategory = false);
              }
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? accent : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? accent : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              if (selected)
                BoxShadow(
                  color: accent.withOpacity(0.28),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                )
              else
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoadingCategory && selected)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
              else
                Icon(
                  icon,
                  size: 18,
                  color: selected ? Colors.white : const Color(0xFF64748B),
                ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: selected ? Colors.white : const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              // ÜST BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _openProfilePage,
                        child: Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF00B4D8), width: 1.5),
                            image: const DecorationImage(
                              image: NetworkImage("https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("SwiftMart 🚀", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: -0.5)),
                          Text("Teknoloji kapına gelsin", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  // SEPET BUTONU
                  BlocBuilder<CartCubit, List<Product>>(
                    builder: (context, cartProducts) {
                      return GestureDetector(
                        onTap: _openCartPage,
                        child: Container(
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(Icons.shopping_bag_outlined, size: 26, color: Color(0xFF00B4D8)),
                              if (cartProducts.isNotEmpty)
                                Positioned(
                                  right: 5,
                                  top: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent, 
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 1.5)
                                    ),
                                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                                    child: Text(
                                      '${cartProducts.length}',
                                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // ARAMA BARI
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00B4D8).withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) =>
                      setState(() => searchQuery = v.trim().toLowerCase()),
                  decoration: InputDecoration(
                    hintText: "Ürün veya kategori ara...",
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF00B4D8),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            tooltip: 'Temizle',
                            icon: const Icon(Icons.clear_rounded),
                            color: const Color(0xFF94A3B8),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => searchQuery = "");
                            },
                          ),
                        IconButton(
                          tooltip: 'Sırala',
                          icon: const Icon(
                            Icons.tune_rounded,
                            color: Color(0xFF00B4D8),
                          ),
                          onPressed: _openSortFilterSheet,
                        ),
                      ],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // BANNER
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF00B4D8),
                      const Color(0xFF0077B6),
                      const Color(0xFF03045E),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00B4D8).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "YENİ DÖNEM FIRSATLARI",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Büyük Bahar İndirimi!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "%70'e Varan İndirim",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      child: const Icon(
                        Icons.bolt_rounded,
                        size: 60,
                        color: Colors.white30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const SectionHeader(title: "Kategoriler"),
              const SizedBox(height: 12),
              SizedBox(
                height: 46,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final c = categories[index];
                    return _buildCategoryChip(
                      c['title'] as String,
                      c['icon'] as IconData,
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),
              const SectionHeader(title: "Öne Çıkan Ürünler"),
              const SizedBox(height: 15),
              BlocBuilder<ProductCubit, List<Product>>(
                builder: (context, products) {
                  if (products.isEmpty) return const Center(child: CircularProgressIndicator());
                  
                  final q = searchQuery;
                  List<Product> filtered = products.where((p) {
                    if (q.isEmpty) return true;
                    final name = p.name.toLowerCase();
                    final cat = p.category.toLowerCase();
                    return name.contains(q) || cat.contains(q);
                  }).toList();

                  // Sıralama mantığı
                  switch (sortBy) {
                    case 'price_low':
                      filtered.sort((a, b) => a.price.compareTo(b.price));
                      break;
                    case 'price_high':
                      filtered.sort((a, b) => b.price.compareTo(a.price));
                      break;
                    case 'newest':
                      // En yeni ürünler (ID'ye göre ters sıralama)
                      filtered.sort((a, b) => b.id.compareTo(a.id));
                      break;
                    case 'name':
                    default:
                      filtered.sort((a, b) => a.name.compareTo(b.name));
                      break;
                  }

                  if (filtered.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              q.isEmpty
                                  ? 'Bu kategoride ürün bulunamadı.'
                                  : 'Aramanızla eşleşen ürün yok.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.68, crossAxisSpacing: 16, mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      return BlocBuilder<FavoriteCubit, List<Product>>(
                        builder: (context, favorites) {
                          final isFav = favorites.any((fav) => fav.id == product.id);
                          return ProductCard(
                            product: product,
                            isFavorite: isFav,
                            onCardTap: () async {
                              final resonTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailPage(
                                      product: product,
                                      isInitiallyFavorite: context.read<FavoriteCubit>().isFavorite(product),
                                    ),
                                  ),
                                );
                              };
                              resonTap();
                            },
                            onFavoriteTap: () {
                              final willFavorite = !isFav;
                              context.read<FavoriteCubit>().toggleFavorite(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(willFavorite ? "${product.name} favorilere eklendi!" : "${product.name} favorilerden çıkarıldı!"),
                                  backgroundColor: willFavorite ? Colors.redAccent : Colors.grey,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                              if (willFavorite) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const CardPage()),
                                );
                              }
                            },
                            onAddTap: () {
                              context.read<CartCubit>().addToCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("${product.name} sepete eklendi!"),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: const Color(0xFF00B4D8),
                                duration: const Duration(seconds: 1),
                              ));
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CardPage()),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

// Yardımcı bileşenler: SectionHeader, ProductCard
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)));
}

class ProductCard extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onCardTap, onFavoriteTap, onAddTap;
  const ProductCard({super.key, required this.product, required this.isFavorite, required this.onCardTap, required this.onFavoriteTap, required this.onAddTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _favoriteScale;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _favoriteScale = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onCardTap();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Center(
                            child: Hero(
                              tag: widget.product.id,
                              child: Image.asset(
                                widget.product.image,
                                fit: BoxFit.contain,
                                errorBuilder: (_,__,___) => const Icon(Icons.phone_android),
                              ),
                            ),
                          ),
                          // Yeni ürün badge'i
                          if (widget.product.id == "1" || widget.product.id == "5" || widget.product.id == "9")
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "YENİ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          // İndirim badge'i
                          if (widget.product.id == "2" || widget.product.id == "6" || widget.product.id == "10")
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "%30",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            top: 8, 
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                _animationController.forward().then((_) {
                                  _animationController.reverse();
                                });
                                widget.onFavoriteTap();
                              },
                              child: AnimatedBuilder(
                                animation: _favoriteScale,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: widget.isFavorite ? _favoriteScale.value : 1.0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: widget.isFavorite ? Colors.red : Colors.grey,
                                        size: 20,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                          ),
                          Text(
                            widget.product.category,
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                          const SizedBox(height: 8),
                          // Rating kısmı
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CommentsPage(product: widget.product),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                ...List.generate(
                                  5,
                                  (i) => Icon(
                                    Icons.star,
                                    size: 14,
                                    color: i < widget.product.rating.toInt()
                                        ? const Color(0xFFFFB800)
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.product.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${widget.product.reviews})',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${widget.product.price.toStringAsFixed(0)} TL",
                                style: const TextStyle(
                                  color: Color(0xFF00B4D8), 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _animationController.forward().then((_) {
                                    _animationController.reverse();
                                  });
                                  widget.onAddTap();
                                },
                                child: AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _scaleAnimation.value == 0.95 ? 1.1 : 1.0,
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF00B4D8),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF00B4D8).withOpacity(0.3),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}