import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:myspots/src/services/backend.dart';
import 'package:myspots/src/presentation/widgets/avatars/ProfileAvator.dart';
import 'package:myspots/src/presentation/widgets/buttons/CategoryButton.dart';
import 'package:myspots/src/presentation/widgets/inputs/TextInput.dart';
import 'package:myspots/src/presentation/widgets/layouts/HomeLayout.dart';
import 'package:myspots/src/presentation/widgets/loaders/CircularLoader.dart';
import 'package:myspots/src/presentation/widgets/reels/ReelGridView.dart';
import 'package:myspots/src/presentation/widgets/typography/BodyText.dart';
import 'package:myspots/src/presentation/widgets/typography/MainHeading.dart';
import 'package:myspots/src/services/models.dart' as model;
import 'package:provider/provider.dart';

@RoutePage()
class SearchReelsView extends StatefulWidget {
  const SearchReelsView({super.key});

  @override
  State<SearchReelsView> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchReelsView> {
  bool isSearching = false;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final user = context.read<model.User>();

    return HomeLayout(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Expanded(
                child: MainHeading(text: 'What do you want to explore?')),
            ProfileAvatar(imageUrl: user.avatarUrl),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: TextInput(
            labelText: 'Search',
            prefixIcon: Icon(Icons.search),
            onChanged: (value) => {
              if (value.isNotEmpty)
                {
                  setState(() {
                    isSearching = true;
                    searchText = value;
                  })
                }
              else
                {
                  setState(() {
                    isSearching = false;
                    searchText = '';
                  })
                }
            },
          ),
        ),
        isSearching
            ? Expanded(child: BuildSearchResults(searchText: searchText))
            : Expanded(child: BuildExploreReels()),
      ],
    );
  }
}

class SpotCard extends StatelessWidget {
  const SpotCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(20.0), // Set rounded border radius
            image: DecorationImage(
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1635107510862-53886e926b74?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainHeading(text: 'Coffee bean & Tea Leaf'),
              Row(
                children: [
                  BodyText(text: 'Lahore, Pakistan'),
                  Expanded(child: Container()),
                  BodyText(text: '4.5'),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

// class ReelView extends StatelessWidget {
//   const ReelView({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 150.0,
//       height: 200.0,
//       margin: EdgeInsets.symmetric(horizontal: 8.0),
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: NetworkImage('https://picsum.photos/150/200'),
//           fit: BoxFit.cover,
//         ),
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//     );
//   }
// }

class BuildSearchResults extends StatelessWidget {
  String searchText;

  BuildSearchResults({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: BackendService().getSearchReels(searchText),
        builder: (context, snapshot) {
          // If an error occurred while fetching data
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // When the future completes successfully
          if (snapshot.connectionState == ConnectionState.done) {
            final reels = snapshot.data!;
            return ReelGridView(reels: reels);
          }

          // While waiting for the future to complete
          return const CircularLoader();
        });
  }
}

class BuildExploreReels extends StatelessWidget {
  const BuildExploreReels({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MainHeading(text: 'Tags'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FutureBuilder<List<model.Tag>>(
                future: BackendService().getAllTags(),
                builder: (context, snapshot) {
                  // If an error occurred while fetching data
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  // When the future completes successfully
                  if (snapshot.connectionState == ConnectionState.done) {
                    final tags = snapshot.data!;
                    return Row(
                      children: tags
                          .map((tag) => CategoryButton(
                                onPressed: () {},
                                icon: Icons.food_bank,
                                text: tag.tagName,
                              ))
                          .toList(),
                    );
                  }

                  // While waiting for the future to complete
                  return const CircularLoader();
                },
              ),
            ],
          ),
        ),
        MainHeading(text: 'Nearest to you'),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Row(
        //     children: [
        //       SingleChildScrollView(
        //         scrollDirection: Axis.horizontal,
        //         child: Row(
        //           children: [
        //             ReelView(),
        //             ReelView(),
        //             ReelView(),
        //             ReelView(),
        //             ReelView(),
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        FutureBuilder(
          future: BackendService().getExploreReels(),
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
            return const CircularProgressIndicator();
          },
        ),

        // MainHeading(text: 'Recommended'),
        // Expanded(
        //   child: SingleChildScrollView(
        //     child: Column(
        //       children: [
        //         SpotCard(),
        //         SpotCard(),
        //         SpotCard(),
        //         SpotCard(),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
