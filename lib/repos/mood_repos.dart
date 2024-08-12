import 'package:mood_tracker/models/moods_model.dart';

abstract class MoodsRepository {
  Future<void> addTask(MoodModel mood);
  Future<void> updateTask(MoodModel mood);
  Future<void> deleteTask(MoodModel mood);
  Future<List<MoodModel>> getAllTasks();
}
