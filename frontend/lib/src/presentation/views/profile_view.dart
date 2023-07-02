import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:myspots/src/services/backend.dart';
import 'package:myspots/src/presentation/widgets/avatars/ReelAvator.dart';
import 'package:myspots/src/presentation/widgets/buttons/HashTagButton.dart';
import 'package:myspots/src/presentation/widgets/buttons/RoundedIconTextButton.dart';
import 'package:myspots/src/presentation/widgets/layouts/HomeLayout.dart';
import 'package:myspots/src/presentation/widgets/loaders/CircularLoader.dart';
import 'package:myspots/src/presentation/widgets/reels/ReelGridView.dart';
import 'package:myspots/src/presentation/widgets/typography/BodyText.dart';
import 'package:myspots/src/presentation/widgets/typography/MainHeading.dart';
import 'package:provider/provider.dart';
import 'package:myspots/src/services/models.dart' as model;

enum PostsAboutType { posts, about }

@RoutePage()
class ProfileView extends StatefulWidget {
  const ProfileView({Key? key});

  @override
  State<ProfileView> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileView> {
  PostsAboutType postsAboutTypeView = PostsAboutType.posts;

  @override
  Widget build(BuildContext context) {
    final currentlySelectedUserId =
        context.read<model.AppState>().currentlySelectedUserId;

    return FutureBuilder(
      future: BackendService().getAnyUser(currentlySelectedUserId),
      builder: (context, snapshot) {
        // If an error occurred while fetching data
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // When the future completes successfully
        if (snapshot.connectionState == ConnectionState.done) {
          final user = snapshot.data!;

          return (SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body:
                  Consumer<model.AppState>(builder: (context, appState, child) {
                if (appState.isLoading) {
                  return const CircularProgressIndicator();
                }
                return Column(
                  children: [
                    Flexible(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          children: [
                            buildProfileRow(user),
                            SizedBox(height: 10),
                            buildSegmentedButton(),
                            SizedBox(height: 10),
                            buildPostsOrAboutSection(
                                currentlySelectedUserId, user),
                          ],
                        ),
                      ),
                    ),
                    appState.erroMessage.isNotEmpty
                        ? BodyText(
                            text: appState.erroMessage,
                            textColor: Colors.red,
                          )
                        : const SizedBox.shrink(),
                  ],
                );
              }),
            ),
          ));
        }

        // While waiting for the future to complete
        return const CircularLoader();
      },
    );
  }

  Widget buildProfileRow(model.User user) {
    return Row(
      children: [
        ReelAvatar(imageUrl: user.avatarUrl),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainHeading(text: user.fullName),
              const SizedBox(height: 8),
              BodyText(text: user.profileText),
              const SizedBox(height: 16),
              RoundedIconButton(
                icon: Icons.person_add,
                text: 'Follow',
                onPressed: () {
                  BackendService().followUser(user.id);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSegmentedButton() {
    return SegmentedButton<PostsAboutType>(
      segments: const <ButtonSegment<PostsAboutType>>[
        ButtonSegment<PostsAboutType>(
          value: PostsAboutType.posts,
          label: Text('Posts'),
        ),
        ButtonSegment<PostsAboutType>(
          value: PostsAboutType.about,
          label: Text('About'),
        ),
      ],
      selected: <PostsAboutType>{postsAboutTypeView},
      onSelectionChanged: (Set<PostsAboutType> newSelection) {
        setState(() {
          postsAboutTypeView = newSelection.first;
        });
      },
    );
  }

  Widget buildPostsOrAboutSection(
      String currentlySelectedUserId, model.User user) {
    if (postsAboutTypeView == PostsAboutType.posts) {
      return FutureBuilder(
        future: BackendService().getUserReels(currentlySelectedUserId),
        builder: (context, snapshot) {
          // If an error occurred while fetching data
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // When the future completes successfully
          if (snapshot.connectionState == ConnectionState.done) {
            final reels = snapshot.data!;
            return Expanded(
              child: ReelGridView(
                reels: reels,
              ),
            );
          }

          // While waiting for the future to complete
          return const CircularLoader();
        },
      );
    } else {
      return Expanded(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFollowersFollowingRow(user),
              // SizedBox(height: 16),
              // MainHeading(text: 'Following tags:'),
              // SizedBox(height: 8),
              // buildTrendsWrap(),
            ],
          ),
        ),
      );
    }
  }

  Widget buildFollowersFollowingRow(model.User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildFollowersColumn(user),
        buildFollowingColumn(user),
      ],
    );
  }

  Widget buildFollowersColumn(model.User user) {
    return Column(
      children: [
        MainHeading(text: user.followers.toString()),
        BodyText(text: 'Followers'),
      ],
    );
  }

  Widget buildFollowingColumn(model.User user) {
    return Column(
      children: [
        MainHeading(text: user.following.toString()),
        BodyText(text: 'Following'),
      ],
    );
  }

  Widget buildTrendsWrap() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        TranslucentGreyButton(text: 'italy', onPressed: () => {}),
        TranslucentGreyButton(text: 'food', onPressed: () => {}),
        TranslucentGreyButton(text: 'cafe', onPressed: () => {}),
        TranslucentGreyButton(text: 'coffee', onPressed: () => {}),
        TranslucentGreyButton(text: 'boating', onPressed: () => {}),
        TranslucentGreyButton(text: 'art', onPressed: () => {}),
        TranslucentGreyButton(
          text: 'photography',
          onPressed: () => {},
        ),
      ],
    );
  }
}
