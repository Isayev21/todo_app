import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:todo_list_app/screens/home_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroSlider(
        listCustomTabs: [
          getPageData(
            picture: SvgPicture.asset('assets/images/intro_image1.svg'),
            title: 'Manage your tasks',
            description:
                'You can easily manage all of your daily tasks in DoMe for free',
          ),
          getPageData(
            picture: SvgPicture.asset('assets/images/intro_image2.svg'),
            title: 'Create daily routine',
            description:
                'In Uptodo  you can create your personalized routine to stay productive',
          ),
          getPageData(
            picture: SvgPicture.asset('assets/images/intro_image3.svg'),
            title: 'Organize your tasks',
            description:
                'You can organize your daily tasks by adding your tasks into separate categories',
          ),
        ],
        onDonePress: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const HomeScreen(),
              transitionDuration: const Duration(seconds: 1),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c),
            ),
          );
        },
      ),
    );
  }

  Widget getPageData({
    required SvgPicture picture,
    required String title,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: picture,
        ),
        const SizedBox(
          height: 50,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 42,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
