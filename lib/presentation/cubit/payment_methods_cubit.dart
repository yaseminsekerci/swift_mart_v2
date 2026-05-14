import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_mart/domain/entities/saved_payment_method.dart';

class PaymentMethodsCubit extends Cubit<List<SavedPaymentMethod>> {
  PaymentMethodsCubit()
      : super(const [
          SavedPaymentMethod(
            id: 'p1',
            holderName: 'Yasemin Ş.',
            lastFour: '4821',
          ),
        ]);

  int get count => state.length;

  String profileSubtitle() {
    final n = count;
    if (n == 0) return 'Kayıtlı kart yok';
    if (n == 1) return '1 ödeme yöntemi';
    return '$n ödeme yöntemi';
  }

  void addMethod(SavedPaymentMethod method) {
    emit([...state, method]);
  }

  void removeMethod(String id) {
    emit(state.where((p) => p.id != id).toList());
  }
}
