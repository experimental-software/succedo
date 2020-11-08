import 'package:flutter/material.dart';
import 'package:succedo_web/navigation_rail.dart';

class BacklogPage extends StatelessWidget {
  const BacklogPage();

  @override
  Widget build(BuildContext context) {
    return SuccedoNavigationRail(
      activeDestination: Destinations.backlog,
      body: Text("<Backlog>"),
    );
  }
}
