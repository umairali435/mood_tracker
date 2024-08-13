import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mood_tracker/models/moods_model.dart';
import 'package:mood_tracker/providers/mood_provider.dart';
import 'package:mood_tracker/screens/drawer.dart';
import 'package:mood_tracker/screens/mood_history.dart';
import 'package:mood_tracker/screens/today_mood.dart';
import 'package:mood_tracker/utils/colors.dart';
import 'package:mood_tracker/utils/sizing.dart';
import 'package:mood_tracker/utils/time_helpers.dart';
import 'package:mood_tracker/widgets/arc.dart';
import 'package:mood_tracker/widgets/slider_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final TextEditingController controller = TextEditingController();
  double value = 1.0;
  final pageController = PageController(initialPage: 1);
  int activeIndex = 1;

  final duration = const Duration(milliseconds: 500);

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        value = 2.0;
        activeIndex = 2;
      });
      pageController.animateToPage(2, duration: duration, curve: Curves.elasticOut);
    });

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moodState = ref.watch(moodProvider);
    return moodState.moods.where((element) => element.date == Helpers.dateFormatter(DateTime.now())).isEmpty
        ? Scaffold(
            key: key,
            drawer: const CustomDrawer(),
            body: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: AppSizing.height(context),
              width: AppSizing.width(context),
              decoration: const BoxDecoration(color: Colors.white),
              child: SafeArea(
                child: ListView(
                  children: [
                    TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 1000),
                        tween: Tween<double>(begin: 1, end: 0),
                        curve: Curves.easeOutBack,
                        builder: (context, doubleVal, child) {
                          return Transform.translate(
                            offset: Offset(0, doubleVal * -AppSizing.height(context) / 2),
                            child: Column(
                              children: [
                                headerSection(moodState.moods),
                                eyesSection(),
                              ],
                            ),
                          );
                        }),
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween<double>(begin: 1, end: 0),
                      curve: Curves.easeOutBack,
                      builder: (context, doubleVal, child) {
                        return Transform.translate(
                          offset: Offset(0, doubleVal * AppSizing.height(context) / 2),
                          child: textAndSliderSection(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        : TodayMood(
            value: moodState.moods
                .where(
                  (element) =>
                      element.date ==
                      Helpers.dateFormatter(
                        DateTime.now(),
                      ),
                )
                .first
                .moodValue,
          );
  }

  Widget headerSection(List<MoodModel> data) {
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
          AppSizing.kh20(context),
          Text(
            "How is your Mood Today",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          AppSizing.khSpacer(AppSizing.height(context) * 0.02),
        ],
      ),
    );
  }

  Widget eyesSection() {
    print(value);
    return Container(
      padding: const EdgeInsets.all(50.0),
      decoration: BoxDecoration(
        color: generateColors(),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                eye(),
                AppSizing.kw20(context),
                eye(),
              ],
            ),
            AppSizing.kh20(context),
            TweenAnimationBuilder(
                key: ValueKey(activeIndex),
                tween: activeIndex == 2
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
                })
          ],
        ),
      ),
    );
  }

  Widget eye() {
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

  Widget textAndSliderSection() {
    List<String> items = ["SAD", "NORMAL", "HAPPY"];
    return Builder(
      builder: (context) {
        return Column(
          children: [
            SizedBox(
              height: 20.0,
              child: PageView.builder(
                allowImplicitScrolling: false,
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                itemCount: items.length,
                onPageChanged: (value) {
                  setState(() {
                    activeIndex = value;
                  });
                },
                itemBuilder: (context, i) {
                  return Center(
                    child: Text(
                      items[i],
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.bgBlack.withOpacity(0.3),
                          ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: AppSlider(
                onChanged: (dynamic val) {
                  setState(() {
                    value = val;
                  });

                  pageController.animateTo(
                    value * AppSizing.width(context),
                    duration: const Duration(milliseconds: 1800),
                    curve: Curves.elasticOut,
                  );
                },
              ),
            ),
            AppSizing.khSpacer(AppSizing.height(context) * 0.1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Add a note",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: generateColors()),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: generateColors()),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: generateColors()),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _addTodo(activeIndex);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10.0),
                child: Container(
                  height: 45.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: generateColors(),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: Text("Add mood for today"),
                  ),
                ),
              ),
            ),
            AppSizing.khSpacer(AppSizing.height(context) * 0.05),
          ],
        );
      },
    );
  }

  void _addTodo(int activeIndex) async {
    final note = controller.text;
    final value = activeIndex.toString();
    final task = MoodModel(
      note: note,
      moodValue: value,
      date: DateFormat.yMMMd().format(DateTime.now()),
    );

    await ref.read(moodProvider.notifier).createTask(task).then((value) {
      controller.clear();
    });
  }

  Color generateColors() {
    if (value <= 0.5) {
      return AppColors.bgRed;
    } else if (value >= 0.5 && value <= 1.2) {
      return AppColors.bgOrange;
    } else {
      return AppColors.bgGreen;
    }
  }
}
