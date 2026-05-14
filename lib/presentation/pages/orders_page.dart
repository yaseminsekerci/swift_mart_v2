import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_mart/domain/entities/order_summary.dart';
import 'package:swift_mart/presentation/cubit/orders_cubit.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Siparişlerim',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E293B),
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: BlocBuilder<OrdersCubit, List<OrderSummary>>(
        builder: (context, orders) {
          if (orders.isEmpty) {
            return _EmptyOrders();
          }

          final sorted = List<OrderSummary>.from(orders)
            ..sort((a, b) => b.placedAt.compareTo(a.placedAt));

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: sorted.length,
            itemBuilder: (context, index) {
              return _OrderCard(order: sorted[index], index: index);
            },
          );
        },
      ),
    );
  }
}

class _EmptyOrders extends StatefulWidget {
  @override
  State<_EmptyOrders> createState() => _EmptyOrdersState();
}

class _EmptyOrdersState extends State<_EmptyOrders>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _bounce;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);
    _bounce = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _fade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: _fade.value,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: _bounce.value,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00B4D8).withOpacity(0.3),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.inventory_2_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Henüz sipariş yok',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Alışveriş yaparak siparişlerinizi\nburada takip edebilirsiniz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF94A3B8),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final OrderSummary order;
  final int index;
  const _OrderCard({required this.order, required this.index});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: Duration(milliseconds: 400 + widget.index * 80),
      vsync: this,
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: o.statusColor.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // İkon
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                o.statusColor.withOpacity(0.15),
                                o.statusColor.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _statusIcon(o.status),
                            color: o.statusColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Sipariş bilgisi
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                o.orderNumber,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                orderRelativeTimeTr(o.placedAt),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Fiyat
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${o.amountInTry.toStringAsFixed(0)} TL',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: o.statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                o.statusLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: o.statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // İlerleme çubuğu
                    const SizedBox(height: 14),
                    _OrderProgress(status: o.status),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _statusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return Icons.pending_rounded;
      case OrderStatus.shipping:
        return Icons.local_shipping_rounded;
      case OrderStatus.delivered:
        return Icons.check_circle_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }
}

class _OrderProgress extends StatelessWidget {
  final OrderStatus status;
  const _OrderProgress({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = [
      OrderStatus.processing,
      OrderStatus.shipping,
      OrderStatus.delivered,
    ];

    if (status == OrderStatus.cancelled) {
      return Row(
        children: [
          const Icon(Icons.cancel_rounded, color: Colors.redAccent, size: 16),
          const SizedBox(width: 8),
          const Text(
            'Sipariş iptal edildi',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    final currentStep = steps.indexOf(status);

    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Bağlantı çizgisi
          final stepIndex = i ~/ 2;
          final isCompleted = stepIndex < currentStep;
          return Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: isCompleted
                    ? const LinearGradient(
                        colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
                      )
                    : null,
                color: isCompleted ? null : const Color(0xFFE2E8F0),
              ),
            ),
          );
        }

        final stepIndex = i ~/ 2;
        final isCompleted = stepIndex <= currentStep;
        final isCurrent = stepIndex == currentStep;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isCurrent ? 24 : 20,
          height: isCurrent ? 24 : 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isCompleted
                ? const LinearGradient(
                    colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isCompleted ? null : const Color(0xFFE2E8F0),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: const Color(0xFF00B4D8).withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: isCompleted
              ? const Icon(Icons.check_rounded,
                  color: Colors.white, size: 12)
              : null,
        );
      }),
    );
  }
}
