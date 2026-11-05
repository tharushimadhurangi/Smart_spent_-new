
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'auth_widgets.dart';
import 'setup_profile_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void register() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SetupProfilePage(
          fullName: nameController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const AuthBackButton(),

              const SizedBox(height: 25),

              const AuthHeading(
                title: 'Create Account',
                subtitle:
                    'Join SmartSpend and take control\nof your money.',
              ),

              const SizedBox(height: 35),

              const Icon(
                Icons.assignment_ind_outlined,
                color: AppColors.secondary,
                size: 100,
              ),

              const SizedBox(height: 25),

              AuthTextField(
                hint: 'Full Name',
                icon: Icons.person_outline,
                controller: nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              AuthTextField(
                hint: 'Email Address',
                icon: Icons.mail_outline,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r'^[\w.+-]+@[\w-]+\.[\w.-]+$',
                  ).hasMatch(value.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              AuthTextField(
                hint: 'Password',
                icon: Icons.lock_outline,
                password: true,
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please create a password';
                  }
                  if (value.length < 8) {
                    return 'Use at least 8 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              AuthTextField(
                hint: 'Confirm Password',
                icon: Icons.lock_outline,
                password: true,
                controller: confirmController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              AuthButton(
                title: 'Register Account',
                onPressed: register,
              ),

              const SizedBox(height: 28),

              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
