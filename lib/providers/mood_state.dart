import 'package:equatable/equatable.dart';
import 'package:mood_tracker/models/moods_model.dart';

class MoodState extends Equatable {
  final List<MoodModel> moods;

  const MoodState({
    required this.moods,
  });
  const MoodState.initial({
    this.moods = const [],
  });

  MoodState copyWith({
    List<MoodModel>? mood,
  }) {
    return MoodState(
      moods: mood ?? moods,
    );
  }

  @override
  List<Object> get props => [moods];
}
