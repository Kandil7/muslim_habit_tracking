import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Custom BlocObserver to log all Bloc events, state changes, errors, and transitions
class CustomBlocObserver extends BlocObserver {
  final bool verbose;

  /// Constructor with optional verbose parameter to control logging detail
  const CustomBlocObserver({this.verbose = false});

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (verbose) {
      log('onChange(${bloc.runtimeType}): $change');
    } else {
      log(
        '${bloc.runtimeType} changed from ${change.currentState.runtimeType} to ${change.nextState.runtimeType}',
      );
    }
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('onCreate: ${bloc.runtimeType}');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('onClose: ${bloc.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log('onError(${bloc.runtimeType}): $error');
    log(stackTrace.toString());
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('onEvent(${bloc.runtimeType}): ${event.runtimeType}');
    if (verbose) {
      log('Event details: $event');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (verbose) {
      log('onTransition(${bloc.runtimeType}): $transition');
    } else {
      log(
        '${bloc.runtimeType}: ${transition.event.runtimeType} -> ${transition.currentState.runtimeType} -> ${transition.nextState.runtimeType}',
      );
    }
  }
}
