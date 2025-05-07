import 'story.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story_detail_response.g.dart';

@JsonSerializable()
class StoryDetailResponse {
  final bool error;
  final String message;
  final Story story;

  StoryDetailResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory StoryDetailResponse.fromJson(json) => _$StoryDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryDetailResponseToJson(this);
}
