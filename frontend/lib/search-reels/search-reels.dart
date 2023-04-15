import 'package:flutter/material.dart';
import 'package:myspots/shared/avatars/ProfileAvator.dart';
import 'package:myspots/shared/buttons/CategoryButton.dart';
import 'package:myspots/shared/layouts/HomeLayout.dart';
import 'package:myspots/shared/typography/BodyText.dart';
import 'package:myspots/shared/typography/MainHeading.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeLayout(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: MainHeading(text: 'What do you want to explore?')),
            ProfileAvatar(
                imageUrl:
                    'https://images.unsplash.com/photo-1635107510862-53886e926b74?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80'),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        MainHeading(text: 'Categories'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CategoryButton(
                onPressed: () {},
                icon: Icons.food_bank,
                text: "Food",
              ),
              CategoryButton(
                onPressed: () {},
                icon: Icons.food_bank,
                text: "Food",
              ),
              CategoryButton(
                onPressed: () {},
                icon: Icons.food_bank,
                text: "Food",
              ),
              CategoryButton(
                onPressed: () {},
                icon: Icons.food_bank,
                text: "Food",
              ),
              CategoryButton(
                onPressed: () {},
                icon: Icons.food_bank,
                text: "Food",
              ),
              CategoryButton(
                onPressed: () {},
                icon: Icons.food_bank,
                text: "Food",
              ),
            ],
          ),
        ),
        MainHeading(text: 'Nearest to you'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ReelView(),
                    ReelView(),
                    ReelView(),
                    ReelView(),
                    ReelView(),
                  ],
                ),
              )
            ],
          ),
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

class ReelView extends StatelessWidget {
  const ReelView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 200.0,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://picsum.photos/150/200'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
