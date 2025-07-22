import 'package:flutter/material.dart';

class OnboardingTwo extends StatelessWidget {
  const OnboardingTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/onboarding_two.png',
          width: 340,
          height: 250,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          'Effortless Borrowing',
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
