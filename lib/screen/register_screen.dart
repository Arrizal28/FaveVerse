import 'package:faveverse/style/colors/fv_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common.dart';
import '../data/model/user.dart';
import '../provider/auth_provider.dart';
import '../widget/auth_button.dart';
import '../widget/custom_form_text_field.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onRegister;
  final Function() onLogin;

  const RegisterScreen({
    super.key,
    required this.onRegister,
    required this.onLogin,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    nameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    emailController.removeListener(_updateButtonState);
    passwordController.removeListener(_updateButtonState);
    nameController.removeListener(_updateButtonState);
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister(AuthProvider authProvider) async {
    if (formKey.currentState!.validate()) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      final user = User(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      try {
        final result = await authProvider.register(user);
        if (result) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.registerSuccessMessage,
              ),
            ),
          );
          await Future.delayed(const Duration(seconds: 2));
          widget.onRegister();
          emailController.clear();
          passwordController.clear();
          nameController.clear();

          setState(() {
            isButtonEnabled = false;
          });
        } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.registerFailedPrefix),
            ),
          );
        }
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorWithMessage(e.toString())),
          ),
        );
      }
    }
  }

  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _updateButtonState() {
    final isEmailFilled = emailController.text.trim().isNotEmpty;
    final isPasswordValid = passwordController.text.length >= 8;

    setState(() {
      isButtonEnabled = isEmailFilled && isPasswordValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.registerTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: nameController,
                hintText: AppLocalizations.of(context)!.nameHint,
                prefixIcon: const Icon(Icons.person_outline),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.nameEmptyError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
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
                  return authProvider.isLoadingRegister
                      ? Center(
                        child: CircularProgressIndicator(
                          color: FvColors.blueyoung.color,
                        ),
                      )
                      : AuthButton(
                        onPressed:
                            isButtonEnabled
                                ? () => _handleRegister(authProvider)
                                : null,
                        text: AppLocalizations.of(context)!.signUpButton,
                      );
                },
              ),
              Spacer(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: RichText(
                    text: TextSpan(
                      text: AppLocalizations.of(context)!.haveAccountText,
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.signInLink,
                          style: TextStyle(color: FvColors.blue.color),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  emailController.clear();
                                  passwordController.clear();
                                  nameController.clear();

                                  setState(() {
                                    isButtonEnabled = false;
                                  });
                                  widget.onLogin();
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
    );
  }
}
