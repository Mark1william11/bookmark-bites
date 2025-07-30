import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

// A StreamProvider that provides the connectivity status of the device.
@riverpod
Stream<ConnectivityResult> connectivity(ConnectivityRef ref) {
  return Connectivity().onConnectivityChanged.map((results) => results.first);
}