import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:myspots/src/presentation/widgets/layouts/HomeLayout.dart';

@RoutePage()
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeLayout();
  }
}
