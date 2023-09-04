import 'dart:async';

import 'package:bloc/bloc.dart';
import '/repositories/auth/auth_repo.dart';
import '/models/app_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<AppUser?> _userSubscription;

  AuthBloc({@required AuthRepository? authRepository})
      : _authRepository = authRepository!,
        super(AuthState.unknown()) {
    _userSubscription = _authRepository.onAuthChanges
        .listen((user) => add(AuthUserChanged(user: user)));
    on<AuthEvent>((event, emit) async {
      if (event is AuthUserChanged) {
        emit(
          event.user != null
              ? AuthState.authenticated(user: event.user)
              : AuthState.unAuthenticated(),
        );
      } else if (event is AuthLogoutRequested) {
        await _authRepository.signOut();
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  // Stream<AuthState> mapEventToState(
  //   AuthEvent event,
  // ) async* {
  //   if (event is AuthUserChanged) {
  //     yield* _mapUserChangedToState(event);
  //   } else if (event is AuthLogoutRequested) {
  //     await _authRepository.signOut();
  //   }
  // }

  // Stream<AuthState> _mapUserChangedToState(AuthUserChanged event) async* {
  //   yield event.user != null
  //       ? AuthState.authenticated(user: event.user)
  //       : AuthState.unAuthenticated();
  // }
}
