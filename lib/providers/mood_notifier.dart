import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/models/moods_model.dart';
import 'package:mood_tracker/providers/mood_state.dart';
import 'package:mood_tracker/repos/mood_repos.dart';

class MoodNotifier extends StateNotifier<MoodState> {
  final MoodsRepository _repository;

  MoodNotifier(this._repository) : super(const MoodState.initial()) {
    getTasks();
  }

  Future<void> createTask(MoodModel mood) async {
    try {
      await _repository.addTask(mood);
      getTasks();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteTask(MoodModel mood) async {
    try {
      await _repository.deleteTask(mood);
      getTasks();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getTasks() async {
    try {
      final tasks = await _repository.getAllTasks();
      state = state.copyWith(mood: tasks);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
