import 'package:bookmark_bites/firebase_options.dart';
import 'package:bookmark_bites/src/presentation/theme/app_theme.dart';
import 'package:bookmark_bites/src/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: BookMarkBitesApp(),
    ),
  );
}

// Changed to a ConsumerWidget to read providers.
class BookMarkBitesApp extends ConsumerWidget {
  const BookMarkBitesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the routerProvider to get the GoRouter instance.
    final router = ref.watch(routerProvider);

    // Use MaterialApp.router to integrate GoRouter.
    return MaterialApp.router(
      title: 'BookMark Bites',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,

      // Router configuration
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}