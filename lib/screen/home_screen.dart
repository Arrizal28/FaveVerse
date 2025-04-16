import 'package:faveverse/provider/story_list_provider.dart';
import 'package:faveverse/widget/story_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common.dart';
import '../provider/auth_provider.dart';
import '../static/story_list_result_state.dart';
import '../style/colors/fv_colors.dart';
import '../widget/flag_icon_widget.dart';
import '../widget/header_with_story_button.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onTapped;
  final VoidCallback onAddStory;
  final VoidCallback onLogOut;
  const HomeScreen({super.key, required this.onTapped, required this.onAddStory, required this.onLogOut});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  void refreshStories() {
    context.read<StoryListProvider>().fetchStoryList();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StoryListProvider>().fetchStoryList();
    });
  }

  Future<void> _handleLogout(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final authProvider = context.read<AuthProvider>();

    try {
      final result = await authProvider.logout();
      if (result) {
        widget.onLogOut();
      } else {
        scaffoldMessenger.showSnackBar(
           SnackBar(content: Text(AppLocalizations.of(context)!.logoutFailedPrefix)),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.loginFailedPrefix)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FvColors.blue.color,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.appTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white
          ),
        ),
        actions: [
          const FlagIconWidget(),
        ],
      ),
      floatingActionButton: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return FloatingActionButton(
            onPressed: authProvider.isLoadingLogout
                ? null
                : () => _handleLogout(context),
            backgroundColor: FvColors.blue.color,
            tooltip: AppLocalizations.of(context)!.logoutTitle,
            child: authProvider.isLoadingLogout
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.logout, color: Colors.white),
          );
        },
      ),
      body: ListView(
        children: [
          HeaderWithNewStoryButton(onPressed: widget.onAddStory),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(AppLocalizations.of(context)!.homeScreenTitle, style: Theme.of(context).textTheme.headlineLarge,),
          ),
          Consumer<StoryListProvider>(
            builder: (context, value, child) {
              return switch (value.resultState) {
                StoryListLoadingState() => const Center(
                  child: CircularProgressIndicator(),
                ),
                StoryListLoadedState(data: var storyList) =>
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: storyList.length,
                    itemBuilder: (context, index) {
                      final story = storyList[index];

                      return StoryCard(
                        story: story,
                        onTapped: () => widget.onTapped(story.id),
                      );
                    },
                  ),
                StoryListErrorState() => Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 52),
                      Image.asset(
                        "assets/images/error.png",
                        width: 198,
                        height: 198,
                      ),
                      const SizedBox(height: 6),
                       Text(
                        AppLocalizations.of(context)!.errorSign,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                _ => const SizedBox(),
              };
            },
          ),
        ],
      ),
    );
  }
}
