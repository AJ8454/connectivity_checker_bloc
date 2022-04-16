import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:connectivity_checker_bloc/blocs/internet_bloc/inernet_event.dart';
import 'package:connectivity_checker_bloc/blocs/internet_bloc/internet_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;
  // bloc initialization
  InternetBloc() : super(InternetInitialState()) {
    // events --> state emit
    on<InternetLostEvent>((event, emit) => emit(InternetLostSate()));

    on<InternetGainedEvent>((event, emit) => emit(InternetGainedSate()));

    _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        add(InternetGainedEvent());
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
