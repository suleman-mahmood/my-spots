import 'package:flutter/material.dart';
import 'package:myspots/shared/typography/BodyText.dart';
import 'package:provider/provider.dart';
import 'package:myspots/services/models.dart' as model;

class HomeLayout extends StatefulWidget {
  final List<Widget> children;
  final Color backgroundColor;

  const HomeLayout({
    Key? key,
    required this.children,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/search-reels');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/create-reel');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/saved-reels');
    } else if (index == 4) {
      final userId = context.read<model.User>().id;
      context.read<model.AppState>().setCurrentlySelectedUser(userId);
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        body: Consumer<model.AppState>(builder: (context, appState, child) {
          if (appState.isLoading) {
            return const CircularProgressIndicator();
          }
          return Column(
            children: [
              ...widget.children,
              appState.erroMessage.isNotEmpty
                  ? BodyText(
                      text: appState.erroMessage,
                      textColor: Colors.red,
                    )
                  : const SizedBox.shrink(),
            ],
          );
        }),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.save),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
