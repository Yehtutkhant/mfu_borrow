import 'package:flutter/material.dart';

class OnboardingThree extends StatelessWidget {
  const OnboardingThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/onboarding_three.png',
          width: 300,
          height: 250,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          'Support Your Community',
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
            'Make the most of shared assets. By borrowing instead of buying, you’re helping create a more sustainable campus environment.',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.black.withOpacity(0.6),
                ),
          ),
        ),
      ],
    );
  }
}
