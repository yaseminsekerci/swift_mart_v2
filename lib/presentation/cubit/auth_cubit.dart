import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState(isAuthenticated: false));

  void login(String email, String password) {
    // Basit auth kontrolü (gerçekte API çağrısı yapılmalı)
    if (email.isNotEmpty && password.isNotEmpty) {
      emit(AuthState(isAuthenticated: true, email: email));
    }
  }

  void register(String email, String password, String name) {
    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      emit(AuthState(isAuthenticated: true, email: email, name: name));
    }
  }

  void logout() {
    emit(const AuthState(isAuthenticated: false));
  }

  void updateProfilePhoto(String photoUrl) {
    emit(state.copyWith(profilePhotoUrl: photoUrl));
  }
}

class AuthState {
  final bool isAuthenticated;
  final String? email;
  final String? name;
  final String? profilePhotoUrl;

  const AuthState({
    required this.isAuthenticated,
    this.email,
    this.name,
    this.profilePhotoUrl,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? email,
    String? name,
    String? profilePhotoUrl,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      email: email ?? this.email,
      name: name ?? this.name,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
    );
  }
}
