import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_mart/domain/entities/order_summary.dart';
import 'package:swift_mart/domain/entities/product.dart';
import 'package:swift_mart/domain/entities/saved_address.dart';
import 'package:swift_mart/domain/entities/saved_payment_method.dart';
import 'package:swift_mart/presentation/cubit/address_cubit.dart';
import 'package:swift_mart/presentation/cubit/card_cubit.dart';
import 'package:swift_mart/presentation/cubit/orders_cubit.dart';
import 'package:swift_mart/presentation/cubit/payment_methods_cubit.dart';
import 'package:swift_mart/presentation/pages/address_page.dart';
import 'package:swift_mart/presentation/pages/orders_page.dart';
import 'package:swift_mart/presentation/pages/payment_methods_page.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  SavedAddress? _selectedAddress;
  SavedPaymentMethod? _selectedPaymentMethod;
  final Map<String, int> _quantities = {};

  void _completeOrder(double totalPrice) {
    final orderNumber =
        '#SM-${DateTime.now().millisecondsSinceEpoch.remainder(100000)}';
    final order = OrderSummary(
      id: 'o_${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: orderNumber,
      placedAt: DateTime.now(),
      status: OrderStatus.shipping,
      amountInTry: totalPrice,
    );

    context.read<OrdersCubit>().addOrder(order);
    context.read<CartCubit>().clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Siparişiniz alındı! Kargoya verildi.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OrdersPage()),
    );
  }

  void _showCheckoutSheet(double totalPrice) {
    final addresses = context.read<AddressCubit>().state;
    final methods = context.read<PaymentMethodsCubit>().state;
    SavedAddress? selectedAddress =
        _selectedAddress ?? (addresses.isNotEmpty ? addresses.first : null);
    SavedPaymentMethod? selectedMethod =
        _selectedPaymentMethod ?? (methods.isNotEmpty ? methods.first : null);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, sheetSetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ödeme ve teslimat',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Lütfen teslimat adresi ve ödeme yöntemini seçin. Ardından siparişi onaylayın.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Teslimat Adresi',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    if (addresses.isEmpty)
                      Material(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        child: ListTile(
                          leading: const Icon(
                            Icons.location_off_outlined,
                            color: Colors.grey,
                          ),
                          title: const Text('Adres yok'),
                          subtitle: const Text(
                            'Lütfen önce bir adres ekleyin.',
                          ),
                          trailing: TextButton(
                            onPressed: () {
                              Navigator.pop(sheetContext);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddressPage(),
                                ),
                              );
                            },
                            child: const Text('Adres Ekle'),
                          ),
                        ),
                      )
                    else
                      RadioGroup<SavedAddress>(
                        groupValue: selectedAddress,
                        onChanged: (value) {
                          sheetSetState(() {
                            selectedAddress = value;
                          });
                        },
                        child: Column(
                          children: addresses.map((address) {
                            return RadioListTile<SavedAddress>(
                              value: address,
                              title: Text(address.title),
                              subtitle: Text(address.oneLine),
                              selected: selectedAddress == address,
                            );
                          }).toList(),
                        ),
                      ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ödeme Yöntemi',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    if (methods.isEmpty)
                      Material(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        child: ListTile(
                          leading: const Icon(
                            Icons.payment_outlined,
                            color: Colors.grey,
                          ),
                          title: const Text('Ödeme yöntemi yok'),
                          subtitle: const Text(
                            'Lütfen önce bir ödeme yöntemi ekleyin.',
                          ),
                          trailing: TextButton(
                            onPressed: () {
                              Navigator.pop(sheetContext);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PaymentMethodsPage(),
                                ),
                              );
                            },
                            child: const Text('Kart Ekle'),
                          ),
                        ),
                      )
                    else
                      RadioGroup<SavedPaymentMethod>(
                        groupValue: selectedMethod,
                        onChanged: (value) {
                          sheetSetState(() {
                            selectedMethod = value;
                          });
                        },
                        child: Column(
                          children: methods.map((method) {
                            return RadioListTile<SavedPaymentMethod>(
                              value: method,
                              title: Text(method.maskLabel),
                              subtitle: Text(method.holderName),
                              selected: selectedMethod == method,
                            );
                          }).toList(),
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B4D8),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed:
                          addresses.isEmpty ||
                              methods.isEmpty ||
                              selectedAddress == null ||
                              selectedMethod == null
                          ? null
                          : () {
                              setState(() {
                                _selectedAddress = selectedAddress;
                                _selectedPaymentMethod = selectedMethod;
                              });
                              Navigator.pop(sheetContext);
                              _completeOrder(totalPrice);
                            },
                      child: const Text(
                        'Siparişi Onayla',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      child: const Text('İptal'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Sepetim ',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
        ),
        backgroundColor: theme.cardTheme.color,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubit, List<Product>>(
        builder: (context, cartProducts) {
          if (cartProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurface.withAlpha(102),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sepetiniz henüz boş.',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withAlpha(153),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          final totalPrice = cartProducts.fold<double>(
            0,
            (sum, item) => sum + item.price,
          );
          final selectedAddress = _selectedAddress;
          final selectedMethod = _selectedPaymentMethod;

          return Column(
            children: [
              if (selectedAddress != null || selectedMethod != null)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (selectedAddress != null) ...[
                        const Text(
                          'Seçili Adres',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          selectedAddress.oneLine,
                          style: const TextStyle(color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (selectedMethod != null) ...[
                        const Text(
                          'Seçili Ödeme Yöntemi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          selectedMethod.maskLabel,
                          style: const TextStyle(color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          selectedMethod.holderName,
                          style: const TextStyle(color: Color(0xFF64748B)),
                        ),
                      ],
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartProducts.length,
                  itemBuilder: (context, index) {
                    final p = cartProducts[index];
                    _quantities.putIfAbsent(p.id, () => 1);
                    final quantity = _quantities[p.id] ?? 1;
                    
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: const Color(0xFFF8FAFC),
                                    ),
                                    child: Image.asset(p.image, fit: BoxFit.contain),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Text(
                                          p.category,
                                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${p.price.toStringAsFixed(0)} TL',
                                          style: const TextStyle(
                                            color: Color(0xFF00B4D8),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      context.read<CartCubit>().removeFromCart(p);
                                      _quantities.remove(p.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${p.name} sepetten çıkarıldı',
                                          ),
                                          backgroundColor: Colors.redAccent,
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Quantity selector
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, color: Color(0xFF00B4D8)),
                                      onPressed: quantity > 1
                                          ? () {
                                              setState(() {
                                                _quantities[p.id] = quantity - 1;
                                              });
                                            }
                                          : null,
                                    ),
                                    Text(
                                      '$quantity',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, color: Color(0xFF00B4D8)),
                                      onPressed: () {
                                        setState(() {
                                          _quantities[p.id] = quantity + 1;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Toplam Ödeme',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${totalPrice.toStringAsFixed(0)} TL',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              color: Color(0xFF00B4D8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00B4D8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 5,
                              shadowColor: const Color(0x4D00B4D8),
                            ),
                            onPressed: () => _showCheckoutSheet(totalPrice),
                            child: const Text(
                              'Alışverişi Tamamla',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
