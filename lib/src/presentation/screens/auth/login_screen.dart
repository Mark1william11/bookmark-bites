import 'package:bookmark_bites/src/logic/providers/auth_providers.dart';
import 'package:bookmark_bites/src/presentation/widgets/custom_text_field.dart';
import 'package:bookmark_bites/src/presentation/widgets/password_text_field.dart';
import 'package:bookmark_bites/src/routing/app_routes.dart';
import 'package:bookmark_bites/src/utils/firebase_auth_exception_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final authState = ref.watch(authNotifierProvider);

    // Listen to the auth state for showing errors or success messages
    ref.listen<AsyncValue<void>>(
      authNotifierProvider,
      (_, state) {
        state.whenOrNull(
          error: (error, __) {
            // Use our new exception handler
            if (error is FirebaseAuthException) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(FirebaseAuthExceptionHandler.getMessage(error))),
              );
            }
          },
        );
      },
    );

    void submit() {
      if (formKey.currentState?.validate() ?? false) {
        ref.read(authNotifierProvider.notifier).signInWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'BookMark Bites',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome back! Please sign in.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 48),
                  CustomTextField(
                    controller: emailController,
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => (value?.isEmpty ?? true) ? 'Please enter an email' : null,
                  ),
                  const SizedBox(height: 16),
                  PasswordTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    validator: (value) => (value?.isEmpty ?? true) ? 'Please enter a password' : null,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : submit,
                    child: authState.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Sign In'),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.push(AppRoutes.register);
                            },
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}