import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_mart/domain/entities/saved_payment_method.dart';
import 'package:swift_mart/presentation/cubit/payment_methods_cubit.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  void _openAddSheet(BuildContext context) {
    final holderCtrl = TextEditingController();
    final lastFourCtrl = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
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
                  'Kart ekle (demo)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Gerçek kart bilgisi istemiyoruz; sadece kart üzerindeki isim ve son 4 hane yeterli.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.35),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: holderCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Kart üzerindeki isim',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: lastFourCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Son 4 hane',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    final holder = holderCtrl.text.trim();
                    final four = lastFourCtrl.text.trim();
                    if (holder.isEmpty || four.length != 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('İsim ve son 4 hane gereklidir.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    context.read<PaymentMethodsCubit>().addMethod(
                          SavedPaymentMethod(
                            id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                            holderName: holder,
                            lastFour: four,
                          ),
                        );
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ödeme yöntemi eklendi'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Color(0xFF00B4D8),
                      ),
                    );
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Ödeme yöntemleri',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<PaymentMethodsCubit, List<SavedPaymentMethod>>(
        builder: (context, methods) {
          if (methods.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.payment_outlined,
                      size: 72,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Kayıtlı ödeme yöntemi yok',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Demo için kart üzerindeki isim ve son 4 haneyi ekleyebilirsiniz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
            itemCount: methods.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final m = methods[index];
              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF4CAF50).withValues(alpha: 0.12),
                    child: const Icon(
                      Icons.credit_card,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  title: Text(
                    m.maskLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  subtitle: Text(
                    m.holderName,
                    style: const TextStyle(color: Color(0xFF64748B)),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    color: Colors.redAccent,
                    onPressed: () {
                      context.read<PaymentMethodsCubit>().removeMethod(m.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ödeme yöntemi silindi'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddSheet(context),
        backgroundColor: const Color(0xFF00B4D8),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Kart ekle',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
