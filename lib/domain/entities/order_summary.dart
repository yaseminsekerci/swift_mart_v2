import 'package:flutter/material.dart';

enum OrderStatus { processing, shipping, delivered, cancelled }

class OrderSummary {
  final String id;
  final String orderNumber;
  final DateTime placedAt;
  final OrderStatus status;
  final double amountInTry;

  const OrderSummary({
    required this.id,
    required this.orderNumber,
    required this.placedAt,
    required this.status,
    required this.amountInTry,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.processing:
        return 'İşleniyor';
      case OrderStatus.delivered:
        return 'Teslim edildi';
      case OrderStatus.shipping:
        return 'Kargoda';
      case OrderStatus.cancelled:
        return 'İptal edildi';
    }
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.processing:
        return const Color(0xFFEAB308);
      case OrderStatus.delivered:
        return const Color(0xFF16A34A);
      case OrderStatus.shipping:
        return const Color(0xFF00B4D8);
      case OrderStatus.cancelled:
        return const Color(0xFFEF4444);
    }
  }
}

String orderRelativeTimeTr(DateTime placedAt) {
  final now = DateTime.now();
  final diff = now.difference(placedAt);
  if (diff.isNegative) return 'Az önce';
  if (diff.inDays >= 14) return '${diff.inDays ~/ 7} hafta önce';
  if (diff.inDays >= 7) return '1 hafta önce';
  if (diff.inDays >= 1) return '${diff.inDays} gün önce';
  if (diff.inHours >= 1) return '${diff.inHours} saat önce';
  if (diff.inMinutes >= 1) return '${diff.inMinutes} dk önce';
  return 'Az önce';
}
