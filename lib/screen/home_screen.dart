import 'package:faveverse/provider/story_list_provider.dart';
import 'package:faveverse/widget/story_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../static/story_list_result_state.dart';
import '../style/colors/fv_colors.dart';
import '../widget/header_with_story_button.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onTapped;
  final VoidCallback onAddStory;
  const HomeScreen({super.key, required this.onTapped, required this.onAddStory});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StoryListProvider>().fetchStoryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FvColors.blue.color,
        centerTitle: true,
        title: Text(
          'FaveVerse',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white
          ),
        ),
      ),
      body: ListView(
        children: [
          HeaderWithNewStoryButton(onPressed: widget.onAddStory),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text("Fresh Stories from the Community", style: Theme.of(context).textTheme.headlineLarge,),
          ),
          const SizedBox(height: 12),
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

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: StoryCard(
                          story: story,
                          onTapped: () => widget.onTapped(story.id),
                        )
                      );
                    },
                  ),
                StoryListErrorState() => Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 52),
                      Image.asset(
                        "assets/images/error.jpg",
                        width: 198,
                        height: 198,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Oops! Something went wrong.",
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
