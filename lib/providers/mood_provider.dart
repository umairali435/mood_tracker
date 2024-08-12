import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/mood_database/mood_datasource.dart';
import 'package:mood_tracker/providers/mood_notifier.dart';
import 'package:mood_tracker/providers/mood_state.dart';
import 'package:mood_tracker/repos/mood_repo_imp.dart';
import 'package:mood_tracker/repos/mood_repos.dart';

final moodProvider = StateNotifierProvider<MoodNotifier, MoodState>((ref) {
  final repository = ref.watch(moodRepositoryProvider);
  return MoodNotifier(repository);
});

final moodRepositoryProvider = Provider<MoodsRepository>((ref) {
  final datasource = ref.read(moodSourceProvider);
  return MoodRepoImplementation(datasource);
});

final moodSourceProvider = Provider<MoodDataSource>((ref) {
  return MoodDataSource();
});
