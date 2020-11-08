import 'package:flutter/material.dart';

import '../navigation_rail.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage();

  @override
  Widget build(BuildContext context) {
    return SuccedoNavigationRail(
      activeDestination: Destinations.calendar,
      body: Text("<Calendar>"),
    );
  }
}
