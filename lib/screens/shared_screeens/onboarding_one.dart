import 'package:flutter/material.dart';

class OnboardingOne extends StatelessWidget {
  const OnboardingOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/onboarding_one.png',
          width: 300,
          height: 250,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          'Discover Resources',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.8),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Request assets with just a few taps. Track your borrowing status and return dates—all in one place for easy management.',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.black.withOpacity(0.6),
                ),
          ),
        ),
      ],
    );
  }
}
