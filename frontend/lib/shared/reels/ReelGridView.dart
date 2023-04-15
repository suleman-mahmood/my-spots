import 'package:flutter/material.dart';

class ReelGridView extends StatelessWidget {
  final List<String> reelUrls;

  ReelGridView({required this.reelUrls});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      itemCount: reelUrls.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 9 / 16, // Width to height ratio of the reel view
      ),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: NetworkImage(
                reelUrls[index],
              ),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
