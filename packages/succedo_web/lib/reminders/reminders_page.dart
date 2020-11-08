import 'package:flutter/material.dart';
import 'package:succedo_web/navigation_rail.dart';
import 'package:succedo_web/routing.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage();

  @override
  Widget build(BuildContext context) {
    return SuccedoNavigationRail(
      activeDestination: RouteGenerator.agendaPage,
      body: Text("<Reminders>"),
    );
  }
}
