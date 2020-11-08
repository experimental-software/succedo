import 'package:flutter/material.dart';
import 'package:succedo_web/navigation_rail.dart';

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
