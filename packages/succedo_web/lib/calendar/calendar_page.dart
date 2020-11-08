import 'package:flutter/material.dart';
import 'package:succedo_web/navigation_rail.dart';
import 'package:succedo_web/routing.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage();

  @override
  Widget build(BuildContext context) {
    return SuccedoNavigationRail(
      activeDestination: RouteGenerator.agendaPage,
      body: Text("<Calendar>"),
    );
  }
}
