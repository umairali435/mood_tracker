import 'package:mood_tracker/models/moods_model.dart';
import 'package:mood_tracker/mood_database/mood_datasource.dart';
import 'package:mood_tracker/repos/mood_repos.dart';

class MoodRepoImplementation implements MoodsRepository {
  final MoodDataSource _datasource;
  MoodRepoImplementation(this._datasource);

  @override
  Future<void> addTask(MoodModel mood) async {
    try {
      await _datasource.addTask(mood);
    } catch (e) {
      throw '$e';
    }
  }

  @override
  Future<void> deleteTask(MoodModel mood) async {
    try {
      await _datasource.deleteTask(mood);
    } catch (e) {
      throw '$e';
    }
  }

  @override
  Future<List<MoodModel>> getAllTasks() async {
    try {
      return await _datasource.getAllTasks();
    } catch (e) {
      throw '$e';
    }
  }

  @override
  Future<void> updateTask(MoodModel task) async {
    try {
      await _datasource.updateTask(task);
    } catch (e) {
      throw '$e';
    }
  }
}
