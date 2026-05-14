// presentation/pages/main_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:swift_mart/presentation/pages/home_page.dart';
import 'package:swift_mart/presentation/pages/card_page.dart';
import 'package:swift_mart/presentation/pages/favorites_page.dart';
import 'package:swift_mart/presentation/pages/profile_page.dart';
import 'package:swift_mart/presentation/cubit/card_cubit.dart';
import 'package:swift_mart/domain/entities/product.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late List<AnimationController> _iconControllers;
  late List<Animation<double>> _iconScales;

  final List<Widget> _pages = [
    HomePage(),
    const FavoritesPage(),
    const CardPage(),
    ProfilePage(),
  ];

  final List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.home_rounded,
      activeIcon: Icons.home_rounded,
      label: 'Ana Sayfa',
      color: const Color(0xFF00B4D8),
    ),
    _NavItem(
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'Favoriler',
      color: const Color(0xFFE91E63),
    ),
    _NavItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart_rounded,
      label: 'Sepet',
      color: const Color(0xFF00B4D8),
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profil',
      color: const Color(0xFF7C3AED),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _iconControllers = List.generate(
      4,
      (i) => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );
    _iconScales = _iconControllers.map((c) {
      return Tween<double>(begin: 1.0, end: 1.25).animate(
        CurvedAnimation(parent: c, curve: Curves.elasticOut),
      );
    }).toList();
    _iconControllers[0].forward();
  }

  @override
  void dispose() {
    for (final c in _iconControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTap(int index) {
    if (_currentIndex != index) {
      _iconControllers[_currentIndex].reverse();
      setState(() => _currentIndex = index);
      _iconControllers[index].forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(color: const Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isActive = _currentIndex == index;

              // Sepet (index 2) için badge göster
              if (index == 2) {
                return Expanded(
                  child: BlocBuilder<CartCubit, List<Product>>(
                    builder: (context, state) {
                      return _buildNavItem(
                        index: index,
                        item: item,
                        isActive: isActive,
                        badge: state.isNotEmpty ? '${state.length}' : null,
                      );
                    },
                  ),
                );
              }

              return Expanded(
                child: _buildNavItem(
                  index: index,
                  item: item,
                  isActive: isActive,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required _NavItem item,
    required bool isActive,
    String? badge,
  }) {
    return GestureDetector(
      onTap: () => _onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _iconScales[index],
        builder: (context, child) {
          return Transform.scale(
            scale: _iconScales[index].value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isActive
                            ? item.color.withOpacity(0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        isActive ? item.activeIcon : item.icon,
                        color: isActive ? item.color : const Color(0xFF94A3B8),
                        size: 24,
                      ),
                    ),
                    if (badge != null)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(
                              minWidth: 18, minHeight: 18),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w500,
                    color:
                        isActive ? item.color : const Color(0xFF94A3B8),
                  ),
                  child: Text(item.label),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
  });
}