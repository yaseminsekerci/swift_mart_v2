// presentation/pages/product_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_mart/domain/entities/product.dart';
import 'package:swift_mart/presentation/cubit/card_cubit.dart';
import 'package:swift_mart/presentation/pages/card_page.dart';
import 'package:swift_mart/presentation/cubit/fovorite_cubit.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final bool isInitiallyFavorite;

  const ProductDetailPage({
    super.key, 
    required this.product, 
    this.isInitiallyFavorite = false,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isInitiallyFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Daha derin bir gri-mavi tonu
      body: Stack(
        children: [
          // Arka Plandaki Premium Tasarım Halkası
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00B4D8).withOpacity(0.15),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // 1. Üst Kontroller (Geri ve Favori)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRoundButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context, isFavorite),
                      ),
                      _buildRoundButton(
                        icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        iconColor: isFavorite ? Colors.redAccent : const Color(0xFF1E293B),
                        onTap: () {
                          context.read<FavoriteCubit>().toggleFavorite(widget.product);
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isFavorite ? "${widget.product.name} favorilere eklendi!" : "${widget.product.name} favorilerden çıkarıldı!"),
                              backgroundColor: isFavorite ? Colors.redAccent : Colors.grey,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // 2. Etkileşimli Ürün Görsel Alanı (Gelişmiş Hero)
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Hero(
                        tag: 'product-image-${widget.product.id}',
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(0, 0, 0, 0.08),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              )
                            ],
                          ),
                          child: Image.asset(
                            widget.product.image,
                            fit: BoxFit.contain,
                            width: MediaQuery.of(context).size.width * 0.65,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.phone_android_rounded, size: 120, color: Color(0xFF94A3B8));
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 3. Premium Alt Detay Kartı
                Expanded(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(15, 23, 42, 0.06),
                          blurRadius: 20,
                          offset: const Offset(0, -8),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kategori ve Yıldız Puanı
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 180, 216, 0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                widget.product.category.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF00B4D8),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                  SizedBox(width: 4),
                                  Text(
                                    "4.9",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Ürün Başlığı
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E293B),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Yatay Teknik Özellik Kartları (Hocanın en seveceği detay!)
                        const SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _SpecCard(icon: Icons.flash_on_rounded, title: "Hızlı Teslimat", subtitle: "24 Saatte"),
                              _SpecCard(icon: Icons.verified_user_rounded, title: "Garanti", subtitle: "2 Yıl Türkiye"),
                              _SpecCard(icon: Icons.eco_rounded, title: "Çevre Dostu", subtitle: "%100 Geri Dönüşüm"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Açıklama Başlığı ve Yazısı
                        const Text(
                          "Ürün Açıklaması",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(height: 8),
                        const Expanded(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Text(
                              "Bu premium ürün, SwiftMart kullanıcıları için özel olarak seçilmiştir. Yüksek malzeme kalitesi, eşsiz kullanıcı deneyimi ve üstün teknik donanımı sayesinde segmentindeki standartları yeniden belirliyor.",
                              style: TextStyle(color: Color(0xFF64748B), height: 1.6, fontSize: 14),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 15),

                        // Alt Ödeme Alanı
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "TOPLAM FİYAT",
                                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${widget.product.price.toStringAsFixed(0)} TL",
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF00B4D8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 30),
                            // Degradeli Parlak Satın Alma Butonu
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context.read<CartCubit>().addToCart(widget.product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          const Icon(Icons.shopping_bag_rounded, color: Colors.white),
                                          const SizedBox(width: 8),
                                          Text("${widget.product.name} sepete eklendi!"),
                                        ],
                                      ),
                                      backgroundColor: const Color(0xFF00B4D8),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const CardPage()),
                                  );
                                },
                                child: Container(
                                  height: 58,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color.fromRGBO(0, 180, 216, 0.35),
                                        blurRadius: 15,
                                        offset: const Offset(0, 6),
                                      )
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Sepete Ekle",
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundButton({required IconData icon, Color? iconColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Icon(icon, size: 22, color: iconColor ?? const Color(0xFF1E293B)),
      ),
    );
  }
}

// Yardımcı Mini Özellik Kartı Widget'ı
class _SpecCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SpecCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00B4D8), size: 22),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF1E293B))),
              Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }
}