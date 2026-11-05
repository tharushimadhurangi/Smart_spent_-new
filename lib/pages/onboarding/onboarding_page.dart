
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../auth/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      'title': 'Track Your Spending',
      'description':
          'Keep an eye on your income and expenses in one place.',
      'icon': Icons.analytics_outlined,
      'color': Color(0xFF9B42FF),
      'secondaryIcon': Icons.account_balance_wallet,
    },
    {
      'title': 'Plan & Save',
      'description':
          'Set financial goals, create budgets, and build better habits.',
      'icon': Icons.track_changes,
      'color': Color(0xFFB52CFA),
      'secondaryIcon': Icons.calendar_month,
    },
    {
      'title': 'Grow Financially',
      'description':
          'Make smarter money decisions and achieve your goals faster.',
      'icon': Icons.trending_up,
      'color': Color(0xFF9B42FF),
      'secondaryIcon': Icons.savings_outlined,
    },
  ];

  void nextPage() {
    if (currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      goToLogin();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding() {
    goToLogin();
  }

  void goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Decoration
            Positioned(
              bottom: -100,
              left: -50,
              child: Container(
                width: 250,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),

            Column(
              children: [
                // Skip Button
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: skipOnboarding,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: AppColors.mutedText,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                // Onboarding Pages
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingData.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final item = onboardingData[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),

                            // Illustration
                            Container(
                              width: 260,
                              height: 260,
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 35,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    item['secondaryIcon'],
                                    size: 150,
                                    color: AppColors.border,
                                  ),
                                  Positioned(
                                    right: 35,
                                    bottom: 35,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            AppColors.secondary,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        item['icon'],
                                        size: 75,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 55),

                            // Title
                            Text(
                              item['title'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 15),

                            // Description
                            Text(
                              item['description'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.mutedText,
                                fontSize: 16,
                                height: 1.6,
                              ),
                            ),

                            const Spacer(),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Navigation
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      SizedBox(
                        width: 55,
                        height: 55,
                        child: currentPage == 0
                            ? const SizedBox()
                            : OutlinedButton(
                                onPressed: previousPage,
                                style: OutlinedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  side: const BorderSide(
                                    color: AppColors.secondary,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                      ),

                      // Page Indicators
                      Row(
                        children: List.generate(
                          3,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: currentPage == index ? 13 : 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? AppColors.secondary
                                  : AppColors.border,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      // Next / Get Started
                      if (currentPage == 2)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: ElevatedButton(
                              onPressed: goToLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 55),
                                shape: const StadiumBorder(),
                              ),
                              child: const Text(
                                'Get Started',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          width: 55,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: const CircleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.arrow_forward),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
