import 'package:faveverse/provider/story_detail_provider.dart';
import 'package:faveverse/provider/story_list_provider.dart';
import 'package:faveverse/routes/router_delegate.dart';
import 'package:faveverse/style/theme/fv_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/api/api_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => ApiServices()),
        ChangeNotifierProvider(
          create: (context) => StoryListProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) => StoryDetailProvider(context.read<ApiServices>()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouterDelegate myRouterDelegate;

  @override
  void initState() {
    super.initState();
    myRouterDelegate = MyRouterDelegate();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: FvTheme.lightTheme,
      darkTheme: FvTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: Router(
        routerDelegate: myRouterDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
