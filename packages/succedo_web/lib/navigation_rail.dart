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
      title: "Succedo",
      body: body,
      destinations: [
        Destination(
          label: "Agenda",
          icon: Icons.assignment,
          active: activeDestination == Destinations.agenda,
          onPressed: () {
            print("Go to 'Agenda'!");
          },
        ),
        Destination(
          label: "Backlog",
          icon: Icons.folder,
          active: activeDestination == Destinations.backlog,
          onPressed: () {
            print("Go to 'Backlog'!");
          },
        ),
        Destination(
          label: "Calendar",
          icon: Icons.calendar_today_outlined,
          active: activeDestination == Destinations.calendar,
          onPressed: () {
            print("Go to 'Calendar'!");
          },
        ),
        Destination(
          label: "Reminders",
          icon: Icons.notifications,
          active: activeDestination == Destinations.reminders,
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
  final String title;
  final FloatingActionButton floatingActionButton;
  final List<Destination> destinations;
  final Widget body;
  final Key activeDestination;

  NavigationRail({
    this.destinations = const [],
    this.floatingActionButton,
    @required this.body,
    this.activeDestination,
    @required this.title,
  })  : assert(body != null),
        assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 57,
            width: double.infinity,
            padding: EdgeInsets.only(left: 20),
            color: Theme.of(context).primaryColor,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 72,
                  color: Colors.grey[200],
                  child: Column(
                    children: [
                      ...destinations,
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: body,
                )
              ],
            ),
          ),
        ],
      ),
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
              color: _iconColor(context),
              size: 30.0,
            ),
            Text(
              label,
              style: _textStyle(context),
            ),
          ],
        ),
      ),
    );
  }

  Color _iconColor(BuildContext context) {
    if (active) {
      return Theme.of(context).indicatorColor;
    } else {
      return Theme.of(context).backgroundColor;
    }
  }

  TextStyle _textStyle(BuildContext context) {
    if (active) {
      return TextStyle(
        fontWeight: FontWeight.bold,
      );
    } else {
      return TextStyle();
    }
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
