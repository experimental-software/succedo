import 'package:flutter/material.dart';
import 'package:succedo_web/navigation_rail.dart';

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
