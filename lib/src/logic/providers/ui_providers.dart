import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_providers.g.dart';

// This provider will hold a simple boolean flag.
// It will be `false` by default, and we'll set it to `true`
// once our home screen's entry animation has finished.
@Riverpod(keepAlive: true)
class HomeScreenHasAnimated extends _$HomeScreenHasAnimated {
  @override
  bool build() => false;

  void setHasAnimated() {
    state = true;
  }
}