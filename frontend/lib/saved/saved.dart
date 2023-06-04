import 'package:flutter/material.dart';
import 'package:myspots/services/backend.dart';
import 'package:myspots/shared/layouts/HomeLayout.dart';
import 'package:myspots/shared/reels/ReelGridView.dart';
import 'package:myspots/shared/typography/MainHeading.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeLayout(
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
    );
  }
}
