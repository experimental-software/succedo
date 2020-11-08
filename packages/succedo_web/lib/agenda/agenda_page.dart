import 'package:flutter/material.dart';

import '../navigation_rail.dart';

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
