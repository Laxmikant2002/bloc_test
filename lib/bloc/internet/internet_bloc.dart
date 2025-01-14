import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc/internet/internet_event.dart';
import 'package:bloc_test/bloc/internet/internet_state.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;

  InternetBloc() : super(InternetInitialState()) {
    on<InternetLostEvent>((event, emit) => emit(InternetLostState()));
    on<InternetRestoredEvent>((event, emit) => emit(InternetRestoredState()));

    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        add(InternetRestoredEvent());
      } else {
        add(InternetLostEvent());
      }
    });
  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}
