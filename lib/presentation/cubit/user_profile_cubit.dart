import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_mart/domain/entities/user_profile.dart';

class UserProfileCubit extends Cubit<UserProfile> {
  UserProfileCubit()
      : super(
          const UserProfile(
            displayName: 'Yasemin Şekerci',
            email: 'yasemin@email.com',
          ),
        );

  void updateProfile({required String displayName, required String email}) {
    emit(UserProfile(displayName: displayName.trim(), email: email.trim()));
  }
}
