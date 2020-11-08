import 'package:flutter/material.dart';

import '../navigation_rail.dart';

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
