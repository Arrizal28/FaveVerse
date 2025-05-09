import 'package:flutter/material.dart';

import '../data/api/api_services.dart';
import '../static/story_detail_result_state.dart';

class StoryDetailProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  StoryDetailProvider(this._apiServices);

  StoryDetailResultState _resultState = StoryDetailNoneState();

  StoryDetailResultState get resultState => _resultState;

  Future<void> fetchStoryDetail(String id) async {
    try {
      _resultState = StoryDetailLoadingState();
      notifyListeners();

      final result = await _apiServices.getStoryDetail(id);

      if (result.error) {
        _resultState = StoryDetailErrorState(result.message);
      } else {
        _resultState = StoryDetailLoadedState(result);
      }
    } on Exception catch (e) {
      _resultState = StoryDetailErrorState(e.toString());
    }
    notifyListeners();
  }
}
