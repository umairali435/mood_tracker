import 'package:equatable/equatable.dart';
import 'package:mood_tracker/utils/mood_keys.dart';

class MoodModel extends Equatable {
  final int? id;
  final String note;
  final String date;
  final String moodValue;
  const MoodModel({
    this.id,
    required this.date,
    required this.note,
    required this.moodValue,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      MoodKeys.id: id,
      MoodKeys.note: note,
      MoodKeys.moodValue: moodValue,
      MoodKeys.date: date,
    };
  }

  factory MoodModel.fromJson(Map<String, dynamic> map) {
    return MoodModel(
      id: map[MoodKeys.id],
      moodValue: map[MoodKeys.moodValue],
      note: map[MoodKeys.note],
      date: map[MoodKeys.date],
    );
  }

  @override
  List<Object> get props {
    return [
      note,
      date,
      moodValue,
    ];
  }

  MoodModel copyWith({
    int? id,
    String? note,
    String? date,
    String? moodValue,
  }) {
    return MoodModel(
      id: id ?? this.id,
      note: note ?? this.note,
      moodValue: moodValue ?? this.moodValue,
      date: date ?? this.date,
    );
  }
}
