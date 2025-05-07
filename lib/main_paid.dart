import 'package:faveverse/provider/add_story_provider.dart';
import 'package:faveverse/provider/auth_provider.dart';
import 'package:faveverse/provider/localizations_provider.dart';
import 'package:faveverse/provider/story_detail_provider.dart';
import 'package:faveverse/provider/story_list_provider.dart';
import 'package:faveverse/provider/upload_provider.dart';
import 'package:faveverse/routes/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/api/api_services.dart';
import 'data/repository/auth_repository.dart';
import 'flavor_config.dart';
import 'main.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.paid,
    name: "Premium Version",
  );
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