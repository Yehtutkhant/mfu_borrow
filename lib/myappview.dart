import 'package:flutter/material.dart';
import 'package:mfuborrow/screens/shared_screeens/onboarding_one.dart';
import 'package:mfuborrow/screens/shared_screeens/onboarding_three.dart';
import 'package:mfuborrow/screens/shared_screeens/onboarding_two.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyAppView extends StatefulWidget {
  const MyAppView({super.key});

  @override
  State<MyAppView> createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  final PageController _pageController = PageController();
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              currentPageIndex = index;
              setState(() {});
            },
            children: const [
              OnboardingOne(),
              OnboardingTwo(),
              OnboardingThree(),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
            ),
            alignment: const Alignment(0, 0.6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentPageIndex == 2
                    ? const Text("")
                    : GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => false);
                        },
                        child: Text(
                          "Skip",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                    activeDotColor: Theme.of(context).colorScheme.primary,
                    spacing: 30.0,
                  ),
                ),
                currentPageIndex == 2
                    ? const Text("")
                    : GestureDetector(
                        onTap: () {
                          _pageController.nextPage(
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          "Next ->",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
              ],
            ),
          ),
          currentPageIndex == 2
              ? Container(
                  alignment: const Alignment(0, 0.7),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false);
                      },
                      child: Text(
                        'Start Your Adventure !',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary),
                      )),
                )
              : const Text(""),
        ],
      ),
    );
  }
}
