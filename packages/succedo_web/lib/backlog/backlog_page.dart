import 'package:flutter/material.dart';
import 'package:succedo_web/navigation_rail.dart';
import 'package:succedo_web/routing.dart';

class BacklogPage extends StatelessWidget {
  const BacklogPage();

  @override
  Widget build(BuildContext context) {
    return SuccedoNavigationRail(
      activeDestination: RouteGenerator.backlogPage,
      body: Text("<Backlog>"),
    );
  }
}
