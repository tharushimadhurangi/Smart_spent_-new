
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'auth_widgets.dart';

class CredentialsPage extends StatefulWidget {
  const CredentialsPage({super.key});

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> {
  String? selectedAccount;

  void finishSetup() {
    if (selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can skip this step and add accounts later.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$selectedAccount selected.'),
      ),
    );

    // Connect bank/card linking functionality here later.
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 25),
        child: Column(
          children: [
            const AuthBackButton(),

            const AuthHeading(
              title: 'Add Credentials',
              subtitle:
                  'Link your financial accounts to track\nyour expenses and manage your budget.',
            ),

            const SizedBox(height: 35),

            Container(
              height: 175,
              width: double.infinity,
              alignment: Alignment.center,
              child: const Icon(
                Icons.account_balance,
                size: 115,
                color: AppColors.secondary,
              ),
            ),

            const SizedBox(height: 20),

            _accountOption(
              icon: Icons.account_balance,
              title: 'Add Bank Account',
              value: 'Bank Account',
            ),

            const SizedBox(height: 15),

            _accountOption(
              icon: Icons.credit_card,
              title: 'Add Credit / Debit Card',
              value: 'Credit / Debit Card',
            ),

            const SizedBox(height: 40),

            AuthButton(
              title: 'Next',
              onPressed: finishSetup,
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () {
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                );
              },
              child: const Text(
                'Skip for now',
                style: TextStyle(
                  color: AppColors.mutedText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountOption({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final isSelected = selectedAccount == value;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        setState(() => selectedAccount = value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 17),
        decoration: BoxDecoration(
          color: AppColors.input,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColors.secondary
                : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.secondary,
              size: 27,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle
                  : Icons.arrow_forward_ios,
              color: isSelected
                  ? AppColors.secondary
                  : Colors.white,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
}
