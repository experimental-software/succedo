import 'package:flutter/material.dart';
import 'package:succedo_web/test_bench.dart';

enum Destinations { agenda, backlog, calendar, reminders }

class SuccedoNavigationRail extends StatelessWidget {
  final Destinations activeDestination;
  final Widget body;

  SuccedoNavigationRail({@required this.activeDestination, @required this.body})
      : assert(activeDestination != null),
        assert(body != null);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      body: body,
      destinations: [
        Destination(
          active: activeDestination == Destinations.agenda,
          label: "Agenda",
          icon: Icons.assignment,
          onPressed: () {
            print("Go to 'Agenda'!");
          },
        ),
        Destination(
          active: activeDestination == Destinations.backlog,
          label: "Backlog",
          icon: Icons.folder,
          onPressed: () {
            print("Go to 'Backlog'!");
          },
        ),
        Destination(
          active: activeDestination == Destinations.calendar,
          label: "Calendar",
          icon: Icons.calendar_today_outlined,
          onPressed: () {
            print("Go to 'Calendar'!");
          },
        ),
        Destination(
          active: activeDestination == Destinations.reminders,
          label: "Reminders",
          icon: Icons.notifications,
          onPressed: () {
            print("Go to 'Reminders'!");
          },
        ),
      ],
    );
  }
}

/// See https://material.io/components/navigation-rail
class NavigationRail extends StatelessWidget {
  final FloatingActionButton floatingActionButton;
  final List<Destination> destinations;
  final Widget body;
  final Key activeDestination;

  NavigationRail({this.destinations = const [], this.floatingActionButton, @required this.body, this.activeDestination})
      : assert(body != null);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 72,
          child: Column(
            children: destinations,
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: body,
        )
      ],
    );
  }
}

class Destination extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function onPressed;
  final bool active;

  Destination({@required this.label, @required this.icon, this.onPressed, this.active = false})
      : assert(label != null),
        assert(icon != null);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Container(
        width: 72,
        height: 72,
        child: Column(
          children: [
            Icon(
              icon,
              color: active ? Colors.yellow : Colors.grey,
              size: 30.0,
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    TestBench(
      child: SuccedoNavigationRail(
        activeDestination: Destinations.agenda,
        body: Text("<Agenda page placeholder>"),
      ),
    ),
  );
}
