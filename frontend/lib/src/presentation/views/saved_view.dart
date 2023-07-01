import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:myspots/src/services/backend.dart';
import 'package:myspots/src/presentation/widgets/layouts/HomeLayout.dart';
import 'package:myspots/src/presentation/widgets/reels/ReelGridView.dart';
import 'package:myspots/src/presentation/widgets/typography/MainHeading.dart';

class SavedView extends StatelessWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          MainHeading(text: "Saved"),
          FutureBuilder(
            future: BackendService().getUserFavouriteReels(),
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
        ],
      ),
    );
  }
}
