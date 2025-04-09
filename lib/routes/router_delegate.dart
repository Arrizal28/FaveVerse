import 'package:flutter/material.dart';

import '../screen/detail_screen.dart';
import '../screen/home_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  String? selectedStory;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage(
          key: const ValueKey("HomeScreen"),
          child: HomeScreen(
            onTapped: (String storyId) {
              selectedStory = storyId;
              notifyListeners();
            },
          ),
        ),
        if (selectedStory != null)
          MaterialPage(
            key: ValueKey("StoryDetailsPage-$selectedStory"),
            child: DetailScreen(storyId: selectedStory!),
          ),
      ],
      onDidRemovePage: (page) {
        if (page.key == ValueKey("StoryDetailsPage-$selectedStory")) {
          selectedStory = null;
          notifyListeners();
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }
}
