import 'package:faveverse/routes/page_manager.dart';
import 'package:faveverse/screen/maps_screen.dart';
import 'package:flutter/material.dart';

import '../data/repository/auth_repository.dart';
import '../screen/add_story_screen.dart';
import '../screen/detail_screen.dart';
import '../screen/home_screen.dart';
import '../screen/login_screen.dart';
import '../screen/register_screen.dart';
import '../screen/splash_screen.dart';
import '../routes/custom_page_route.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;
  String? selectedStory;
  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool isAddingStory = false;
  bool isSelectingLocation = false;
  final PageManager pageManager = PageManager();
  bool isLoginToRegister = true;

  MyRouterDelegate(this.authRepository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }

    return Navigator(
      pages: historyStack,
      key: navigatorKey,
      onDidRemovePage: (Page page) {
        final key = page.key;

        if (key is ValueKey && key.value == selectedStory) {
          selectedStory = null;
          notifyListeners();
        } else if (key == const ValueKey("RegisterPage")) {
          isRegister = false;
          notifyListeners();
        } else if (key == const ValueKey("AddStoryPage")) {
          isAddingStory = false;
          notifyListeners();
        } else if (key == const ValueKey("MapPage")) {
          isSelectingLocation = false;
          notifyListeners();
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }

  List<Page> get _splashStack => const [
    MaterialPage(key: ValueKey("SplashPage"), child: SplashScreen()),
  ];

  List<Page> get _loggedOutStack {
    final List<Page> pages = [
      CustomPageRoute(
        key: const ValueKey("LoginPage"),
        routeName: "login",
        isRightToLeft: !isLoginToRegister,
        child: LoginScreen(
          onLogin: () {
            isLoggedIn = true;
            notifyListeners();
          },
          onRegister: () {
            isLoginToRegister = true;
            Future.microtask(() {
              isRegister = true;
              notifyListeners();
            });
          },
        ),
      ),
    ];

    if (isRegister) {
      pages.add(
        CustomPageRoute(
          key: const ValueKey("RegisterPage"),
          routeName: "register",
          isRightToLeft: isLoginToRegister,
          child: RegisterScreen(
            onRegister: () {
              Future.microtask(() {
                isRegister = false;
                notifyListeners();
              });
            },
            onLogin: () {
              isLoginToRegister = false;
              Future.microtask(() {
                isRegister = false;
                notifyListeners();
              });
            },
          ),
        ),
      );
    }

    return pages;
  }

  List<Page> get _loggedInStack {
    final List<Page> pages = [
      MaterialPage(
        key: const ValueKey("StoryListPage"),
        child: HomeScreen(
          onTapped: (String storyId) {
            Future.microtask(() {
              selectedStory = storyId;
              notifyListeners();
            });
          },
          onAddStory: () {
            Future.microtask(() {
              isAddingStory = true;
              notifyListeners();
            });
          },
          onLogOut: () {
            Future.microtask(() {
              isLoggedIn = false;
              notifyListeners();
            });
          },
        ),
      ),
    ];

    if (selectedStory != null) {
      pages.add(
        CustomPageRoute(
          key: ValueKey(selectedStory),
          routeName: "detail",
          child: DetailScreen(storyId: selectedStory!),
        ),
      );
    }

    if (isAddingStory) {
      pages.add(
        CustomPageRoute(
          key: const ValueKey("AddStoryPage"),
          routeName: "add_story",
          child: AddStoryScreen(
            onStoryAdded: () {
              Future.microtask(() {
                isAddingStory = false;
                notifyListeners();
              });
            },
            onCancel: () {
              Future.microtask(() {
                isAddingStory = false;
                notifyListeners();
              });
            },
            onAddLocation: () {
              Future.microtask(() {
                isSelectingLocation = true;
                notifyListeners();
              });
            },
            pageManager: pageManager,
          ),
        ),
      );
    }

    if (isSelectingLocation) {
      pages.add(
        CustomPageRoute(
          key: const ValueKey("MapPage"),
          routeName: "map",
          child: MapsScreen(
            onCancel: () {
              Future.microtask(() {
                isSelectingLocation = false;
                notifyListeners();
              });
            },
            onSend: () {
              Future.microtask(() {
                isSelectingLocation = false;
                notifyListeners();
              });
            },
            pageManager: pageManager,
          ),
        ),
      );
    }
    return pages;
  }
}