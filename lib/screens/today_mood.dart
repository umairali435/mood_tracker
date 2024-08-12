import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mood_tracker/screens/drawer.dart';
import 'package:mood_tracker/screens/mood_history.dart';
import 'package:mood_tracker/utils/colors.dart';
import 'package:mood_tracker/utils/sizing.dart';
import 'package:mood_tracker/widgets/arc.dart';

class TodayMood extends StatefulWidget {
  final String value;
  const TodayMood({super.key, required this.value});

  @override
  State<TodayMood> createState() => _TodayMoodState();
}

class _TodayMoodState extends State<TodayMood> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  String todayMood() {
    switch (widget.value) {
      case "0":
        return "Sad";
      case "1":
        return "Normal";
      case "2":
        return "Happy";
      default:
        return "Angry";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            headerSection(),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppSizing.kh20(context),
                Text(
                  "Your mood is ${todayMood()} today",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                AppSizing.khSpacer(AppSizing.height(context) * 0.02),
                eyesSection(double.parse(widget.value)),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget headerSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  key.currentState!.openDrawer();
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.bgBlack.withOpacity(0.1),
                  child: const Icon(
                    Icons.menu,
                    color: AppColors.bgBlack,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HistoryMood(),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.bgBlack.withOpacity(0.1),
                  child: const Icon(
                    Icons.history,
                    color: AppColors.bgBlack,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget eyesSection(value) {
    return Container(
      padding: const EdgeInsets.all(50.0),
      decoration: BoxDecoration(
        color: generateColors(value),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                eye(1.0),
                AppSizing.kw20(context),
                eye(1.0),
              ],
            ),
            AppSizing.kh20(context),
            TweenAnimationBuilder(
              key: ValueKey(widget.value),
              tween: int.parse(widget.value) == 2
                  ? Tween<double>(
                      begin: 1.0,
                      end: 0.0,
                    )
                  : Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ),
              duration: const Duration(milliseconds: 500),
              builder: (context, animateValue, child) {
                return Transform.rotate(
                  angle: pi * animateValue,
                  // angle: value < 0.5 ? pi : pi * -value,
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CustomPaint(
                      painter: ArcPainter(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget eye(value) {
    return Builder(builder: (context) {
      double width = 70;
      double height = 35;
      double radius = 35;
      if (value <= 0.5) {
        width = 70;
        height = 70;
      }
      if (value > 0.5 && value < 1.2) {
        width = 70;
        height = 30;
      }
      if (value >= 1.2) {
        height = 90;
        width = 90;
        radius = 60;
      }
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.bgBlack,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    });
  }

  Color generateColors(value) {
    if (value <= 0.5) {
      return AppColors.bgRed;
    } else if (value >= 0.5 && value <= 1.2) {
      return AppColors.bgOrange;
    } else {
      return AppColors.bgGreen;
    }
  }
}
