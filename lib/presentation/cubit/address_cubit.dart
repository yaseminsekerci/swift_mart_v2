import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_mart/domain/entities/saved_address.dart';

class AddressCubit extends Cubit<List<SavedAddress>> {
  AddressCubit()
      : super(const [
          SavedAddress(
            id: 'a1',
            title: 'Ev',
            line: 'Atatürk Cad. No: 12 D: 4',
            city: 'İstanbul',
          ),
          SavedAddress(
            id: 'a2',
            title: 'İş',
            line: 'Maslak Plaza Kat 5',
            city: 'İstanbul',
          ),
        ]);

  int get count => state.length;

  String profileSubtitle() {
    final n = count;
    if (n == 0) return 'Kayıtlı adres yok';
    if (n == 1) return '1 adres';
    return '$n adres';
  }

  void addAddress(SavedAddress address) {
    emit([...state, address]);
  }

  void removeAddress(String id) {
    emit(state.where((a) => a.id != id).toList());
  }
}
