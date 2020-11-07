import 'package:flutter/material.dart';

import 'navigation_rail.dart';

class AgendaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SuccedoNavigationRail(
      activeDestination: Destinations.agenda,
      body: Text("<Agenda page placeholder>"),
    );
  }
}
