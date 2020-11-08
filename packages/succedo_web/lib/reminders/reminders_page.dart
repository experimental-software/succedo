import 'package:flutter/material.dart';

import '../navigation_rail.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage();

  @override
  Widget build(BuildContext context) {
    return SuccedoNavigationRail(
      activeDestination: Destinations.reminders,
      body: Text("<Reminders>"),
    );
  }
}
