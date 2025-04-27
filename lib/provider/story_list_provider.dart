import 'package:flutter/material.dart';

import '../data/api/api_services.dart';
import '../data/model/Story.dart';
import '../static/story_list_result_state.dart';

class StoryListProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  StoryListProvider(this._apiServices);

  StoryListResultState _resultState = StoryListNoneState();

  StoryListResultState get resultState => _resultState;

  int? pageItems = 1;
  int sizeItems = 10;

  List<Story> story = [];

  Future<void> fetchStoryList() async {
    try {

      if (pageItems == 1) {
        _resultState = StoryListLoadingState();
        notifyListeners();
      }

      final result = await _apiServices.getStoryList(pageItems!, sizeItems);

      if (result.error) {
        _resultState = StoryListErrorState(result.message);
        notifyListeners();
      } else {
        story.addAll(result.listStory);
        _resultState = StoryListLoadedState(story);
        pageItems = pageItems! + 1;

        if (result.listStory.length < sizeItems) {
          pageItems = null;
        } else {
          pageItems = pageItems! + 1;
        }

        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = StoryListErrorState(e.toString());
      notifyListeners();
    }
  }
}