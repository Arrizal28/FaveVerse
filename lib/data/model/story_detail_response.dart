import 'story.dart';

class StoryDetailResponse {
  final bool error;
  final String message;
  final Story story;

  StoryDetailResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory StoryDetailResponse.fromJson(Map<String, dynamic> json) {
    return StoryDetailResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      story: Story.fromJson(json['story'] as Map<String, dynamic>),
    );
  }
}
