import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mood_tracker/models/moods_model.dart';
import 'package:mood_tracker/providers/mood_provider.dart';
import 'package:mood_tracker/utils/colors.dart';

class HistoryMood extends ConsumerStatefulWidget {
  const HistoryMood({super.key});

  @override
  ConsumerState<HistoryMood> createState() => _HistoryMoodState();
}

class _HistoryMoodState extends ConsumerState<HistoryMood> {
  String todayMood(String value) {
    switch (value) {
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
    final moodState = ref.watch(moodProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.bgBlack.withOpacity(0.1),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.bgBlack,
                      ),
                    ),
                  ),
                  const Text(
                    "Mood History",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.bgBlack,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 20.0),
                  itemCount: moodState.moods.length,
                  itemBuilder: (context, index) {
                    MoodModel moods = moodState.moods[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.bgOrange,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            moods.moodValue == "0"
                                ? LucideIcons.frown
                                : moods.moodValue == "1"
                                    ? LucideIcons.smile
                                    : LucideIcons.laugh,
                            color: Colors.white,
                          ),
                          title: Text(
                            moods.note,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            moods.date,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
