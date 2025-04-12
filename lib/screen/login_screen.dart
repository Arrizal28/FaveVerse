import 'package:faveverse/style/colors/fv_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common.dart';
import '../data/model/user.dart';
import '../provider/auth_provider.dart';
import '../widget/auth_button.dart';
import '../widget/custom_form_text_field.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AuthProvider authProvider) async {
    if (formKey.currentState!.validate()) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      final user = User(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      try {
        final result = await authProvider.login(user);
        if (result) {
          scaffoldMessenger.showSnackBar(
             SnackBar(content: Text(AppLocalizations.of(context)!.loginSuccessMessage)),
          );
          await Future.delayed(const Duration(seconds: 2));
          widget.onLogin();
        } else {
          scaffoldMessenger.showSnackBar(
             SnackBar(content: Text(AppLocalizations.of(context)!.incorrectCredentialsMessage)),
          );
        }
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.loginFailedPrefix)),
        );
      }
    }
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/faveverselogodesign.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.loginTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: emailController,
                  hintText: AppLocalizations.of(context)!.emailHint,
                  prefixIcon: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.emailEmptyError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: passwordController,
                  hintText: AppLocalizations.of(context)!.passwordHint,
                  obscureText: _obscureText,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: _toggleVisibility,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.passwordEmptyError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return authProvider.isLoadingLogin
                        ? Center(
                          child: CircularProgressIndicator(
                            color: FvColors.blueyoung.color,
                          ),
                        )
                        : AuthButton(
                          onPressed: () => _handleLogin(authProvider),
                          text: AppLocalizations.of(context)!.signInButton,
                        );
                  },
                ),
                Spacer(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: RichText(
                      text: TextSpan(
                        text: AppLocalizations.of(context)!.noAccountText,
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!.signUpLink,
                            style: TextStyle(color: FvColors.blue.color),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    widget.onRegister();
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
