
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final internetProvider = StateNotifierProvider<InternetNotifier,InternetState>((ref)=>InternetNotifier());

class InternetState{
  final bool isConnected;

  InternetState({
    this.isConnected = true
  });

  InternetState copyWith({
    bool? isConnected
  }){
    return InternetState(
      isConnected: isConnected ?? this.isConnected
    );
  }
}

class InternetNotifier extends StateNotifier<InternetState>{

  late StreamSubscription<List<ConnectivityResult>> _internetSubscription;

  InternetNotifier() : super(InternetState()){
    _internetSubscription = Connectivity().onConnectivityChanged.listen(updateInternetConnection);
    checkConnection();
  }

  Future<void> checkConnection()async{
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    await updateInternetConnection(result);
  }

  Future<void> updateInternetConnection(List<ConnectivityResult> result)async{
    bool isNowConnected = result.isNotEmpty && result.any((i)=>i!=ConnectivityResult.none);

    if(isNowConnected!=state.isConnected){
      state = state.copyWith(
        isConnected: isNowConnected
      );
    }
  }

  @override
  void dispose() {
    _internetSubscription.cancel();
    super.dispose();
  }
}