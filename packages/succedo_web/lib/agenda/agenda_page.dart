import 'package:flutter/material.dart';
import 'package:succedo_web/navigation_rail.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage();

  @override
  Widget build(BuildContext context) {
    return SuccedoNavigationRail(
      activeDestination: Destinations.agenda,
      body: Text("<Agenda>"),
    );
  }
}
