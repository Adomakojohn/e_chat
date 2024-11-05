import 'package:chat_app/core/utils/widgets/buttons.dart';
import 'package:chat_app/feature/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MainOnboardingScreen extends StatefulWidget {
  const MainOnboardingScreen({super.key});

  @override
  State<MainOnboardingScreen> createState() => _MainOnboardingScreenState();
}

class _MainOnboardingScreenState extends State<MainOnboardingScreen> {
  final pageController = PageController();
  int currentPage = 0;

  final List<OnboardingPage> onboard = [
    const OnboardingPage(
      onboardImage: 'assets/images/onboarding1.png',
      onboardMainText: 'Group Chats',
      onboardSecondText: 'Connect with multiple members in',
      onboardThirdText: 'group chats',
    ),
    const OnboardingPage(
      onboardImage: 'assets/images/onboarding2.png',
      onboardMainText: 'Video and Voice Calls',
      onboardSecondText: 'Instantly connect via video and voice calls.',
      onboardThirdText: '',
    ),
    const OnboardingPage(
      onboardImage: 'assets/images/onboarding3.png',
      onboardMainText: 'Message Encryption',
      onboardSecondText: 'Ensure privacy with encrypted messages',
      onboardThirdText: '',
    ),
    const OnboardingPage(
      onboardImage: 'assets/images/onboarding4.png',
      onboardMainText: 'Cross-Platform Compatibility',
      onboardSecondText: 'Access chats on all platforms seamlessly',
      onboardThirdText: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Fetch screen height and width
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: onboard.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPage(
                onboardImage: onboard[index].onboardImage,
                onboardMainText: onboard[index].onboardMainText,
                onboardSecondText: onboard[index].onboardSecondText,
                onboardThirdText: onboard[index].onboardThirdText,
              );
            },
          ),
          Positioned(
            bottom: screenHeight * 0.1, // Adjusted for screen height
            left: screenWidth * 0.4, // Adjusted for screen width
            child: SmoothPageIndicator(
              controller: pageController,
              count: onboard.length,
              effect: const SlideEffect(
                radius: 14,
                dotWidth: 12,
                dotHeight: 12,
                dotColor: Color(0xFFa7e4ff),
                activeDotColor: Color(0xFF40c4ff),
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            bottom: screenHeight * 0.2,
            child: currentPage == onboard.length - 1
                ? MyButton(
                    buttonText: 'Get Started',
                    onTap: () {
                      Navigator.pushNamed(context, 'myauthpage');
                    },
                  )
                : MyButton(
                    buttonText: 'Get Started',
                    onTap: () {
                      pageController.nextPage(
                        duration: const Duration(
                          milliseconds: 300,
                        ),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
          ),
          Positioned(
            left: screenWidth * 0.1,
            bottom: screenHeight * 0.1,
            child: GestureDetector(
              onTap: () {
                pageController.jumpToPage(3);
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF3ab2e8),
                ),
              ),
            ),
          ),
          Positioned(
            right: screenWidth * 0.1,
            bottom: screenHeight * 0.1,
            child: currentPage == onboard.length - 1
                ? GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'myauthpage');
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
