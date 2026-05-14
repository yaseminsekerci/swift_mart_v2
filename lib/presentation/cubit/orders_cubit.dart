import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_mart/domain/entities/order_summary.dart';

class OrdersCubit extends Cubit<List<OrderSummary>> {
  OrdersCubit() : super(_seedOrders);

  static final List<OrderSummary> _seedOrders = _buildSeed();

  static List<OrderSummary> _buildSeed() {
    final now = DateTime.now();
    return [
      OrderSummary(
        id: 'o1',
        orderNumber: '#SM-24089',
        placedAt: now.subtract(const Duration(days: 2)),
        status: OrderStatus.delivered,
        amountInTry: 12750,
      ),
      OrderSummary(
        id: 'o2',
        orderNumber: '#SM-24076',
        placedAt: now.subtract(const Duration(days: 5)),
        status: OrderStatus.delivered,
        amountInTry: 8990,
      ),
      OrderSummary(
        id: 'o3',
        orderNumber: '#SM-24051',
        placedAt: now.subtract(const Duration(days: 9)),
        status: OrderStatus.cancelled,
        amountInTry: 4500,
      ),
      OrderSummary(
        id: 'o4',
        orderNumber: '#SM-24012',
        placedAt: now.subtract(const Duration(hours: 6)),
        status: OrderStatus.shipping,
        amountInTry: 32999,
      ),
    ];
  }

  int get orderCount => state.length;

  List<OrderSummary> get recentOrders {
    final sorted = List<OrderSummary>.from(state)
      ..sort((a, b) => b.placedAt.compareTo(a.placedAt));
    return sorted.take(3).toList();
  }

  String ordersSubtitle() {
    final n = orderCount;
    if (n == 0) return 'Henüz sipariş yok';
    return '$n sipariş';
  }

  String recentSectionSubtitle() {
    final n = orderCount;
    if (n == 0) return 'Sipariş verdiğinizde burada görünür';
    if (n == 1) return 'Son siparişiniz';
    return 'Son ${recentOrders.length} siparişiniz';
  }

  void addOrder(OrderSummary order) {
    emit([...state, order]);
  }
}
