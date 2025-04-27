import 'package:faveverse/provider/add_story_provider.dart';
import 'package:faveverse/provider/auth_provider.dart';
import 'package:faveverse/provider/localizations_provider.dart';
import 'package:faveverse/provider/story_detail_provider.dart';
import 'package:faveverse/provider/story_list_provider.dart';
import 'package:faveverse/provider/upload_provider.dart';
import 'package:faveverse/routes/page_manager.dart';
import 'package:faveverse/routes/router_delegate.dart';
import 'package:faveverse/style/theme/fv_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common.dart';
import 'data/api/api_services.dart';
import 'data/repository/auth_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => ApiServices()),
        ProxyProvider<ApiServices, AuthRepository>(
          update:
              (context, apiServices, previous) =>
                  AuthRepository(apiServices: apiServices),
        ),
        ProxyProvider<ApiServices, AuthRepository>(
          update:
              (context, apiServices, previous) =>
                  AuthRepository(apiServices: apiServices),
        ),
        ChangeNotifierProxyProvider<AuthRepository, AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
          update:
              (context, authRepository, previous) =>
                  previous ?? AuthProvider(authRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => StoryListProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) => StoryDetailProvider(context.read<ApiServices>()),
        ),

        ChangeNotifierProvider(create: (context) => AddStoryProvider()),
        ChangeNotifierProvider(
          create: (context) => UploadProvider(ApiServices()),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalizationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PageManager(),
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
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = AuthProvider(context.read<AuthRepository>());
    myRouterDelegate = MyRouterDelegate(context.read<AuthRepository>());
  }

  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<LocalizationProvider>(context);

    return ChangeNotifierProvider(
      create: (context) => authProvider,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: FvTheme.lightTheme,
        darkTheme: FvTheme.darkTheme,
        themeMode: ThemeMode.system,
        locale: localizationProvider.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Router(
          routerDelegate: myRouterDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
