import 'Story.dart';

class StoryListResponse {
  final bool error;
  final String message;
  final List<Story> listStory;

  StoryListResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoryListResponse.fromJson(Map<String, dynamic> json) {
    return StoryListResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      listStory: (json['listStory'] as List<dynamic>)
          .map((storyJson) => Story.fromJson(storyJson as Map<String, dynamic>))
          .toList(),
    );
  }
}
